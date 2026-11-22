#!/usr/bin/env python3
"""Prepare the compatibility release from the frozen 1.7.2 paclet only.

Run this file, then pack the printed directory with PacletManager`PackPaclet.
The original release, development sources, and installed paclets are never edited.
"""

from pathlib import Path
import difflib
import hashlib
import json
import re
import zipfile

REPO = Path(__file__).resolve().parents[1]
HERE = REPO / "build" / "1.7.2.1"
BASE = REPO / "Paclets/EcoEvo-1.7.2.paclet"
BASE_SHA256 = "13b5efe8a1471391d9ca1e7cd09df164f0fe50dd858c5c217f0bb8c112f05a9b"
STAGE = HERE / "EcoEvo-1.7.2.1"


def mask_comments(source):
    """Mask nested WL comments, preserving offsets, strings, and line endings."""
    result = list(source)
    i, depth, in_string = 0, 0, False
    while i < len(source):
        if depth:
            if source.startswith("(*", i):
                result[i:i + 2] = "  "
                depth += 1
                i += 2
            elif source.startswith("*)", i):
                result[i:i + 2] = "  "
                depth -= 1
                i += 2
            else:
                if source[i] != "\n":
                    result[i] = " "
                i += 1
        elif in_string:
            if source[i] == "\\":
                i += 2
            else:
                if source[i] == '"':
                    in_string = False
                i += 1
        elif source.startswith("(*", i):
            result[i:i + 2] = "  "
            depth = 1
            i += 2
        else:
            if source[i] == '"':
                in_string = True
            i += 1
    assert depth == 0 and not in_string
    return "".join(result)


def main():
    assert hashlib.sha256(BASE.read_bytes()).hexdigest() == BASE_SHA256
    with zipfile.ZipFile(BASE) as archive:
        payload = {
            item.filename.removeprefix("EcoEvo-1.7.2/"): archive.read(item)
            for item in archive.infolist() if not item.is_dir()
        }
    original = payload["EcoEvo/EcoEvo.m"].decode("utf-8")
    source = original
    edits = []

    def replace(pattern, replacement, expected, *, regex=False):
        nonlocal source
        matches = list(re.finditer(pattern if regex else re.escape(pattern), mask_comments(source)))
        assert len(matches) == expected, (pattern, len(matches), expected)
        for match in reversed(matches):
            text = match.expand(replacement) if regex else replacement
            source = source[:match.start()] + text + source[match.end():]
        edits.append({"pattern": pattern, "occurrences": len(matches)})

    replace('_->_InterpolatingFunction|_TemporalData',
            '_->(_InterpolatingFunction|_TemporalData|_TimeSeries)', 1)
    replace('_->_InterpolatingFunction[_]|_TemporalData[_]',
            '_->(_InterpolatingFunction[_]|_TemporalData[_]|_TimeSeries[_])', 1)
    replace(r'\b([A-Za-z$][A-Za-z0-9$]*)_TemporalData\b',
            r'\1:(_TemporalData|_TimeSeries)', 17, regex=True)
    replace('(_InterpolatingFunction|_TemporalData)',
            '(_InterpolatingFunction|_TemporalData|_TimeSeries)', 10)
    replace('_TemporalData,', '_TemporalData|_TimeSeries,', 5)

    replace('variables[[1,2,0]]', 'Head[variables[[1,2]]]', 4)
    for expr, count in [('sol[[1,2]]', 7), ('#[[2]]', 5), ('el[[2]]', 1), ('variables[[1,2]]', 2)]:
        replace(f'Head[{expr}]===TemporalData',
                f'MemberQ[{{TemporalData,TimeSeries}},Head[{expr}]]', count)
    replace('Head[#/.sol]==TemporalData',
            'MemberQ[{TemporalData,TimeSeries},Head[#/.sol]]', 1)
    replace('{InterpolatingFunction,TemporalData}',
            '{InterpolatingFunction,TemporalData,TimeSeries}', 2)

    for prop in ['FirstTime', 'LastTime']:
        replace(f'#["{prop}s"][[1]]', f'#["{prop}"]', 4)
    for expr in ['f', 'f1']:
        replace(f'({expr}["LastTimes"]-{expr}["FirstTimes"])[[1]]',
                f'({expr}["LastTime"]-{expr}["FirstTime"])', 1)

    receivers = [
        ('f1', 1), ('f2', 1),
        ('TimeSeriesWindow[f1,{varmin,varmax}]', 1),
        ('TimeSeriesWindow[f2,{varmin,varmax}]', 1),
        ('(#/.sol)', 5), ('#', 1), ('#[[2]]', 5), ('ts', 1),
        ('(Subscript[gu, sp]/.sol)', 1),
    ]
    for receiver, count in receivers:
        value = receiver + '["Values"]'
        replace(value, 'Normal[' + value + ']', count)

    # Aggregate and external variables may have no model-assigned line style.
    replace('If[linestyles==={},ls=LineStyle[var],ls=ModPart[linestyles,i]];',
            'If[linestyles==={},ls=Replace[LineStyle[var],_LineStyle->{}],ls=ModPart[linestyles,i]];', 1)

    # Restore trait colors in abundance plots; trait-free plots use a component gradient.
    replace('Color[Subscript[gu, 1]]',
            'Color[Subscript[If[tr===None,First[gcomps[gu]],tr], 1]]', 3)

    # Resolve abundance weights before Moment numerically evaluates a numeric guild name.
    replace('Chop[Table[Subscript[gu, i],{i,\\[ScriptCapitalN][gu]}]]],1]/.wa',
            'Chop[Table[Subscript[gu, i],{i,\\[ScriptCapitalN][gu]}]/.wa]],1]', 1)

    # Classify the assembled equations before adding constraints for NSolve.
    ecoeq_definition = ('EcoEq[attributesin:(_?AttributesQ):{},Gsin:(_?GsQ):{},'
                        'init:(_?VariablesQ):{},vars:(__List|All):All,opts___?OptionQ]:=')
    helper = '''(* Polynomial dependence is tested only in the equilibrium unknowns. *)
polynomialEquationsQ[eqns_List,unks_List]:=AllTrue[
\teqns/.Equal[lhs_,rhs_]:>(lhs-rhs),
\tMatchQ[#,True|False]||PolynomialQ[#,unks]&
];


(* Distinct symbolic numeric markers preserve parameter dependence when testing
   the assembled equations. Unrecognized expressions remain unrestricted. *)
numericalEquationsQ[eqns_List,unks_List]:=Quiet[Module[{marker,residuals},
\tSetAttributes[marker,NumericFunction];
\tresiduals=eqns/.Equal[lhs_,rhs_]:>(lhs-rhs);
\tAllTrue[residuals/.Thread[unks->Array[marker,Length[unks]]],
\t\tNumericQ[#]||MatchQ[#,True|False]&]
]];


'''
    replace(ecoeq_definition, helper + ecoeq_definition, 1)
    replace('attributes,nonvars,nonfixedvars,fixedvars,Gs,removets,eqns,unks,newunk,sol,res},',
            'attributes,nonvars,nonfixedvars,fixedvars,Gs,removets,eqns,nsolveeqns,unks,newunk,sol,res},', 1)
    replace('method=="NSolve",\n\tunks=nonfixedvars;\n\tVPrint[3,"unks=",unks];',
            'method=="NSolve",\n\tunks=nonfixedvars;\n\tVPrint[3,"unks=",unks];\n'
            '\tIf[!MemberQ[Flatten[nsolveopts],HoldPattern[(Method->_)|(Method:>_)]],\n'
            '\t\tnsolveopts=Append[nsolveopts,Method->If[polynomialEquationsQ[eqns,unks],"EndomorphismMatrix",Automatic]]\n'
            '\t];\n'
            '\tnsolveeqns=If[numericalEquationsQ[eqns,unks],Append[eqns,Element[unks,Reals]],eqns];', 1)
    replace('With[{eqns=eqns,unks=unks,options=Sequence@@nsolveopts},PrintCall[Global`sol=NSolve[eqns,unks,options]]]',
            'With[{callEqns=nsolveeqns,callUnks=unks,callOptions=Sequence@@nsolveopts},'
            'PrintCall[Global`sol=NSolve[callEqns,callUnks,callOptions]]]', 1)
    replace('sol=NSolve[eqns,unks,Evaluate[Sequence@@nsolveopts]];\n'
            '\tIf[Head[sol]===NSolve,sol=NSolve[eqns,unks,Reals,Evaluate[Sequence@@nsolveopts]]]',
            'sol=NSolve[nsolveeqns,unks,Evaluate[Sequence@@nsolveopts]]', 1)
    replace('SolveOpts->{},NSolveOpts->{Method->"EndomorphismMatrix"},FindRootOpts->{},FindRootsOpts->{},',
            'SolveOpts->{},NSolveOpts->{},FindRootOpts->{},FindRootsOpts->{},', 1)
    replace('$EcoEvoVersion="1.7.2 (September 1, 2023)";',
            '$EcoEvoVersion="1.7.2.1 (November 22, 2026)";', 1)

    active = mask_comments(source)
    assert '["FirstTimes"]' not in active and '["LastTimes"]' not in active
    assert 'variables[[1,2,0]]' not in active
    assert active.count('["Values"]') == 17
    assert len(re.findall(r'(?:===|==)TemporalData\b', active)) == 0
    assert len(re.findall(r'\w+_TemporalData\b', active)) == 0
    payload['EcoEvo/EcoEvo.m'] = source.encode('utf-8')
    info = payload['PacletInfo.m'].decode('utf-8')
    assert info.count('Version -> "1.7.2"') == 1
    payload['PacletInfo.m'] = info.replace('Version -> "1.7.2"', 'Version -> "1.7.2.1"').encode('utf-8')

    documentation = 'EcoEvo/Documentation/English/ReferencePages/Symbols/NSolveEcoEq.nb'
    page = payload[documentation].decode('utf-8')
    old_default = ('RowBox[{"{", \n'
                   '     RowBox[{"Method", "\\[Rule]", "\\\"\\<EndomorphismMatrix\\>\\\""}], "}"}]')
    assert page.count(old_default) == 1
    page = page.replace(old_default, 'RowBox[{"{", "}"}]')
    old_note = '" to find ecological equilibria."'
    assert page.count(old_note) == 1
    page = page.replace(old_note,
        '" to find ecological equilibria. The default method is EndomorphismMatrix for '
        'polynomial equations in the equilibrium unknowns, and Automatic otherwise. '
        'An explicit Method in NSolveOpts takes precedence, including Method -> Automatic. '
        'Fully numerical equations are solved for real unknown values; equations with unresolved '
        'symbolic parameters remain unrestricted."')
    old_retry_note = '"If NSolve fails, it is attempted again with domain Reals."'
    assert page.count(old_retry_note) == 1
    page = page.replace(old_retry_note,
        '"An empty solution list is accepted. If NSolve remains unevaluated, '
        'NSolveEcoEq reports failure; no automatic retry is performed."')
    payload[documentation] = page.encode('utf-8')
    changed_files = ['EcoEvo/EcoEvo.m', 'PacletInfo.m', documentation]

    expected = json.loads((REPO / "Release/1.7.2.1/payload-sha256.json").read_text())["files"]
    actual = {name: hashlib.sha256(content).hexdigest() for name, content in payload.items()}
    assert actual == expected, "Prepared payload differs from the tested release"

    for name, content in payload.items():
        assert not Path(name).is_absolute() and '..' not in Path(name).parts
        target = STAGE / name
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(content)
    for name in changed_files:
        target = HERE / 'source' / name
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(payload[name])
    with zipfile.ZipFile(BASE) as archive:
        diff = ''
        for name in changed_files:
            before = archive.read('EcoEvo-1.7.2/' + name).decode('utf-8')
            after = payload[name].decode('utf-8')
            diff += ''.join(difflib.unified_diff(before.splitlines(True), after.splitlines(True),
                                               fromfile='EcoEvo-1.7.2/' + name,
                                               tofile='EcoEvo-1.7.2.1/' + name))
    (HERE / 'compatibility.patch').write_text(diff)
    (HERE / 'preparation.json').write_text(json.dumps({
        'baseline': str(BASE), 'baseline_sha256': BASE_SHA256,
        'stage': str(STAGE), 'changed_payload_files': changed_files,
        'edits': edits,
    }, indent=2) + '\n')
    print(f'Prepared {STAGE}')
    print(f'Reviewable diff: {HERE / "compatibility.patch"}')


if __name__ == '__main__':
    main()

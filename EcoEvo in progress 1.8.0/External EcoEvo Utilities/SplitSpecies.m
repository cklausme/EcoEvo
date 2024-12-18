(* ::Package:: *)

(************************************************************************)
(* This file was generated automatically by the Mathematica front end.  *)
(* It contains Initialization cells from a Notebook file, which         *)
(* typically will have the same name as this file except ending in      *)
(* ".nb" instead of ".m".                                               *)
(*                                                                      *)
(* This file is intended to be loaded into the Mathematica kernel using *)
(* the package loading commands Get or Needs.  Doing so is equivalent   *)
(* to using the Evaluate Initialization Cells menu command in the front *)
(* end.                                                                 *)
(*                                                                      *)
(* DO NOT EDIT THIS FILE.  This entire file is regenerated              *)
(* automatically each time the parent Notebook file is saved in the     *)
(* Mathematica front end.  Any changes you make to this file will be    *)
(* overwritten.                                                         *)
(************************************************************************)



Package["EcoEvo`"]
PackageExport["SplitSpecies"]


SplitSpecies::usage=
"SplitSpecies[\!\(\*
StyleBox[\"sol\", \"TI\"]\), \!\(\*
StyleBox[\"target\", \"TI\"]\)] splits \!\(\*
StyleBox[\"target\", \"TI\"]\) in two.
SplitSpecies[\!\(\*
StyleBox[\"sol\", \"TI\"]\), \!\(\*
StyleBox[\"target\", \"TI\"]\), \!\(\*
StyleBox[\"dtraits\", \"TI\"]\)] uses distance \!\(\*
StyleBox[\"dtraits\", \"TI\"]\).";


SplitSpecies[sol_(*?AttributesAndVariablesQ*),target_,dtraitsin_:Automatic,opts___?OptionQ]:=Module[{
func=FuncStyle["SplitSpecies"],
(* options *)
(* other variables *)
gu,sp,dtraits,ecomps,tmp(*,gs*)
},

Block[{\[ScriptCapitalN],verbosity,func="SplitSpecies"},

If[modelloaded!=True,Message[EcoEvoGeneral::nomodel];Return[$Failed]];

(* set verbosity *)

If[Evaluate[Verbose/.Flatten[{opts,Options[SplitSpecies]}]]===True,
	verbosity=Max[1,Evaluate[Verbosity/.Flatten[{opts,Options[SplitSpecies]}]]],
	verbosity=Evaluate[Verbosity/.Flatten[{opts,Options[SplitSpecies]}]]
];
If[IntegerQ[Global`$verbosity],verbosity=Max[Global`$verbosity,verbosity]];

(* figure out target sp *)
{gu,sp}=LookUp[target][[{2,-1}]];
VPrint[3,"{gu,sp}=",{gu,sp}];

Which[
	dtraitsin===Automatic,
	dtraits=Join[
		Flatten[Table[trait[gcomp]->0,{trait,gtraits[gu]},{gcomp,gcomps[gu]}]],
		Table[trait->0,{trait,gtraits[gu]}]
	],
	NumericQ[dtraitsin],
	dtraits=Join[
		Flatten[Table[trait[gcomp]->dtraitsin,{trait,gtraits[gu]},{gcomp,gcomps[gu]}]],
		Table[trait->dtraitsin,{trait,gtraits[gu]}]
	],
	Else,
	dtraits=ExpandTraits[dtraitsin]
];
VPrint[3,"dtraits=",dtraits];

(*gs=ExpandGs[ExtractVarCovs[sol]];*)
(*Print["gs=",gs];*)

(* figure out number of species in guilds *)
Set\[ScriptCapitalN][ExtractAttributes[sol],ExtractVariables[sol]];
VPrint[3,"\[ScriptCapitalN]=",Table[\[ScriptCapitalN][gu],{gu,guilds}]];

(* split target species' extensive components *)
ecomps=Select[gcomps[gu],comptype[#]=="Extensive"&];
tmp=sol/.Table[(Subscript[var, sp]->val_)->(Subscript[var, sp]->val/2),{var,ecomps}];
(*Print[tmp];*)

(* add new species' components *)
tmp=Join[tmp,Table[Subscript[var, \[ScriptCapitalN][gu]+1]->(Subscript[var, sp]/.tmp),{var,gcomps[gu]}]];
(*Print[tmp];*)

(* add new species' traits *)
tmp=Join[tmp,
	Table[If[NumericQ[Subscript[trait, sp]/.tmp],Subscript[trait, \[ScriptCapitalN][gu]+1]->((Subscript[trait, sp]/.tmp)+(trait/.dtraits))],{trait,gtraits[gu]}],
	Flatten[Table[If[NumericQ[Subscript[trait[gcomp], sp]/.tmp],Subscript[trait[gcomp], \[ScriptCapitalN][gu]+1]->((Subscript[trait[gcomp], sp]/.tmp)+(trait[gcomp]/.dtraits))],{trait,gtraits[gu]},{gcomp,gcomps[gu]}]]
];
tmp=DeleteNulls[tmp];
(*Print[tmp];*)

(* add new species' Gs *)
tmp=Join[tmp,
	Table[If[NumericQ[Subscript[Var[trait], sp]/.tmp],Subscript[Var[trait], \[ScriptCapitalN][gu]+1]->(Subscript[Var[trait], sp]/.tmp)],{trait,gtraits[gu]}],
	Flatten[Table[If[NumericQ[Subscript[Var[trait][gcomp], sp]/.tmp],Subscript[Var[trait][gcomp], \[ScriptCapitalN][gu]+1]->(Subscript[Var[trait][gcomp], sp]/.tmp)],{trait,gtraits[gu]},{gcomp,gcomps[gu]}]]
];
tmp=DeleteNulls[tmp];
(*Print[tmp];*)

(* change target species' traits *)
If[NumericQ[Subscript[gtraits[gu][[1]], sp]/.tmp],
	tmp=RuleListSubtract[tmp,Table[Subscript[trait, sp]->(trait/.dtraits),{trait,gtraits[gu]}]],
	tmp=RuleListSubtract[tmp,Flatten[Table[Subscript[trait[gcomp], sp]->(trait[gcomp]/.dtraits),{trait,gtraits[gu]},{gcomp,gcomps[gu]}]]]
];
(*Print[tmp];*)

Return[Sort[tmp]];
]];


Options[SplitSpecies]={Verbose->False,Verbosity->0};




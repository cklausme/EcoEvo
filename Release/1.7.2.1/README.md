# EcoEvo 1.7.2.1 maintenance source

This branch starts at tag `1.7.2`. The runtime and paclet are the tested
November 22, 2026 build; the later development tree is outside this branch.
`ReleaseNotes.md` is the public release summary. `verification.json` records
the tested archive/runtime checksums and validation results.

Editable source is `EcoEvo/EcoEvo.nb`, with its matching release runtime in
`EcoEvo/EcoEvo.m`. The original notebook structure and unaffected code cells
are preserved. `NSolveEcoEq.nb` in the authored documentation also reflects
the new solver policy.

## Reproduce the distribution

Use Python 3.9+ and Mathematica (the build was verified with 15.0.1):

```sh
python3 Tools/prepare_1_7_2_1.py
```

Then evaluate from the repository root in Mathematica:

```wl
Get["Tools/build_1_7_2_1.wl"]
```

The archive is written under `build/1.7.2.1/`. The preparation script checks
the frozen `Paclets/EcoEvo-1.7.2.paclet` checksum and applies exact-count
substitutions. It reuses the already built documentation, including its
search index, and patches the compiled NSolveEcoEq page. No Eclipse rebuild
is required for this maintenance release. The build checks all 178 staged
files against `payload-sha256.json` before packing. ZIP timestamps may make
a rebuilt archive's checksum differ; the payload checksums must agree.
The checked-in `Paclets/EcoEvo-1.7.2.1.paclet` is the original tested archive.

Run the 125-test suite as described in `Tests/README.md`. The source notebook
should be saved before rebuilding if editing it; the Wolfram build script
checks that its parsed code agrees with the frozen tested runtime. Notebook
resaves may change whitespace; top-level Null expressions introduced by
package-export formatting are ignored in that comparison.
Future code changes require a new reviewed manifest and tests.

## Publication status

This is local release preparation. PacletSite.m and PacletSite.mz remain at
the baseline version. No new tag, remote push, GitHub release, cloud-document
publication, or package installation is part of this step. The historical
`finish paclet.wl` is retained; use the maintenance commands above for this
build rather than its full development/documentation workflow.

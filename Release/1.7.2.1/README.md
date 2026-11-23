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

## Publication

The local `PacletSite.m` and `PacletSite.mz` advertise 1.7.2.1 and preserve all
19 previous release entries. Their catalog contents are identical, and the
new entry matches the tested archive's metadata. PacletManager ranks 1.7.2.1
above all previous versions. See `verification.json` for checks and hashes.

To regenerate the indexes from the repository root:

```wl
Needs["PacletManager`"];
PacletManager`BuildPacletSiteFiles[Directory[]]
```

The maintenance source is on `codex/release-1.7.2.1`, tagged `1.7.2.1`.
The separate `codex/publish-1.7.2.1` branch starts at the public site's
`master` and adds only `Paclets/EcoEvo-1.7.2.1.paclet`, `PacletSite.m`, and
`PacletSite.mz`. Publish both branches and the tag, then merge the three-file
catalog update into `master`. Keep the maintenance source branch separate
from the development sources on `master`.

Create a GitHub release for tag `1.7.2.1`, use `ReleaseNotes.md` for its
description, and attach the checked-in `Paclets/EcoEvo-1.7.2.1.paclet`.
The archive's SHA-256 must be
`e85548e256a52454cd148dbc46dcb86b26f8f7bce3202bbc4ee0d819782ef600`.
After publication, verify both the release download and the catalog download
against this checksum. `verification.json` records local validation before
publication; it is not evidence of a remote push or public installation.

The historical `finish paclet.wl` is retained; use the maintenance commands
above for this build rather than its full development/documentation workflow.
Cloud documentation publication is a separate task.

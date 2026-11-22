# Maintenance-release tests

Run in a fresh Mathematica kernel from the repository root:

```wl
Needs["MUnit`"];
TestReport["Tests/Compatibility.wlt"]
```

The suite loads `EcoEvo/EcoEvo.m` relative to the test file. It contains 125
checks for the TimeSeries, TraitMean, NSolveEcoEq, PlotDynamics, and PlotGuild
changes. It does not install a paclet or write external files. NSolve uses its
default RandomSeeding -> 1234; the other checks are deterministic.

To check an extracted paclet's actual loader, use a separate fresh kernel:

```wl
pacletRoot = "/absolute/path/to/extracted/EcoEvo-1.7.2.1";
PacletDirectoryLoad[pacletRoot];
FindFile["EcoEvo`EcoEvo`"]  (* verify this resolves inside pacletRoot *)
Global`$EcoEvoPatchTestSource = FileNameJoin[{pacletRoot, "EcoEvo", "Kernel", "init.m"}];
Needs["MUnit`"];
TestReport["Tests/Compatibility.wlt"]
PacletDirectoryUnload[pacletRoot];
```

The test source override is local to that kernel. Start another fresh kernel
before testing a different build.

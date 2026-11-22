# EcoEvo 1.7.2.1

November 22, 2026

Maintenance release based on EcoEvo 1.7.2.

- Restore compatibility with Mathematica 15 TimeSeries representations,
  endpoint properties, and value containers.
- Fix TraitMean abundance weighting for numeric guild identifiers.
- Update NSolveEcoEq's default method selection: use EndomorphismMatrix for
  polynomial equations in the equilibrium unknowns and Automatic otherwise.
  Fully numerical equations constrain the unknowns to real values; equations
  with symbolic parameters remain unrestricted. Explicit Method options take
  precedence, including Automatic. This retains the Ricker extinction root
  and avoids duplicated SI equilibria from Automatic's polynomial solver.
- Fix PlotDynamics styling for aggregate and external variables.
- Fix automatic PlotGuild colors for guilds whose names differ from their
  component names, including PlotInv abundance insets. Use the trait gradient
  when plotting a trait, or the first component gradient for trait-free plots.
- Update the bundled NSolveEcoEq documentation.

Validation: 125/125 tests passed against the prepared runtime and 125/125
through the packed loader in fresh Mathematica 15.0.1 ARM kernels. The author
also reported a clean testbed pass. Older Mathematica kernels were not run;
the existing MathematicaVersion -> "10+" declaration is retained.

The download is EcoEvo-1.7.2.1.paclet. Close existing EcoEvo kernels before
loading an updated installation. To replace an earlier test build with this
same version, use PacletInstall[..., ForceVersionInstall -> True].

# EcoEvo
Analyze species- and trait-based ecological and eco-evolutionary models, including Adaptive Dynamics, in Mathematica.

## Documentation

- There is extensive documentation, including Tutorials, installed in Mathematica's built-in Documentation.  Go to Help - Wolfram Documentation and search for EcoEvo or run

      EcoEvoDocs

- Documentation is also [available online](https://www.wolframcloud.com/obj/EcoEvo/docs/guide/EcoEvo.nb).

## Installation
- Requires Mathematica 10.0 or higher.

- Install directly with

      PacletInstall["https://github.com/cklausme/EcoEvo/releases/download/v1.2.1/EcoEvo-1.2.1.paclet"]

- Alternatively, [download the latest release](https://github.com/cklausme/EcoEvo/releases), distributed as a `.paclet` file, and install it using the `PacletInstall` function in Mathematica.  For example, assuming that the file `EcoEvo-1.2.1.paclet` was downloaded into the directory `~/Downloads`, evaluate

      Needs["PacletManager`"]
      PacletInstall["~/Downloads/EcoEvo-1.2.1.paclet"]

## Usage

- Load the pacakge with

      <<EcoEvo`

## Questions / Comments

- Email klausme1@msu.edu

## Version History

### v1.2.1 (December 25, 2019)

- Lots of little tweaks to make quasi-steady states easier to work with
  - new function: JoinFirst (fixed prob w/ Normal@Merge in v10.0)
  - EcoEqns: add [t]
  - EcoEq: use JoinFirst to remove duplicates
  - EcoEq: remove identity placeholders
  - SelectEcoStable, EcoStableQ, FindEcoAttractor: added Fixed option

### v1.2.0 (December 8, 2019)

- New functions:
    - TotalAbundance: sums abundance within a guild
    - TraitMean: mean trait within a guild (CWM)
    - TraitVariance: trait variance within a guild (CWV)
- 🙀 Renamed some functions:
    - TotalAbundance -> WeightedAbundance
    - Avg, Var, Cov -> TemporalMean, TemporalVariance, TemporalCovariance
- Fixed Reinterpolation to work at arbitrary levels
- SetModel now assigns colors and styles for traits and guilds without subscripts
- PlotDynamics works on mean traits

### v1.1.1 (November 18, 2019)

- Reinterpolation - new function to recast a function of one or more InterpolatingFunctions
- TotalAbundance - uses Reinterpolation
- InvSPS - added InvSPS::whenevents warning
- InvSPS - fixed problem with periodic & structured pops

### v1.1.0 (October 22, 2019)

 - Improvements to PlotTAD, WhittakerPlot, PrestonPlot -- now handle multiple components and averaging well.  
 - Added TotalAbundance function.
  
### v1.0.3 (October 8, 2019)

 - Added TemporalRuleListQ and let *Slice work on non-TemporalRuleLists
 - Added ExtremumValues, MaximumValues, and MinimumValues
 - Extended FindExtrema, FindMaxima, and FindMinima to TemporalData, Lists, and RuleLists

### v1.0.2 (September 26, 2019)

 - Added Guild support to PlotZNGI, rearranged its syntax 
 
### v1.0.1 (September 23, 2019)

 - Fixed a problem with documentation
 
### v1.0.0 (September 15, 2019)

 - Now tested with Mathematica v10.0 to 12.0.
 - Documentation updated

### v0.9.10 (June 30, 2019)

- Lots of behind-the-scenes cleaning.
- Changed notation from Nsp to ScriptCapitalN for number of species.

### v0.9.3 (Sept 16, 2018)

- Initial public beta release.
- Behind-the-scenes changes will be made, but functionality should remain constant.
- Made variable names the identifiers for model parts.

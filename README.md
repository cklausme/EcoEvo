# EcoEvo
Analyze species- and trait-based ecological and eco-evolutionary models, including Adaptive Dynamics, in Mathematica.

## Installation
- Requires Mathematica 10.0 or higher.

- Install directly with

      PacletInstall["https://github.com/cklausme/EcoEvo/releases/download/v0.9.10/EcoEvo-0.9.10.paclet"]

- Alternatively, [download the latest release](https://github.com/cklausme/EcoEvo/releases), distributed as a `.paclet` file, and install it using the `PacletInstall` function in Mathematica.  For example, assuming that the file `EcoEvo-0.9.10.paclet` was downloaded into the directory `~/Downloads`, evaluate

      Needs["PacletManager`"]
      PacletInstall["~/Downloads/EcoEvo-0.9.10.paclet"]

## Usage

- Load the pacakge with

      <<EcoEvo`

## Documentation

- There is extensive documentation, including Tutorials, installed in Mathematica's built-in Documentation.  Go to Help - Wolfram Documentation and search for EcoEvo or run

      Documentation`HelpLookup["EcoEvo"];

## Questions / Comments

- Email klausme1@msu.edu

## Version History

### v0.9.3 (Sept 16, 2018)

- Initial public beta release.
- Behind-the-scenes changes will be made, but functionality should remain constant.

### v0.9.10 (June 30, 2019)

- Lots of behind-the-scenes cleaning.
- Changed notation from Nsp to ScriptCapitalN for number of species.
- Made variable names the identifiers for model parts.

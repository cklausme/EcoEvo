# EcoEvo
Analyze species- and trait-based ecological and eco-evolutionary models, including Adaptive Dynamics, in Mathematica.

## Documentation

- There is extensive documentation, including Tutorials, installed in Mathematica's built-in Documentation.  Go to Help - Wolfram Documentation and search for EcoEvo or run

      EcoEvoDocs

- Documentation is also [available online](https://www.wolframcloud.com/obj/EcoEvo/docs/guide/EcoEvo.nb).

## Installation
- Requires Mathematica 10.0 or higher.

- Install directly with

      PacletInstall["EcoEvo", "Site" -> "http://raw.githubusercontent.com/cklausme/EcoEvo/master"]

- Alternatively, [download the latest release](https://github.com/cklausme/EcoEvo/releases), distributed as a `.paclet` file, and install it using the `PacletInstall` function in Mathematica.  For example, assuming that the file `EcoEvo-1.4.1.paclet` was downloaded into the directory `~/Downloads`, evaluate

      Needs["PacletManager`"]
      PacletInstall["~/Downloads/EcoEvo-1.4.1.paclet"]

## Usage

- Load the pacakge with

      <<EcoEvo`

## Questions / Comments

- Email klausme1@msu.edu

## [Version History](https://github.com/cklausme/EcoEvo/releases)

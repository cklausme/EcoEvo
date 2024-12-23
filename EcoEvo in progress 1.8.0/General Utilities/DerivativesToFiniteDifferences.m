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
PackageExport["DerivativesToFiniteDifferences"]


DerivativesToFiniteDifferences::usage=
"DerivativesToFiniteDifferences[\!\(\*
StyleBox[\"expr\", \"TI\"]\)] replaces derivatives in \!\(\*
StyleBox[\"expr\", \"TI\"]\) with centered finite differences.";


DerivativesToFiniteDifferences:=Module[{d},
	d[expr_,{}]:=expr;
	d[expr_,{var_,var2___}]:=1/\[Epsilon][ToString@var] Subtract@@(d[expr,{var2}]/. {{var->var+\[Epsilon][ToString@var]/2},{var->var-\[Epsilon][ToString@var]/2}});

	Simplify@*ReplaceAll[Derivative[o__][u_][x__]:>d[u[x],ConstantArray@@@(Transpose[{{x},{o}}])//Flatten]]
];




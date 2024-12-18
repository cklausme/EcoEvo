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
PackageExport["InequalityToInterval"]


InequalityToInterval::usage="InequalityToInterval[\!\(\*
StyleBox[\"ineq\", \"TI\"]\)] converts inequality \!\(\*
StyleBox[\"ineq\", \"TI\"]\) to an Interval.";


(* based on <https://mathematica.stackexchange.com/a/271537/> by Somnium *)
InequalityToInterval[ineq_]:=ineq/.{
	Greater[max_:\[Infinity],var:Except[_?NumericQ],min_:-\[Infinity]]->var\[Element]Interval[{min,max}],
	GreaterEqual[max_:\[Infinity],var:Except[_?NumericQ],min_:-\[Infinity]]->var\[Element]Interval[{min,max}],
	Less[min_:-\[Infinity],var:Except[_?NumericQ],max_:\[Infinity]]->var\[Element]Interval[{min,max}],
	LessEqual[min_:-\[Infinity],var:Except[_?NumericQ],max_:\[Infinity]]->var\[Element]Interval[{min,max}],
	var_->var\[Element]Interval[{-\[Infinity],\[Infinity]}]
};


SetAttributes[InequalityToInterval,Listable];

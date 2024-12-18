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
PackageExport["PrintCall"]


PrintCall::usage="PrintCall[\!\(\*
StyleBox[\"expr\", \"TI\"]\)] prints \!\(\*
StyleBox[\"expr\", \"TI\"]\) unevaluated.";


(* based on <https://mathematica.stackexchange.com/a/158902/6358> by Szabolcs and <https://mathematica.stackexchange.com/a/161310/6358> by Carl Woll *)
SetAttributes[PrintCall,HoldAll]
(*PrintCall[expr_]:=CellPrint@ExpressionCell[Defer[expr],CellMargins\[Rule]{{60,Inherited},{Inherited,Inherited}},CellGroupingRules\[Rule]"GraphicsGrouping",CellDingbat\[Rule]"Running:"]*)
(*PrintCall[expr_]:=Print[Defer[expr]];*)
(*PrintCall[expr_,dingbat_:""]:=CellPrint@ExpressionCell[Defer[expr],CellMargins\[Rule]{{60,Inherited},{Inherited,Inherited}},CellGroupingRules\[Rule]"GraphicsGrouping",CellDingbat\[Rule]dingbat]*)
(*PrintCall[expr_,dingbat_:""]:=With[{expr2=Defer[expr/.Sequence[]\[Rule]Null]},
	CellPrint@ExpressionCell[Defer[expr2],CellMargins\[Rule]{{60,Inherited},{Inherited,Inherited}},CellGroupingRules\[Rule]"GraphicsGrouping",CellDingbat\[Rule]dingbat]
];*)
(*PrintCall[expr_,dingbat_:""]:=
CellPrint@ExpressionCell[Defer[expr]/.Sequence[]\[Rule]Nothing,CellMargins\[Rule]{{60,Inherited},{Inherited,Inherited}},CellGroupingRules\[Rule]"GraphicsGrouping",CellDingbat\[Rule]dingbat]*)
(*PrintCall[expr_,dingbat_:""]:=CellPrint@ExpressionCell[DeleteCases[Unevaluated@Defer[expr],Verbatim[Sequence][],\[Infinity]],
CellBaseline\[Rule]Scaled[0.005],CellMargins\[Rule]{{66,Inherited},{Inherited,Inherited}},CellGroupingRules\[Rule]"GraphicsGrouping",CellDingbat\[Rule]dingbat]
*)
(*PrintCall[expr_]:=Print@DeleteCases[Unevaluated@Defer[expr],Verbatim[Sequence][],\[Infinity]];*)
PrintCall[expr_,dingbat_:""]:=Print[DeleteCases[Unevaluated@Defer[expr],Verbatim[Sequence][],\[Infinity]]];

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
PackageExport["MakeInterpolatingFunctionPeriodic"]


MakeInterpolatingFunctionPeriodic::usage="MakeInterpolatingFunctionPeriodic[\!\(\*
StyleBox[\"if\", \"TI\"]\)] makes InterpolatingFunction \!\(\*
StyleBox[\"if\", \"TI\"]\) periodic.";


MakeInterpolatingFunctionPeriodic[if_InterpolatingFunction]:=Module[{
	dorder=if[[2,3]],
	ngrid=if[[2,4]]},
	Which[
		if[[4,1]]===Developer`PackedArrayForm,
		ReplacePart[if,{
			{2,7}->{1}, (* set periodic flag *)
			{2,4}->ngrid-1 ,(* decrease ngrid by 1 *)
			{4,2}->Drop[if[[4,2]],-1], (* remove last abscissa *)
			{4,3}->Drop[if[[4,3]],-dorder-1] (* remove last dorder+1 values *)
		}]
	,
		ListQ[if[[4,1]]],
		ReplacePart[if,{
			{2,7}->{1}, (* set periodic flag *)
			{2,4}->ngrid-1, (* decrease ngrid by 1 *)
			{4}->Drop[if[[4]],-1] (* remove last point *)
		}]
	]
];


(*(* modified from <https://mathematica.stackexchange.com/a/235451/6358> by MichaelE2 *)
MakeInterpolatingFunctionPeriodic[if_InterpolatingFunction]:=Module[{periodify},
	periodify[list_List]:=Append[list,First@list];
	Interpolation[
		Transpose@{if["Grid"],
		periodify@Most@if["ValuesOnGrid"],
		periodify@Most@Derivative[1][if]["ValuesOnGrid"],
		periodify@Most@Derivative[2][if]["ValuesOnGrid"]},
		PeriodicInterpolation\[Rule]True]
];*)

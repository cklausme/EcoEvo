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
PackageExport["AddSubscripts"]


AddSubscripts::usage="AddSubscripts[\!\(\*
StyleBox[\"array\", \"TI\"]\), \!\(\*
StyleBox[\"sub\", \"TI\"]\)] adds subscript \!\(\*
StyleBox[\"sub\", \"TI\"]\) to all elements of list/matrix \!\(\*
StyleBox[\"array\", \"TI\"]\).";


AddSubscripts[array_?VectorQ,sub_]:=Replace[array,sym_->Subscript[sym, sub],{1}];
AddSubscripts[array_?MatrixQ,sub_]:=Replace[array,sym_->Subscript[sym, sub],{2}];



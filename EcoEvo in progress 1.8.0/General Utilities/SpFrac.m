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
PackageExport["SpFrac"]


SpFrac::usage="\!\(\*
StyleBox[\"SpFrac\", \"InlineCode\"]\)\!\(\*
StyleBox[\"[\", \"InlineCode\"]\)\!\(\*
StyleBox[\"sp\", \"TI\"]\)\!\(\*
StyleBox[\",\", \"InlineCode\"]\)\!\(\*
StyleBox[\" \", \"InlineCode\"]\)\!\(\*
StyleBox[\"nsp\", \"TI\"]\)] gives \!\(\*
StyleBox[\"sp\", \"TI\"]\)/(\!\(\*
StyleBox[\"nsp\", \"TI\"]\)\!\(\*
StyleBox[\"+\", \"TI\",\nFontSlant->\"Plain\"]\)1).";


SpFrac[sp_Integer,nsp_Integer]:=sp/(nsp+1.);
(*SpFrac[sp_Integer,nsp_Integer]:=(sp-1)/(nsp-0.99999);*)
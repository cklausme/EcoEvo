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
PackageExport["VectorPlot1D"]


VectorPlot1D::usage="VectorPlot1D[\!\(\*
StyleBox[\"f\", \"TI\"]\), {\!\(\*
StyleBox[\"x\", \"TI\"]\), \!\(\*
StyleBox[SubscriptBox[\"x\", \"min\"], \"TI\"]\), \!\(\*
StyleBox[SubscriptBox[\"x\", \"max\"], \"TI\"]\)}] plots arrows in the direction of \!\(\*
StyleBox[\"f\", \"TI\"]\) from \!\(\*
StyleBox[SubscriptBox[\"x\", \"min\"], \"TI\"]\) to \!\(\*
StyleBox[SubscriptBox[\"x\", \"max\"], \"TI\"]\).";


VectorPlot1D[func_,{var_,varmin_,varmax_},opts___?OptionQ]:=Module[{
vectorpoints,markerwidth,markeraspectratio,markerspacing,
rt,lt,varrange,w,h},

(* handle options *)
vectorpoints=Evaluate[VectorPoints/.Flatten[{opts,Options[VectorPlot1D]}]];
markerwidth=Evaluate[MarkerWidth/.Flatten[{opts,Options[VectorPlot1D]}]];
If[markerwidth==Automatic,markerwidth=varrange/vectorpoints];
markeraspectratio=Evaluate[MarkerAspectRatio/.Flatten[{opts,Options[VectorPlot1D]}]];
markerspacing=Evaluate[MarkerSpacing/.Flatten[{opts,Options[VectorPlot1D]}]];

varrange=varmax-varmin;
w=(1-markerspacing)markerwidth;
h=w*markeraspectratio;

(*Print[{w,h}];*)

rt[x_]:=Triangle[{{x+w/2,0},{x-w/2,(h/2)Sqrt[3]/2},{x-w/2,-(h/2)Sqrt[3]/2}}];
lt[x_]:=Triangle[{{x-w/2,0},{x+w/2,(h/2)Sqrt[3]/2},{x+w/2,-(h/2)Sqrt[3]/2}}];
	
Show[Graphics[Table[
	Which[
		(func/.var->x)<0&&(func/.var->x-w/2)<0&&(func/.var->x+w/2)<0,lt[x],
		(func/.var->x)>0&&(func/.var->x-w/2)>0&&(func/.var->x+w/2)>0,rt[x]
	]
	,{x,varmin,varmax,varrange/vectorpoints}]],Axes->{True,False}]
];


Options[VectorPlot1D]={VectorPoints->21,MarkerWidth->Automatic,MarkerAspectRatio->0.5,MarkerSpacing->0.5};



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
PackageExport["Reinterpolation"]


Reinterpolation::usage="Reinterpolation[\!\(\*
StyleBox[\"f\", \"TI\"]\)] reinterpolates a function containing one or more InterpolatingFunctions.";


Reinterpolation[f_,opts___?OptionQ]:=Module[{
(* options *)
interpolationopts,interpolationpoints,
(* other variables *)
xmin,xmax,ifs,grid,tmp},
	
(* handle options *)
interpolationopts=FilterRules[Flatten[{opts,Options[Reinterpolation]}],Options[Interpolation]];
interpolationpoints=Evaluate[InterpolationPoints/.Flatten[{opts,Options[Reinterpolation]}]];

ifs=Cases[f,_InterpolatingFunction,{0,\[Infinity]}];
If[ifs=={},Return[f]];

If[interpolationpoints===Automatic,
	grid=Union[Flatten[Through[ifs["Grid"]],1]],
(* using ifs\[LeftDoubleBracket]1,1\[RightDoubleBracket] because ifs\[LeftDoubleBracket]1\[RightDoubleBracket]["Domain"] fails sometimes?! - see "wtf domain.nb" *)
	(*grid=Flatten[Subdivide[Sequence@@#,interpolationpoints]&/@ifs\[LeftDoubleBracket]1,1\[RightDoubleBracket]]*)
	{xmin,xmax}=ifs[[1,1,1]];
	grid=Table[x,{x,xmin,xmax,(xmax-xmin)/(interpolationpoints-1)}];
];
(*Print["grid=",grid];*)

Quiet[
	tmp=Interpolation[Table[{Sequence@@val,f/.(if_InterpolatingFunction->if[Sequence@@val])},{val,grid}],Evaluate[Sequence@@interpolationopts]],
	{InterpolatingFunction::dmval}];

tmp[[1]]=ifs[[1,1]]; (* fix domain *)

Return[tmp]
];


Options[Reinterpolation]={InterpolationPoints->Automatic};

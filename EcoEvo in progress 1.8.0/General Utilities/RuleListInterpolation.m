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
PackageExport["RuleListInterpolation"]


RuleListInterpolation::usage=
"RuleListInterpolation[\!\(\*
StyleBox[\"list\", \"TI\"]\)] converts a list of the form {{\!\(\*
StyleBox[SubscriptBox[\"x\", \"1\"], \"TI\"]\),\!\(\*
StyleBox[SubscriptBox[\"rulelist\", \"1\"], \"TI\"]\)},{\!\(\*
StyleBox[SubscriptBox[\"x\", \"2\"], \"TI\"]\),\!\(\*
StyleBox[SubscriptBox[\"rulelist\", \"2\"], \"TI\"]\)},...} to a rule list of InterpolatingFunctions.";


RuleListInterpolation[listin_List,opts___?OptionQ]:=Module[{interpolationopts,list},
	interpolationopts=FilterRules[Flatten[{opts,Options[RuleListInterpolation]}],Options[Interpolation]];
	
	list=DeleteDuplicates[listin,#1[[1]]==#2[[1]]&];
	If[Length[list]!=Length[listin],Message[RuleListInterpolation::dup,Length[listin]-Length[list]]];
	Normal@Merge[Map[ReplaceAll[#[[2]],(var_->val_(*?NumericQ*))->(var->{#[[1]],val})]&,list],Interpolation[#,Evaluate[Sequence@@interpolationopts]]&]
];


RuleListInterpolation[assoc_Association,opts___?OptionQ]:=Module[{interpolationopts,vars},
	interpolationopts=FilterRules[Flatten[{opts,Options[RuleListInterpolation]}],Options[Interpolation]];
	vars=Keys[assoc[[1]]];
	Table[var->Interpolation[KeyValueMap[{ToExpression[#1],var/.#2}&,assoc],Evaluate[Sequence@@interpolationopts]],{var,vars}]
];


RuleListInterpolation[pd_ParametricDynamics,opts___?OptionQ]:=Module[{tmp},
	tmp=MapAt[#["Values"]&,Normal[pd],{All,2,1,2}];
	RuleListInterpolation[tmp,opts]
]


Options[RuleListInterpolation]={};


RuleListInterpolation::dup="Warning: `1` duplicate point(s) deleted.";




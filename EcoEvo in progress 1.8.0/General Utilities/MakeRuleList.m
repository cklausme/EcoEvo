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
PackageExport["MakeRuleList"]


MakeRuleList::usage=
"MakeRuleList[\!\(\*
StyleBox[\"var\", \"TI\"]\), \!\(\*
StyleBox[\"n\", \"TI\"]\), \!\(\*
StyleBox[\"val\", \"TI\"]\)] makes a list of \!\(\*
StyleBox[\"n\", \"TI\"]\) rules where \!\(\*
StyleBox[\"var\", \"TI\"]\) takes on value \!\(\*
StyleBox[\"val\", \"TI\"]\).
MakeRuleList[\!\(\*
StyleBox[\"var\", \"TI\"]\), \!\(\*
StyleBox[\"n\", \"TI\"]\), {\!\(\*
StyleBox[\"min\", \"TI\"]\), \!\(\*
StyleBox[\"max\", \"TI\"]\)}] makes a list of \!\(\*
StyleBox[\"n\", \"TI\"]\) rules where \!\(\*
StyleBox[\"var\", \"TI\"]\) ranges from \!\(\*
StyleBox[\"min\", \"TI\"]\) to \!\(\*
StyleBox[\"max\", \"TI\"]\).
MakeRuleList[\!\(\*
StyleBox[\"vars\", \"TI\"]\), \!\(\*
StyleBox[\"n\", \"TI\"]\), \!\(\*
StyleBox[\"vals\", \"TI\"]\)] makes a list of rules between corresponding elements of the lists \!\(\*
StyleBox[\"vars\", \"TI\"]\) and \!\(\*
StyleBox[\"vals\", \"TI\"]\).
MakeRuleList[\!\(\*
StyleBox[\"var\", \"TI\"]\), \!\(\*
StyleBox[\"ns\", \"TI\"]\), \!\(\*
StyleBox[\"val\", \"TI\"]\)] makes a list of rules with dimensions \!\(\*
StyleBox[\"ns\", \"TI\"]\) where \!\(\*
StyleBox[\"var\", \"TI\"]\) takes on value \!\(\*
StyleBox[\"val\", \"TI\"]\).
MakeRuleList[{\!\(\*SubscriptBox[
StyleBox[\"var\", \"TI\"], \(1\)]\), \[Ellipsis], \!\(\*SubscriptBox[
StyleBox[\"var\", \"TI\"], \(nv\)]\)}, {\!\(\*SubscriptBox[
StyleBox[\"n\", \"TI\"], \(1\)]\), \[Ellipsis] , \!\(\*SubscriptBox[
StyleBox[\"n\", \"TI\"], \(nv\)]\)}, {{\!\(\*SubscriptBox[
StyleBox[\"min\", \"TI\"], \(1\)]\), \!\(\*SubscriptBox[
StyleBox[\"max\", \"TI\"], \(1\)]\)}, \[Ellipsis] , {\!\(\*SubscriptBox[
StyleBox[\"min\", \"TI\"], \(nv\)]\), \!\(\*SubscriptBox[
StyleBox[\"max\", \"TI\"], \(nv\)]\)}}] makes a list of rules with dimensions \!\(\*
StyleBox[\"ns\", \"TI\"]\) where \!\(\*SubscriptBox[
StyleBox[\"var\", \"TI\"], \(i\)]\) ranges from \!\(\*SubscriptBox[
StyleBox[\"min\", \"TI\"], \(i\)]\) to \!\(\*SubscriptBox[
StyleBox[\"max\", \"TI\"], \(i\)]\).";


MakeRuleList[vars_List,n_,vals_List]:=Flatten[Table[Subscript[vars[[j]],i]->vals[[j]],{i,n},{j,Length[vars]}]];


MakeRuleList[vars_List,ns_List,vals_List]:=Module[{n,min,max},
	Thread[
		Flatten[Table[Map[Subscript[#,i]&,vars],{i,Times[Sequence@@ns]}]]
		->
		Flatten[Outer[List,Sequence@@Table[
			n=ns[[j]];
			If[ListQ[vals[[j]]],{min,max}=vals[[j]],min=max=vals[[j]]];
			Table[min+(max-min)*(i-1)/(n-1),{i,n}]
		,{j,Length[ns]}]]]
		]
	]


MakeRuleList[var_,n_,val_]:=Table[Subscript[var,i]->val/.\[IGrave]->i,{i,n}];


MakeRuleList[var_,n_,{min_?NumericQ,max_?NumericQ}]:=Table[Subscript[var,i]->min+(max-min)*(i-1)/(n-1),{i,n}];


MakeRuleList[var_,ns_List,val_]:=
	Thread[
		Table[Subscript[var,i],{i,Times[Sequence@@ns]}]->
		Table[val,{i,Times[Sequence@@ns]}]
	]


SetAttributes[MakeRuleList,HoldAll];

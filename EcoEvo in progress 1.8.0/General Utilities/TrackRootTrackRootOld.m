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
PackageExport["TrackRoot"]
PackageExport["TrackRootOld"]


TrackRootOld::usage=
"TrackRoot[\!\(\*
StyleBox[\"eqns\", \"TI\"]\), {{\!\(\*
StyleBox[\"x\", \"TI\"]\), \!\(\*SubscriptBox[
StyleBox[\"x\", \"TI\"], \(0\)]\)}, {\!\(\*
StyleBox[\"y\", \"TI\"]\), \!\(\*SubscriptBox[
StyleBox[\"y\", \"TI\"], \(0\)]\)},...}, {\!\(\*
StyleBox[\"par\", \"TI\"]\), \!\(\*
StyleBox[\"initpar\", \"TI\"]\), \!\(\*
StyleBox[\"parmin\", \"TI\"]\), \!\(\*
StyleBox[\"parmax\", \"TI\"]\)}] tracks a root of \!\(\*
StyleBox[\"eqns\", \"TI\"]\), varying \!\(\*
StyleBox[\"par\", \"TI\"]\) from \!\(\*
StyleBox[\"parmin\", \"TI\"]\) to \!\(\*
StyleBox[\"parmax\", \"TI\"]\), starting at \!\(\*
StyleBox[\"initpar\", \"TI\"]\).";


TrackRoot::badmtd="The Method option should be a built-in method name (\"Direct\" or \"PseudoArcLength\")";


TrackRootOld[eqns_List,unksnics_List,{par_Symbol,ipar_?NumericQ,parmin_?NumericQ,parmax_?NumericQ},opts___?OptionQ]:=Module[{
(* options *)
method,findrootopts,ndsolveopts,smin,smax,
(* other variables *)
parname,j,whenevents,unks,subrule,breaks,isol,ics,deqns,sol,s1,s2,res,respart,pts},

(* handle options *)
method=Evaluate[Method/.Flatten[{opts,Options[TrackRoot]}]];
findrootopts=Evaluate[FindRootOpts/.Flatten[{opts,Options[TrackRoot]}]];
ndsolveopts=Evaluate[NDSolveOpts/.Flatten[{opts,Options[TrackRoot]}]];
smin=Evaluate[SMin/.Flatten[{opts,Options[TrackRoot]}]];
smax=Evaluate[SMax/.Flatten[{opts,Options[TrackRoot]}]];

parname=ToString[par];

(* jacobian *)
j:=D[eqns,{unks}]/.subrule;

unks=unksnics[[All,1]];
(*Print["unks=",unks];*)

(* use FindRoot to improve initial guess *)
isol=FindRoot[eqns/.par->ipar,unksnics,Evaluate[Sequence@@findrootopts]];
If[Global`debug,Print["isol=",isol]];

whenevents={};

Which[
	method=="Direct",
	subrule=Table[unk->unk[par],{unk,unks}];
	ics=Table[unk[ipar]==(unk/.isol),{unk,unks}];
	deqns=Map[#==0&,D[eqns/.subrule,par]];
	(*deqns=Map[#\[Equal]0&,eqns/.subrule];*)
	(*maxev[param_?NumericQ]:=Module[{jac},jac=D[eqns,{unks}]/.subrule;Print[jac];Max[Re[Eigenvalues[jac]]]];
	whenevents=Join[whenevents,{
		WhenEvent[Evaluate[Max[Re[Eigenvalues[j]]]==0],"StopIntegration"](*,
		WhenEvent[maxev[par]==0,"StopIntegration"]*)
	}];
	Print["whenevents="];Print[whenevents];*)
	(* track root with NDSolve *)
	sol=NDSolve[Join[deqns,ics,whenevents],unks,{par,parmin,parmax},Evaluate[Sequence@@ndsolveopts]][[1]];
	Return[sol]
	,
	method=="PseudoArcLength",
	subrule=Append[Table[unk->unk[s],{unk,unks}],par->par[s]];
	ics=Join[Table[unk[0]==(unk/.isol),{unk,unks}],{par[0]==ipar}];
	whenevents=Join[whenevents,{
		WhenEvent[par'[s]==0,AppendTo[breaks,s]],
		WhenEvent[par[s]==parmax,"StopIntegration"],
		WhenEvent[par[s]==parmin,"StopIntegration"](*,
		(*WhenEvent[Evaluate[Max[Re[Eigenvalues[j]]]==0],"StopIntegration"]*)
		WhenEvent[Evaluate[Max[Re[Eigenvalues[j]]]==0],Print["Stability change at ",parname,"=",par[s]," \[Lambda]=",Eigenvalues[j]];AppendTo[breaks,s]]*)
	}];
	(*Print["whenevents="];Print[whenevents];*)
	Global`deqns=deqns=Join[
		Map[#==0&,eqns/.subrule],
		(*Map[#==0&,D[eqns/.subrule,s]],*)
		{Total[D[unks/.subrule,s]]^2+D[par[s],s]^2==1},
		(*Table[unk'[0]\[Equal]0,{unk,unks}],*)
		{par'[0]==1}
	];
	If[Global`debug,Print["deqns="];Print[deqns]];
	(* track root with NDSolve *)
	breaks={}; (* capture turning points *)
	sol=NDSolve[Join[deqns,ics,whenevents],Join[unks,{par}],{s,smin,smax},Evaluate[Sequence@@ndsolveopts]][[1]];
	(* beginning and ending s *)
	{s1,s2}=(par/.sol)["Domain"][[1]];
	(* add endpoints to breaks *)
	breaks=Sort[Join[{s1,s2},breaks]];
	(*Print["breaks=",breaks];*)
	(* construct interpolatingfunctions (unk vs par) for each segment (between breaks) *)
	res={};
	Do[
		respart={};
		Do[
			(*Global`pts=pts=Transpose[{(par/.sol)["Coordinates"]\[LeftDoubleBracket]1\[RightDoubleBracket],(par/.sol)["ValuesOnGrid"],(unk/.sol)["ValuesOnGrid"]}];*)
			Global`pts=pts=DeleteDuplicates@Join[
				{{breaks[[i]],par[breaks[[i]]],unk[breaks[[i]]]}/.sol},
				Transpose[{(par/.sol)["Coordinates"][[1]],(par/.sol)["ValuesOnGrid"],(unk/.sol)["ValuesOnGrid"]}],
				{{breaks[[i+1]],par[breaks[[i+1]]],unk[breaks[[i+1]]]}/.sol}
				];
			AppendTo[respart,unk->Interpolation[Select[pts,breaks[[i]]<=#[[1]]<=breaks[[i+1]]&][[All,2;;3]],"ExtrapolationHandler"->{Indeterminate&,"WarningMessage"->False}]];
		,{unk,unks}];
		AppendTo[res,respart];
	,{i,Length[breaks]-1}];
	Return[res]
	,
	Else,
	Message[TrackRoot::badmtd];Return[$Failed]
];

]


TrackRoot[eqns_List,unksnics_List,{par_Symbol,ipar_?NumericQ,parmin_?NumericQ,parmax_?NumericQ},opts___?OptionQ]:=Module[{
(* options *)
method,findrootopts,ndsolveopts,smin,smax,
(* other variables *)
parname,j,whenevents,unks,subrule,breaks,isol,ics,deqns,sol,s1,s2,res,respart,pts},

(* handle options *)
method=Evaluate[Method/.Flatten[{opts,Options[TrackRoot]}]];
findrootopts=Evaluate[FindRootOpts/.Flatten[{opts,Options[TrackRoot]}]];
ndsolveopts=Evaluate[NDSolveOpts/.Flatten[{opts,Options[TrackRoot]}]];
smin=Evaluate[SMin/.Flatten[{opts,Options[TrackRoot]}]];
smax=Evaluate[SMax/.Flatten[{opts,Options[TrackRoot]}]];

parname=ToString[par];

(* jacobian *)
j:=D[eqns,{unks}]/.subrule;

unks=unksnics[[All,1]];
(*Print["unks=",unks];*)

(* use FindRoot to improve initial guess *)
isol=FindRoot[eqns/.par->ipar,unksnics,Evaluate[Sequence@@findrootopts]];
If[Global`debug,Print["isol=",isol]];

whenevents={};

Which[
	method=="Direct",
	subrule=Table[unk->unk[par],{unk,unks}];
	ics=Table[unk[ipar]==(unk/.isol),{unk,unks}];
	deqns=Map[#==0&,D[eqns/.subrule,par]];
	maxev[param_?NumericQ]:=Module[{jac},jac=D[eqns,{unks}]/.subrule;Print[jac];Max[Re[Eigenvalues[jac]]]];
	whenevents=Join[whenevents,{
		WhenEvent[Evaluate[Max[Re[Eigenvalues[j]]]==0],"StopIntegration"](*,
		WhenEvent[maxev[par]==0,"StopIntegration"]*)
	}];
	Print["whenevents="];Print[whenevents];
	(* track root with NDSolve *)
	sol=NDSolve[Join[deqns,ics,whenevents],unks,{par,parmin,parmax},Evaluate[Sequence@@ndsolveopts]][[1]];
	Return[sol]
	,
	method=="PseudoArcLength",
	subrule=Append[Table[unk->unk[s],{unk,unks}],par->par[s]];
	ev[param_?NumericQ,state_]:=ReIm/@Eigenvalues[j/.par[s]->param/.Thread[(unks/.subrule)->state]];
	ics=Join[
		Table[unk[0]==(unk/.isol),{unk,unks}],
		{par[0]==ipar,\[Lambda][0]==ev[ipar,Table[(unk/.isol),{unk,unks}]]}];
	If[Global`debug,Print["ics="];Print[ics]];
	whenevents=Join[whenevents,{
		WhenEvent[par'[s]==0,AppendTo[breaks,s]],
		WhenEvent[par[s]==parmax,"StopIntegration"],
		WhenEvent[par[s]==parmin,"StopIntegration"],
		WhenEvent[Max[\[Lambda][s][[All,1]]]==0,AppendTo[breaks,s]]
	}];
	(*Print["whenevents="];Print[whenevents];*)
	Global`deqns=deqns=Join[
		Map[#==0&,eqns/.subrule],
		(*Map[#==0&,D[eqns/.subrule,s]],*)
		{Total[D[unks/.subrule,s]]^2+D[par[s],s]^2==1},
		(*Table[unk'[0]\[Equal]0,{unk,unks}],*)
		{par'[0]==1},
		{\[Lambda][s]==ev[par[s],unks/.subrule]}
	];
	If[Global`debug,Print["deqns="];Print[deqns]];
	(* track root with NDSolve *)
	breaks={}; (* capture bifurcation points *)
	sol=NDSolve[Join[deqns,ics,whenevents],Join[unks,{par,\[Lambda]}],{s,smin,smax},Evaluate[Sequence@@ndsolveopts]][[1]];
	(* beginning and ending s *)
	{s1,s2}=(par/.sol)["Domain"][[1]];
	(* add endpoints to breaks *)
	breaks=Sort[Join[{s1,s2},breaks]];
	(*Print["breaks=",breaks];*)
	(* construct interpolatingfunctions (unk vs par) for each segment (between breaks) *)
	res={};
	Do[
		respart={};
		Do[
			pts=DeleteDuplicatesBy[Chop@Join[
				{{breaks[[i]],par[breaks[[i]]],unk[breaks[[i]]]}/.sol},
				Transpose[{(par/.sol)["Coordinates"][[1]],(par/.sol)["ValuesOnGrid"],(unk/.sol)["ValuesOnGrid"]}],
				{{breaks[[i+1]],par[breaks[[i+1]]],unk[breaks[[i+1]]]}/.sol}
			],First];
			AppendTo[respart,unk->Interpolation[Select[pts,breaks[[i]]<=#[[1]]<=breaks[[i+1]]&][[All,2;;3]],"ExtrapolationHandler"->{Indeterminate&,"WarningMessage"->False}]];
		,{unk,unks}];
		pts=DeleteDuplicatesBy[Chop@Join[
			{{breaks[[i]],par[breaks[[i]]],\[Lambda][breaks[[i]]]}/.sol},
			Transpose[{(par/.sol)["Coordinates"][[1]],(par/.sol)["ValuesOnGrid"],(\[Lambda]/.sol)["ValuesOnGrid"]}],
			{{breaks[[i+1]],par[breaks[[i+1]]],\[Lambda][breaks[[i+1]]]}/.sol}
		],First];
		pts=Map[{#[[1]],#[[2]],#[[3]] . {1,I}}&,pts];
		AppendTo[respart,Eigenvalues->Interpolation[Select[pts,breaks[[i]]<=#[[1]]<=breaks[[i+1]]&][[All,2;;3]],"ExtrapolationHandler"->{Indeterminate&,"WarningMessage"->False}]];
		AppendTo[res,respart];
	,{i,Length[breaks]-1}];
	Return[res]
	,
	Else,
	Message[TrackRoot::badmtd];Return[$Failed]
];

]


(* no initpar - assume initpar=parmin *)
TrackRoot[eqns_List,unksnics_List,{par_Symbol,parmin_?NumericQ,parmax_?NumericQ},opts___?OptionQ]:=
TrackRoot[eqns,unksnics,{par,parmin,parmin,parmax},opts,SMin->0];

(* one equation, one unknown, no {} *)
TrackRoot[eqns_,unksnics_List,{par_Symbol,ipar_?NumericQ,parmin_?NumericQ,parmax_?NumericQ},opts___?OptionQ]:=
TrackRoot[{eqns},{unksnics},{par,ipar,parmin,parmax},opts];


Options[TrackRoot]={FindRootOpts->{},NDSolveOpts->{},Method->"PseudoArcLength",SMin->-100,SMax->100};

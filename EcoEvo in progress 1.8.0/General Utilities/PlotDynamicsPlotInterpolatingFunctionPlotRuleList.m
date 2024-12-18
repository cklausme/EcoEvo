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
PackageExport["PlotDynamics"]
PackageExport["PlotInterpolatingFunction"]
PackageExport["PlotRuleList"]


PlotDynamics::usage=
"PlotDynamics[\!\(\*
StyleBox[\"sol\", \"TI\"]\)] plots the functions in \!\(\*
StyleBox[\"sol\", \"TI\"]\) across their entire domain.
PlotDynamics[\!\(\*
StyleBox[\"sol\", \"TI\"]\), \!\(\*
StyleBox[\"vars\", \"TI\"]\)] plots \!\(\*
StyleBox[\"vars\", \"TI\"]\) in \!\(\*
StyleBox[\"sol\", \"TI\"]\) across their entire domain.";

PlotInterpolatingFunction::usage=
"[Deprecated] PlotInterpolatingFunction[\!\(\*
StyleBox[\"sol\", \"TI\"]\)] plots the InterpolatingFunctions in \!\(\*
StyleBox[\"sol\", \"TI\"]\) across their entire domain.
PlotInterpolatingFunction[\!\(\*
StyleBox[\"sol\", \"TI\"]\), \!\(\*
StyleBox[\"vars\", \"TI\"]\)] plots \!\(\*
StyleBox[\"vars\", \"TI\"]\) in \!\(\*
StyleBox[\"sol\", \"TI\"]\) across their entire domain.";

PlotRuleList::usage=
"PlotRuleList[\!\(\*
StyleBox[\"sol\", \"TI\"]\)] plots the data in \!\(\*
StyleBox[\"sol\", \"TI\"]\) across their entire domain.
PlotRuleList[\!\(\*
StyleBox[\"sol\", \"TI\"]\), \!\(\*
StyleBox[\"vars\", \"TI\"]\)] plots \!\(\*
StyleBox[\"vars\", \"TI\"]\) in \!\(\*
StyleBox[\"sol\", \"TI\"]\) across their entire domain.";


Options[PlotDynamics]=
{Logged->False,PlotStyle->{},PlotMarkers->{},AxesLabel->Automatic,ColorLabels->True,LineStyles->{},PlotType->"Plot",Joined->True,PlotVariance->True,PlotRangePadding->Scaled[0.02],
Histogram->False,HistogramPoints->10^5,HistogramScale->0.1,HistogramPosition->0.08,HistogramOpts->{},HistogramOpacity->0.6,Exclusions->Automatic,
BaseStyle->{FontSize->12}};

Options[PlotInterpolatingFunction]=
{Logged->False,PlotStyle->{},PlotMarkers->{},AxesLabel->Automatic,LineStyles->{},PlotType->"Plot",Joined->True,PlotRangePadding->Scaled[0.02],
Histogram->False,HistogramPoints->10^5,HistogramScale->0.1,HistogramPosition->0.08,HistogramOpts->{},HistogramOpacity->0.6,Exclusions->Automatic,
BaseStyle->{FontSize->12}};

notPlotDynamicsOpts=Except[Alternatives@@Replace[Join[Options[PlotDynamics],Options[Plot],Options[ListPlot],Options[LogPlot]],h_[a_,_]:>h[a,_],1]];


PlotDynamics[sol_?RuleListQ,plotvarsin_List,opts___?OptionQ]:=

Module[{
(* options *)
logged,plotstyle,plotmarkers,axeslabel,colorlabels,plotopts,plotrange,linestyles,plottype,plotvariance,
histogram,histogrampoints,histogramscale,histogramposition,histogramopts,histogramopacity,exclusions,
(* other variables *)
lookup,gu,sp,vars,varvar,plotvars,plotcolor,ls,i,yaxislabel,xinit,xfinal,ifvars,tdvars,cvars,funcs,tdsol,
ifplot,tdplot,cplot,varplots,var,varvars,funcplots,if,
xrange,hmax,histo,hplot},
	
Block[{\[ScriptCapitalN]},

(*If[modelloaded\[NotEqual]True,Message[EcoEvoGeneral::nomodel];Return[$Failed]];*)

(* handle options *)

logged=Evaluate[Logged/.Flatten[{opts,Options[PlotDynamics]}]];
plotstyle=Evaluate[PlotStyle/.Flatten[{opts,Options[PlotDynamics]}]];
plotmarkers=Evaluate[PlotMarkers/.Flatten[{opts,Options[PlotDynamics]}]];
axeslabel=Evaluate[AxesLabel/.Flatten[{opts,Options[PlotDynamics]}]];
colorlabels=Evaluate[ColorLabels/.Flatten[{opts,Options[PlotDynamics]}]];
linestyles=Flatten[{Evaluate[LineStyles/.Flatten[{opts,Options[PlotDynamics]}]]}];
histogram=Evaluate[Histogram/.Flatten[{opts,Options[PlotDynamics]}]];
histogrampoints=Evaluate[HistogramPoints/.Flatten[{opts,Options[PlotDynamics]}]];
histogramscale=Evaluate[HistogramScale/.Flatten[{opts,Options[PlotDynamics]}]];
histogramposition=Evaluate[HistogramPosition/.Flatten[{opts,Options[PlotDynamics]}]];
histogramopts=Evaluate[HistogramOpts/.Flatten[{opts,Options[PlotDynamics]}]];
histogramopacity=Evaluate[HistogramOpacity/.Flatten[{opts,Options[PlotDynamics]}]];
plottype=Evaluate[PlotType/.Flatten[{opts,Options[PlotDynamics]}]];
plotvariance=Evaluate[PlotVariance/.Flatten[{opts,Options[PlotDynamics]}]];
exclusions=Evaluate[Exclusions/.Flatten[{opts,Options[PlotDynamics]}]];

vars=DeleteCases[sol[[All,1]],Parameter|Stable];
(*Print["vars=",vars];*)

(* figure out number of species in guilds *)
If[modelloaded,
	Do[
		\[ScriptCapitalN][gu]=Max[
			Table[Max[Select[vars,(#[[0]]===Subscript)&&(#[[1]]==gcomp)&][[All,2]]],{gcomp,gcomps[gu]}],
			Table[Max[Select[vars,(#[[0]]===Subscript)&&(#[[1]]==gtrait)&][[All,2]]],{gtrait,gtraits[gu]}]
		];
		If[\[ScriptCapitalN][gu]==-\[Infinity],\[ScriptCapitalN][gu]=0];
		If[Global`debug,Print["\[ScriptCapitalN][",gu,"]=",\[ScriptCapitalN][gu]]];
	,{gu,guilds}]
];

(*Print["plotvarsin=",plotvarsin];*)
If[plotvarsin==={All},
	plotvars=vars,
	plotvars={};
	Do[
		lookup=LookUp[var];
		If[MemberQ[{"gcomp","gtrait"},lookup[[1]]]&&Length[lookup]==3&&\[ScriptCapitalN][lookup[[2]]]!=0,
			Do[AppendTo[plotvars,Subscript[var,sp]],{sp,\[ScriptCapitalN][lookup[[2]]]}],
			AppendTo[plotvars,var]
		];
	,{var,plotvarsin}];
];
(*Print["plotvars=",plotvars];*)

(* little hack for Eigenvalues *)
If[plotvarsin==={Eigenvalues},
	{xinit,xfinal}=(Eigenvalues/.sol)["Domain"][[1]];
	Return[
		ReImPlot[(Eigenvalues/.sol)[x],{x,xinit,xfinal}]
	]
];

(* split into InterpolatingFunctions & constants, TemporalData, and functions *)
ifvars=Select[plotvars,(Head[#/.sol]==InterpolatingFunction)||NumericQ[#/.sol]&];
(*Print["ifvars=",ifvars];*)
tdvars=Select[plotvars,Head[#/.sol]==TemporalData||Head[#/.sol]==List&];
(*Print["tdvars=",tdvars];*)
(*Print["cvars=",cvars];*)
funcs=Complement[plotvars,ifvars,tdvars(*,cvars*)];
(*Print["funcs=",funcs];*)

If[plotstyle==={},
	ifplotstyle=cplotstyle={};
	i=0;
	Do[
		i++;
		If[linestyles==={},ls=LineStyle[var],ls=ModPart[linestyles,i]];
		lookup=LookUp[var];
		Which[
			(lookup[[1]]==="gcomp"||lookup[[1]]==="gtrait"||lookup[[1]]==="var")&&Length[lookup]==4,
			plotcolor[var]=Color[var][SpFrac[lookup[[4]],\[ScriptCapitalN][lookup[[2]]]]]
		,
			(lookup[[1]]==="gcomp"||lookup[[1]]==="gtrait")&&Length[lookup]==3,
			plotcolor[var]=Color[var]
		,
			lookup[[1]]==="pcomp"||lookup[[1]]==="aux",
			plotcolor[var]=Color[var]
		,
			Else,
			plotcolor[var]=ColorData[97][i];
		];
		AppendTo[ifplotstyle,{plotcolor[var],ls}]
	,{var,ifvars}];
	Do[
		i++;
		If[linestyles==={},ls=LineStyle[var],ls=ModPart[linestyles,i]];
		lookup=LookUp[var];
		Which[
			(lookup[[1]]==="gcomp"||lookup[[1]]==="gtrait"||lookup[[1]]==="var")&&Length[lookup]==4,
			plotcolor[var]=Color[var][SpFrac[lookup[[4]],\[ScriptCapitalN][lookup[[2]]]]]
		,
			(lookup[[1]]==="gcomp"||lookup[[1]]==="gtrait")&&Length[lookup]==3,
			plotcolor[var]=Color[var]
		,
			lookup[[1]]==="pcomp"||lookup[[1]]==="aux",
			plotcolor[var]=Color[var]
		,
			Else,
			plotcolor[var]=ColorData[97][i];
		];
		AppendTo[cplotstyle,{plotcolor[var],ls}]
	,{var,cvars}]
];

(*Print["axeslabel=",axeslabel];*)
If[axeslabel===Automatic,
	yaxislabel=SortBy[Union[Replace[plotvars,{Subscript[v_,sp_]->Subscript[v,"i"]},1]],index];
	If[colorlabels==True,yaxislabel=Replace[yaxislabel,v_->Style[v,plotcolor[v]],1]];
	axeslabel={t,Row[yaxislabel,","]}
];
(*Print["axeslabel=",axeslabel];*)


If[CompoundAnd[Table[comptype[var]==="Extensive",{var,plotvars}]],
	If[logged==True,
		plotrange=All,
		plotrange={-10^-8,All}
	],
	(*plotrange=(IntervalUnion[Sequence@@Table[range[var],{var,plotvars}]]/.{-\[Infinity]\[Rule]All,\[Infinity]\[Rule]All})\[LeftDoubleBracket]1\[RightDoubleBracket]*)
	plotrange=All
];

varplots={};

If[ifvars!={},
	(*Print["ifvars=",ifvars];*)
	{xinit,xfinal}=(ifvars[[1]]/.sol)["Domain"][[1]]; (* extract domain *)
	(*Print["{xinit,xfinal}=",{xinit,xfinal}];*)
	If[logged==True,
		Which[
			plottype=="ListPlot",
			plotopts=FilterRules[Flatten[{opts,AxesLabel->axeslabel,PlotStyle->ifplotstyle,Options[PlotDynamics]}],Options[ListPlot]];
			ifplot=ListLogPlot[ifvars/.sol,Evaluate[Sequence@@plotopts],PlotRange->plotrange]
		,
			Else,
			plotopts=FilterRules[Flatten[{opts,AxesLabel->axeslabel,PlotStyle->ifplotstyle,Options[PlotDynamics]}],Options[LogPlot]];
			ifplot=LogPlot[Evaluate[Table[var[x],{var,ifvars}]/.sol],{x,xinit,xfinal},Evaluate[Sequence@@plotopts],PlotRange->plotrange];
			varplots={};
		]
	,
		Which[
			plottype=="ListPlot",
			plotopts=FilterRules[Flatten[{opts,AxesLabel->axeslabel,PlotStyle->ifplotstyle,Options[PlotDynamics]}],Options[ListPlot]];
			ifplot=ListPlot[ifvars/.sol,Evaluate[Sequence@@plotopts],PlotRange->plotrange],
			Else,
			plotopts=FilterRules[Flatten[{Exclusions->exclusions,opts,AxesLabel->axeslabel,PlotStyle->ifplotstyle,Options[PlotDynamics]}],Options[Plot]];
			If[exclusions===Automatic,exclusions=Union@Select[Split[Flatten@Table[(var/.sol)["Coordinates"][[1]],{var,ifvars}]],Length[#]>1&][[All,1]]];
			(*Print["exclusions=",exclusions];*)
			ifplot=Plot[Evaluate[Table[Tooltip[var,ToString[var,StandardForm]],{var,ifvars}]/.(sol/.if_InterpolatingFunction->if[x])],{x,xinit,xfinal},Exclusions->exclusions,Evaluate[Sequence@@plotopts],PlotRange->plotrange];
			If[plotvariance==True,
				varplots=DeleteNulls@Table[
					varvar=var/.{Subscript[x_, i_]->Subscript[Var[x], i],Subscript[x_[n_], i_]->Subscript[Var[x][n], i],x_->Var[x],x_[n_]->Var[x][n]};
					(*Print[var," ",varvar];*)
					If[KeyExistsQ[sol,varvar],
						Plot[Evaluate[{var[x]+Sqrt[varvar[x]],var[x]-Sqrt[varvar[x]]}/.sol],{x,xinit,xfinal},
							Filling->{1->{{2},Directive[Opacity[0.2],plotcolor[var]]}},PlotStyle->None,PlotRange->All]
					]
				,{var,ifvars}]
			]
		]
	]
,
	ifplot={};
];
(*Print[ifplot];*)

If[tdvars!={},
	If[plotmarkers==={}&&(Joined/.{opts})===False,
		plotmarkers=Table[PlotMarker[var],{var,tdvars}]
	];
	If[plotmarkers=={},plotmarkers=None];
	plotopts=FilterRules[Flatten[{opts,AxesLabel->axeslabel,PlotStyle->plotstyle,PlotMarkers->plotmarkers,Options[PlotDynamics]}],Options[ListPlot]];
	tdsol=Select[sol,MemberQ[tdvars,#[[1]]]&];
	{xinit,xfinal}={InitialTime[tdsol],FinalTime[tdsol]};
	If[logged==True,
		tdplot=ListLogPlot[Normal[tdvars/.sol],Evaluate[Sequence@@plotopts],PlotRange->plotrange]
	,
		tdplot=ListPlot[Normal[tdvars/.sol],Evaluate[Sequence@@plotopts],AxesOrigin->{xinit,0},PlotRange->plotrange];
	]
,
	tdplot={};
];

If[cvars!={},
	plotopts=FilterRules[Flatten[{opts,AxesLabel->axeslabel,PlotStyle->cplotstyle,Options[PlotDynamics]}],Options[Plot]];
	cplot=Plot[Evaluate[cvars/.sol],{x,xinit,xfinal},Evaluate[Sequence@@plotopts],PlotRange->plotrange]
,
	cplot={}
];

If[funcs!={},
	funcplots=Table[
		func=funcs[[f]];
		(*Print[func/.sol];*)
		if=Reinterpolation[func/.sol];
		{xinit,xfinal}=if["Domain"][[1]]; (* extract domain *)
		(*Print["{xinit,xfinal}=",{xinit,xfinal}];*)
		plotopts=FilterRules[Flatten[{Exclusions->exclusions,opts,AxesLabel->axeslabel,Options[PlotDynamics]}],Options[Plot]];
		If[ListQ[plotstyle],ps=plotstyle[[f]],ps=plotstyle];
		If[exclusions===Automatic,exclusions=Union@Select[Split[Flatten@Table[(var/.sol)["Coordinates"][[1]],{var,ifvars}]],Length[#]>1&][[All,1]]];
		Plot[Evaluate[Tooltip[if[x],ToString[func,StandardForm]]],{x,xinit,xfinal},Exclusions->exclusions,PlotStyle->ps,Evaluate[Sequence@@plotopts]]
	,{f,Length[funcs]}]
,
	funcplots={};
];

If[histogram,
	xrange=(xfinal-xinit);
	hmax=Max[Table[
		histo[ifvar]=Histogram[Table[ifvar[t]/.sol,{t,xinit,xfinal,xrange/histogrampoints}],Automatic,"PDF",Evaluate[Sequence@@histogramopts]];
		GetPlotRange[histo[ifvar]][[2,2]]
	,{ifvar,ifvars}]];
	hplot=Graphics[
		Flatten[
		Table[{
			{Directive[EdgeForm[Directive[Thickness[Small],Opacity[histogramopacity]]],plotcolor[ifvar],Opacity[histogramopacity]]},
			Cases[histo[ifvar]/.NCache[_,vals_]->vals
			/.(Rectangle[List[x1_,y1_],List[x2_,y2_],optz___]->Rectangle[List[y1+xfinal+xrange*histogramposition,x1],List[y2*xrange/hmax*histogramscale+xfinal+xrange*histogramposition,x2],optz])
			/.(RectangleBox[List[x1_,y1_],List[x2_,y2_],optz___]->Rectangle[List[y1+xfinal+xrange*histogramposition,x1],List[y2*xrange/hmax*histogramscale+xfinal+xrange*histogramposition,x2],optz]),
			Rectangle[List[_,_],List[_,_],___],\[Infinity]]
		},{ifvar,ifvars}]]
		]
,
	hplot={}
];
(*Print[hplot];*)

If[histogram,
	Return[Show[ifplot,tdplot,cplot,hplot,funcplots,PlotRange->{{xinit,xfinal},All},PlotRangeClipping->False,ImagePadding->All(*{{20,400*histogramposition+250*histogramscale},{20,20}}*)]],
	Return[Show[ifplot,varplots,tdplot,(*cplot,*)funcplots]]
];
]];


(* if only one plotvar given, doesn't need to be in a list *)
PlotDynamics[sol_?RuleListQ,plotvarin:notPlotDynamicsOpts:All,opts___?OptionQ]:=(*(Print[1];*)PlotDynamics[sol,{plotvarin},opts];

(* if only a rule given, doesn't need to be in a list *)
PlotDynamics[sol_Rule,plotvarsin_List,opts___?OptionQ]:=PlotDynamics[{sol},plotvarsin,opts];
PlotDynamics[sol_Rule,plotvarin_Symbol,opts___?OptionQ]:=PlotDynamics[{sol},{plotvarin},opts];
PlotDynamics[sol_Rule,opts___?OptionQ]:=PlotDynamics[{sol},All,opts];

(* thread over sols *)
(*PlotDynamics[list_?RuleListListQ,rest___]:=Show[PlotDynamics[#,rest]&/@list];*)
PlotDynamics[list_?RuleListListQ,rest___]:=Show[PlotDynamics[#,rest]&/@list,PlotRange->All];

(* unpack ParametricDynamics - replaced by PlotParametricDynamics *)
(*PlotInterpolatingFunction[list_?ParametricDynamicsListQ,rest___]:=Show[PlotInterpolatingFunction[#,rest]&/@list,PlotRange->All];
PlotInterpolatingFunction[pd_ParametricDynamics,plotvarsin___,opts___?OptionQ]:=
	PlotInterpolatingFunction[RuleListInterpolation[pd[[1]]],plotvarsin,opts];*)

PlotInterpolatingFunction[sol_,plotvarsin___,opts___?OptionQ]:=PlotDynamics[sol,plotvarsin,opts,AxesLabel->None,PlotMarkers->None,Joined->False];

PlotRuleList[sol_,plotvarsin___,opts___?OptionQ]:=PlotDynamics[sol,plotvarsin,opts,AxesLabel->None,PlotMarkers->None,Joined->False];

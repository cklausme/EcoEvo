(* Run with TestReport in a fresh kernel. No installation or external file writes.
   NSolve uses its default RandomSeeding -> 1234.
   Override Global`$EcoEvoPatchTestSource to test an extracted paclet's runtime. *)
Get[If[ValueQ[Global`$EcoEvoPatchTestSource], Global`$EcoEvoPatchTestSource,
  FileNameJoin[{DirectoryName[DirectoryName[$TestFileName]],"EcoEvo","EcoEvo.m"}]]];

Begin["EcoEvoPatchTests`"];
near[a_, b_, tolerance_:10^-10] := TrueQ[Max[Abs[Flatten[{N[a-b]}]]] < tolerance];
plotted[g_] := MemberQ[{Graphics, Graphics3D}, Head[g]] &&
  Length[Cases[g, _Line | _Point | _Raster, Infinity]] > 0;
scalar = TimeSeries[{{0,2},{1,1},{2,2},{3,1},{4,2}}];
vector = TimeSeries[{{0,{2,4}},{1,{1,2}},{2,{2,4}}}];
empty = TimeSeries[{}];
rules = {testN -> scalar};
generic = TemporalData[{{2,1,2}}, {{0,2,1}}];
legacy = TemporalData[TimeSeries, {{{2,1,2}}, {{0,2,1}}, 1,
  {"Continuous",1}, {"Discrete",1}, 1,
  {ValueDimensions->1, ResamplingMethod->{"Interpolation",InterpolationOrder->1}}}, False, 10.];
line = Interpolation[{{0,1},{1,2},{2,3},{3,4},{4,5}}, InterpolationOrder->1];

VerificationTest[StringStartsQ[EcoEvo`$EcoEvoVersion,"1.7.2.1 "], True, TestID->"ReleaseVersion"]
VerificationTest[EcoEvo`TemporalRuleListQ[rules], True, TestID->"ScalarRecognition"]
VerificationTest[EcoEvo`TemporalDataFunctionQ[scalar[EcoEvo`t]], True, TestID->"AppliedRecognition"]
VerificationTest[EcoEvo`ParametricRuleListQ[{testN->scalar[testP]}], True, TestID->"ParametricRecognition"]
VerificationTest[Normal[scalar["Values"]], {2,1,2,1,2}, TestID->"ScalarValues"]
VerificationTest[Normal[vector["Values"]], {{2,4},{1,2},{2,4}}, TestID->"VectorValues"]
VerificationTest[Normal[empty["Values"]], {}, TestID->"EmptyValues"]
VerificationTest[EcoEvo`TemporalRuleListQ[{testN->empty}], True, TestID->"EmptyRecognition"]
VerificationTest[{EcoEvo`InitialTime[rules],EcoEvo`FinalTime[rules]}, {0,4}, TestID->"Endpoints"]
VerificationTest[EcoEvo`Slice[rules,1], {testN->1}, TestID->"PointSlice"]
VerificationTest[Normal[testN/.EcoEvo`Slice[rules,{1,3}]], {{1,1},{2,2},{3,1}}, TestID->"WindowSlice"]
VerificationTest[EcoEvo`FinalDerivatives[rules], {testN'->1}, TestID->"FinalDerivative"]
VerificationTest[near[EcoEvo`TemporalMean[scalar],8/5], True, TestID->"ScalarMean"]
VerificationTest[near[EcoEvo`TemporalVariance[scalar],6/25], True, TestID->"ScalarVariance"]
VerificationTest[near[EcoEvo`TemporalCovariance[scalar,scalar],6/25], True, TestID->"ScalarCovariance"]
VerificationTest[near[EcoEvo`TemporalMean[scalar,{EcoEvo`t,1,3}],4/3], True, TestID->"WindowMean"]
VerificationTest[near[EcoEvo`TemporalVariance[scalar,{EcoEvo`t,1,3}],2/9], True, TestID->"WindowVariance"]
VerificationTest[near[EcoEvo`TemporalCovariance[scalar,scalar,{EcoEvo`t,1,3}],2/9], True, TestID->"WindowCovariance"]
VerificationTest[near[EcoEvo`TemporalMean[scalar[EcoEvo`t]],8/5], True, TestID->"ExpressionMean"]
VerificationTest[near[EcoEvo`TemporalVariance[scalar[EcoEvo`t]],6/25], True, TestID->"ExpressionVariance"]
VerificationTest[near[EcoEvo`TemporalCovariance[scalar[EcoEvo`t],scalar[EcoEvo`t]],6/25], True, TestID->"ExpressionCovariance"]
VerificationTest[near[EcoEvo`TemporalMean[vector],{5/3,10/3}], True, TestID->"VectorMean"]
VerificationTest[near[EcoEvo`TemporalVariance[vector],{2/9,8/9}], True, TestID->"VectorVariance"]
VerificationTest[EcoEvo`FindMaxima[scalar], {{0,2},{2,2},{4,2}}, TestID->"Maxima"]
VerificationTest[EcoEvo`FindMinima[scalar], {{1,1},{3,1}}, TestID->"Minima"]
VerificationTest[EcoEvo`FindMinima[Normal[scalar]], {{1,1},{3,1}}, TestID->"ListExtrema"]
VerificationTest[EcoEvo`MaximumValues[scalar], {2}, TestID->"MaximumValues"]
VerificationTest[EcoEvo`MinimumValues[scalar], {1}, TestID->"MinimumValues"]
VerificationTest[EcoEvo`FindPeriod[rules], 2, TestID->"PeriodDetection"]
VerificationTest[EcoEvo`DropTimes[rules], {testN->{1,2}}, TestID->"DropTimes"]
VerificationTest[near[EcoEvo`TemporalMean[generic],5/3], True, TestID->"GenericTemporalDataMean"]
VerificationTest[near[EcoEvo`TemporalVariance[generic],2/9], True, TestID->"GenericTemporalDataVariance"]
VerificationTest[near[EcoEvo`TemporalCovariance[generic,generic],2/9], True, TestID->"GenericTemporalDataCovariance"]
VerificationTest[EcoEvo`TemporalRuleListQ[{testN->legacy}], True, TestID->"LegacyStorageRecognition"]
VerificationTest[near[EcoEvo`TemporalMean[legacy],5/3], True, TestID->"LegacyStorageMean"]
VerificationTest[EcoEvo`Slice[{testN->legacy},1], {testN->1}, TestID->"LegacyStorageSlice"]
VerificationTest[near[EcoEvo`TemporalMean[line],3], True, TestID->"ContinuousMean"]
VerificationTest[near[EcoEvo`TemporalVariance[line],4/3], True, TestID->"ContinuousVariance"]

family = EcoEvo`ParametricDynamics[
  Association@Table[ToString[k]->{testN->TimeSeries[{{0,2(k+1)},{1,k+1},{2,2(k+1)}}]}, {k,0,3}],
  EcoEvo`Parameter->testP, EcoEvo`Type->"Discrete", EcoEvo`ModelType->"DiscreteTime"];
VerificationTest[near[testN/.EcoEvo`TemporalMean[family],Table[{k,5(k+1)/3},{k,0,3}]], True, TestID->"FamilyMeans"]
VerificationTest[near[(EcoEvo`Period/.EcoEvo`FinalTime[family])[1],2], True, TestID->"FamilyEndpoints"]

EcoEvo`SetModel[{EcoEvo`ModelType->"DiscreteTime",
  EcoEvo`Pop[testPop]->{EcoEvo`Equation:>testPop Exp[testR(1-testPop)]},
  EcoEvo`Parameters:>{testR}}];
testR = 2.2;
simulation = EcoEvo`EcoSim[{testPop->0.2},20];
expected = NestList[# Exp[2.2(1-#)]&,0.2,20];
cycle = {testPop->TimeSeries[{{0,0.49705972677783344},{1,1.5029404896155933}}]};
multiplier = Times@@((Exp[2.2(1-#)](1-2.2#))& /@ Normal[(testPop/.cycle)["Values"]]);
foundCycle = EcoEvo`FindEcoCycle[{testPop->0.2}, EcoEvo`Period->2, Method->"FindRoot", EcoEvo`WarmUp->40];
phase = Join[simulation,{testOther->TimeSeriesMap[2#&,testPop/.simulation]}];
phase3 = Join[phase,{testThird->TimeSeriesMap[#^2&,testPop/.simulation]}];
VerificationTest[near[Normal[(testPop/.simulation)["Values"]],expected], True, TestID->"RickerRecurrence"]
VerificationTest[EcoEvo`ValidQ[simulation], True, TestID->"RickerValidity"]
VerificationTest[MatchQ[EcoEvo`EcoJacobian[simulation],_TimeSeries|_TemporalData], True, TestID->"RickerJacobianShape"]
VerificationTest[near[First[EcoEvo`EcoEigenvalues[cycle]],multiplier], True, TestID->"RickerMultiplier"]
VerificationTest[(testPop/.foundCycle)["Times"], {0,1}, TestID->"CycleEndpointTrim"]
VerificationTest[plotted[EcoEvo`PlotDynamics[simulation]], True, TestID->"PlotDynamics"]
VerificationTest[plotted[EcoEvo`PlotTrajectory[phase,{testPop,testOther},PlotRange->All]], True, TestID->"PlotTrajectory2D"]
VerificationTest[plotted[EcoEvo`RuleListPlot[phase,{testPop,testOther},PlotRange->All]], True, TestID->"RuleListPlot2D"]
VerificationTest[plotted[EcoEvo`PlotTrajectory[phase3,{testPop,testOther,testThird},PlotRange->All]], True, TestID->"PlotTrajectory3D"]
VerificationTest[plotted[EcoEvo`RuleListPlot[phase3,{testPop,testOther,testThird},PlotRange->All]], True, TestID->"RuleListPlot3D"]

Clear[testR];
bifurcation = EcoEvo`FindEcoCycleBifurcation[{testPop->0.3},testR->2.5,EcoEvo`Period->2,Monitor->False];
VerificationTest[(testPop/.bifurcation)["Times"], {0,1}, TestID->"BifurcationEndpointTrim"]
VerificationTest[Block[{testR=testR/.bifurcation},near[First[EcoEvo`EcoEigenvalues[EcoEvo`ExtractVariables[bifurcation]]],-1,10^-6]], True, TestID->"BifurcationMultiplier"]

(* Discrete trait-based competition. Test invasion against the mean log growth
   and eco-evolution against an independently iterated two-component map. *)
EcoEvo`SetModel[{EcoEvo`ModelType->"DiscreteTime", EcoEvo`Guild[guildN]->{
  EcoEvo`Equation:>Subscript[guildN,\[FormalI]] Exp[
    2.2(1-Sum[Subscript[guildN,\[FormalJ]],{\[FormalJ],Subscript[EcoEvo`\[ScriptCapitalN],guildN]}])-Subscript[traitX,\[FormalI]]^2],
  EcoEvo`Traits->{-1<=traitX<=1}}}];
traits = {Subscript[traitX,1]->0.,Subscript[traitX,2]->0.2};
guildSimulation = EcoEvo`EcoSim[traits,{Subscript[guildN,1]->0.2,Subscript[guildN,2]->0.3},4];
invasion = EcoEvo`InvSPS[traits,guildSimulation,{Subscript[traitX,0]->0.1}];
expectedInvasion = Mean[2.2(1-Total[Normal[#["Values"]]& /@ (Last /@ guildSimulation)])-0.1^2];
ecoEvolution = EcoEvo`EcoEvoSim[{Subscript[traitX,1]->0.2},{Subscript[guildN,1]->0.3},{EcoEvo`G[guildN]->{{0.01}}},3];
expectedEcoEvolution = NestList[{#[[1]] Exp[2.2(1-#[[1]])-#[[2]]^2],0.98 #[[2]]}&,{0.3,0.2},3];
VerificationTest[plotted[EcoEvo`PlotGuild[traits,guildSimulation,EcoEvo`PlotType->"ArrayPlot"]], True, TestID->"PlotGuildArray"]
VerificationTest[near[First[invasion],expectedInvasion], True, TestID->"InvasionMeanLogGrowth"]
VerificationTest[EcoEvo`TemporalRuleListQ[ecoEvolution], True, TestID->"EcoEvolutionRecognition"]
VerificationTest[{EcoEvo`InitialTime[ecoEvolution],EcoEvo`FinalTime[ecoEvolution]}, {0,3}, TestID->"EcoEvolutionEndpoints"]
VerificationTest[near[Normal[(Subscript[guildN,1]/.ecoEvolution)["Values"]],expectedEcoEvolution[[All,1]]], True, TestID->"EcoEvolutionPopulationRecurrence"]
VerificationTest[near[Normal[(Subscript[traitX,1]/.ecoEvolution)["Values"]],expectedEcoEvolution[[All,2]]], True, TestID->"EcoEvolutionTraitRecurrence"]
VerificationTest[near[EcoEvo`TemporalMean[Subscript[traitX,1]/.ecoEvolution],Mean[expectedEcoEvolution[[All,2]]]], True, TestID->"EcoEvolutionTraitMean"]

(* Numeric guild names must retain their identity until abundance weights are
   substituted. Independent weighted sums distinguish the two components. *)
EcoEvo`SetModel[{EcoEvo`Guild[1]->{
  EcoEvo`Component[meanS]->{EcoEvo`Equation:>0},
  EcoEvo`Component[meanI]->{EcoEvo`Equation:>0},
  EcoEvo`Traits->{0<=meanB<=1}}}];
meanTraits = {Subscript[meanB,1]->0.1,Subscript[meanB,2]->0.9};
meanState = {Subscript[meanS,1]->1.,Subscript[meanS,2]->3.,
  Subscript[meanI,1]->9.,Subscript[meanI,2]->1.};
VerificationTest[near[meanB/.EcoEvo`TraitMean[meanTraits,meanState],23/70], True, TestID->"TraitMeanNumericGuildTotal"]
VerificationTest[near[meanB/.EcoEvo`TraitMean[meanTraits,meanState,EcoEvo`WeightFunction->meanS],7/10], True, TestID->"TraitMeanNumericGuildSusceptible"]
VerificationTest[near[meanB/.EcoEvo`TraitMean[meanTraits,meanState,EcoEvo`WeightFunction->meanI],9/50], True, TestID->"TraitMeanNumericGuildInfected"]
VerificationTest[near[meanB/.EcoEvo`TraitMean[meanTraits,meanState,EcoEvo`WeightFunction->"PresenceAbsence"],1/2], True, TestID->"TraitMeanNumericGuildPresence"]
meanTrajectories = MapThread[Rule,{First/@meanState,
  (Interpolation[Table[{tt,#/.meanTime->tt},{tt,0,1,1/4}],InterpolationOrder->1]& /@
    {1+meanTime,3-2meanTime,9-5meanTime,1+2meanTime})}];
meanFunctions = (meanB/.EcoEvo`TraitMean[meanTraits,meanTrajectories,EcoEvo`WeightFunction->#]& /@ {"Total",meanS,meanI});
VerificationTest[near[
  Table[Through[meanFunctions[tt]],{tt,{0,1/2,1}}],
  Table[{(23/5-2tt/5)/(14-4tt),(14/5-17tt/10)/(4-tt),(9/5+13tt/10)/(10-3tt)},{tt,{0,1/2,1}}]], True, TestID->"TraitMeanNumericGuildContinuous"]

(* Numerical equations constrain only the unknowns to be real. Automatic
   NSolve must retain both Ricker fixed points without a symbolic fallback. *)
EcoEvo`SetModel[{EcoEvo`ModelType->"DiscreteTime",
  EcoEvo`Pop[nsolveN]->{EcoEvo`Equation:>nsolveN Exp[1.5(1-nsolveN)]}}];
nsolveRicker = EcoEvo`NSolveEcoEq[];
VerificationTest[near[Sort[nsolveN/.nsolveRicker],{0,1}], True, TestID->"NSolveEcoEqNumericRickerRoots"]
VerificationTest[near[(nsolveN-nsolveN Exp[1.5(1-nsolveN)])/.nsolveRicker,{0,0}], True, TestID->"NSolveEcoEqRickerResiduals"]
VerificationTest[Length[EcoEvo`NSolveEcoEq[EcoEvo`NSolveOpts->{MaxRoots->1}]], 1, TestID->"NSolveEcoEqPreservesMaxRoots"]
VerificationTest[near[Sort[nsolveN/.EcoEvo`NSolveEcoEq[EcoEvo`NSolveOpts->{Method->"Symbolic"}]],{0,1}], True, TestID->"NSolveEcoEqPreservesExplicitSymbolicMethod"]
VerificationTest[Quiet[EcoEvo`NSolveEcoEq[EcoEvo`NSolveOpts->{Method->"EndomorphismMatrix"}],EcoEvo`EcoEq::nosol], $Failed, TestID->"NSolveEcoEqDoesNotReplaceExplicitFailedMethod"]
VerificationTest[EcoEvo`NSolveEcoEq[EcoEvo`Fixed->{nsolveN->0}], {{nsolveN->0}}, TestID->"NSolveEcoEqFixedExtinction"]

(* Exact coefficients make the precision check independent of machine input. *)
EcoEvo`SetModel[{EcoEvo`ModelType->"DiscreteTime",
  EcoEvo`Pop[nsolveN]->{EcoEvo`Equation:>nsolveN Exp[(3/2)(1-nsolveN)]}}];
nsolvePrecise = EcoEvo`NSolveEcoEq[EcoEvo`NSolveOpts->{WorkingPrecision->40}];
VerificationTest[near[Sort[nsolveN/.nsolvePrecise],{0,1},10^-35] && Precision[Max[nsolveN/.nsolvePrecise]]>=35, True, TestID->"NSolveEcoEqPreservesPrecision"]

(* Symbolic parameters stay unrestricted until numerical values are assigned. *)
Clear[nsolveRate,nsolveDisp];
EcoEvo`SetModel[{EcoEvo`ModelType->"DiscreteTime",
  EcoEvo`Pop[nsolveN]->{EcoEvo`Equation:>nsolveN Exp[nsolveRate(1-nsolveN)]},
  EcoEvo`Parameters:>{nsolveRate}}];
nsolveSymbolicRicker = Quiet[EcoEvo`NSolveEcoEq[],NSolve::ifun];
VerificationTest[near[Sort[nsolveN/.nsolveSymbolicRicker],{0,1}], True, TestID->"NSolveEcoEqSymbolicRickerRoots"]
nsolveRate = 1.5;
VerificationTest[near[Sort[nsolveN/.EcoEvo`NSolveEcoEq[]],{0,1}], True, TestID->"NSolveEcoEqAssignedParameterRoots"]
Clear[nsolveRate];

EcoEvo`SetModel[{
  EcoEvo`Pop[nsolveP1]->{EcoEvo`Equation:>(1-nsolveP1)nsolveP1+nsolveDisp(-nsolveP1+nsolveP2)},
  EcoEvo`Pop[nsolveP2]->{EcoEvo`Equation:>nsolveDisp(nsolveP1-nsolveP2)+2(1-nsolveP2)nsolveP2},
  EcoEvo`Parameters:>{nsolveDisp}}];
nsolveDispersalBranches = EcoEvo`NSolveEcoEq[];
VerificationTest[Length[nsolveDispersalBranches]==4 && FreeQ[nsolveDispersalBranches,_ConditionalExpression], True, TestID->"NSolveEcoEqSymbolicDispersalBranches"]
nsolveDisp = 0.1;
nsolveDispersalNumeric = EcoEvo`NSolveEcoEq[];
nsolveDispersalExpected = {{0,0},{1,1},
  {(1-2nsolveDisp+Sqrt[1-2nsolveDisp^2])/2,(1-nsolveDisp-Sqrt[1-2nsolveDisp^2])/2},
  {(1-2nsolveDisp-Sqrt[1-2nsolveDisp^2])/2,(1-nsolveDisp+Sqrt[1-2nsolveDisp^2])/2}};
VerificationTest[near[Sort[{nsolveP1,nsolveP2}/.nsolveDispersalNumeric],Sort[nsolveDispersalExpected]], True, TestID->"NSolveEcoEqNumericDispersalFourRealRoots"]
VerificationTest[near[Sort[{nsolveP1,nsolveP2}/.(nsolveDispersalBranches/.nsolveDisp->0.1)],Sort[nsolveDispersalExpected]], True, TestID->"NSolveEcoEqSymbolicDispersalSpecialization"]
nsolveDisp = 1.;
VerificationTest[near[Sort[{nsolveP1,nsolveP2}/.EcoEvo`NSolveEcoEq[]],{{0,0},{1,1}}], True, TestID->"NSolveEcoEqNumericDispersalExcludesNonrealRoots"]
Clear[nsolveDisp];

(* Trait substitutions must precede classification, including compound unknowns. *)
EcoEvo`SetModel[{EcoEvo`ModelType->"DiscreteTime",EcoEvo`Guild[nsolveGuild]->{
  EcoEvo`Equation:>Subscript[nsolveGuild,\[FormalI]] Exp[
    (1.5+Subscript[nsolveTrait,\[FormalI]])(1-Subscript[nsolveGuild,\[FormalI]])],
  EcoEvo`Traits->{-1<=nsolveTrait<=1}}}];
VerificationTest[near[Sort[Subscript[nsolveGuild,1]/.EcoEvo`NSolveEcoEq[{Subscript[nsolveTrait,1]->0.1}]],{0,1}], True, TestID->"NSolveEcoEqNumericalTraitSubstitution"]

(* Variable-only real constraints allow complex intermediate expressions. *)
EcoEvo`SetModel[{EcoEvo`Pop[nsolveN]->{EcoEvo`Equation:>I(nsolveN-1)}}];
VerificationTest[near[nsolveN/.EcoEvo`NSolveEcoEq[],{1}], True, TestID->"NSolveEcoEqComplexIntermediateRealRoot"]

(* Fully numerical models now deliberately exclude non-real equilibria. *)
EcoEvo`SetModel[{EcoEvo`Pop[nsolveN]->{EcoEvo`Equation:>nsolveN^2+1}}];
VerificationTest[EcoEvo`NSolveEcoEq[], {}, TestID->"NSolveEcoEqAcceptsEmptyRealResult"]
EcoEvo`SetModel[{EcoEvo`Pop[nsolveN]->{EcoEvo`Equation:>nsolveN^2-1}}];
VerificationTest[near[Sort[nsolveN/.EcoEvo`NSolveEcoEq[EcoEvo`NSolveOpts->{Method->"EndomorphismMatrix"}]],{-1,1}], True, TestID->"NSolveEcoEqPreservesExplicitPolynomialMethod"]
VerificationTest[EcoEvo`NSolveOpts/.Options[EcoEvo`EcoEq], {}, TestID->"NSolveEcoEqEmptyDefaultOptions"]

EcoEvo`SetModel[{EcoEvo`Pop[nsolveN]->{EcoEvo`Equation:>nsolveN^2-2}}];
nsolvePolynomialPrecise = EcoEvo`NSolveEcoEq[EcoEvo`NSolveOpts->{WorkingPrecision->40}];
VerificationTest[near[Sort[nsolveN/.nsolvePolynomialPrecise],{-Sqrt[2],Sqrt[2]},10^-35] &&
  Min[Precision/@(nsolveN/.nsolvePolynomialPrecise)]>=35, True, TestID->"NSolveEcoEqPolynomialPreservesPrecision"]

(* Classification cannot hide parameters by sampling n=1 or p[1]=p[2]. *)
VerificationTest[EcoEvo`Private`numericalEquationsQ[{nsolveN==Exp[1.5(1-nsolveN)]nsolveN},{nsolveN}], True, TestID->"NumericalEquationsNumericRicker"]
VerificationTest[EcoEvo`Private`numericalEquationsQ[{nsolveN==Exp[nsolveRate(1-nsolveN)]nsolveN},{nsolveN}], False, TestID->"NumericalEquationsPreservesSymbolicRate"]
VerificationTest[EcoEvo`Private`numericalEquationsQ[{0==nsolveDisp(nsolveP[1]-nsolveP[2])+nsolveP[1]},{nsolveP[1],nsolveP[2]}], False, TestID->"NumericalEquationsPreservesSymbolicDispersal"]
VerificationTest[EcoEvo`Private`numericalEquationsQ[{0==0.1(nsolveP[1]-nsolveP[2])+nsolveP[1]},{nsolveP[1],nsolveP[2]}], True, TestID->"NumericalEquationsCompoundUnknowns"]
VerificationTest[EcoEvo`Private`numericalEquationsQ[{nsolveN==Exp[Subscript[nsolveA,1](1-nsolveN)]nsolveN},{nsolveN}], False, TestID->"NumericalEquationsSymbolicTrait"]
VerificationTest[EcoEvo`Private`numericalEquationsQ[{nsolveN==nsolveF[nsolveN]},{nsolveN}], False, TestID->"NumericalEquationsUnknownFunction"]
VerificationTest[EcoEvo`Private`numericalEquationsQ[{nsolveN==Piecewise[{{nsolveN^2,nsolveN>0}},1]},{nsolveN}], False, TestID->"NumericalEquationsConservativePiecewise"]
VerificationTest[EcoEvo`Private`numericalEquationsQ[{True,False},{}], True, TestID->"NumericalEquationsBooleanConstants"]

(* Polynomial classification is independent of numerical classification. *)
VerificationTest[EcoEvo`Private`polynomialEquationsQ[{0==nsolveN^2-1},{nsolveN}], True, TestID->"PolynomialEquationsNumeric"]
VerificationTest[EcoEvo`Private`polynomialEquationsQ[{0==Sin[nsolveRate]nsolveN^2+nsolveDisp nsolveN},{nsolveN}], True, TestID->"PolynomialEquationsSymbolicCoefficients"]
VerificationTest[EcoEvo`Private`polynomialEquationsQ[{0==nsolveDisp(nsolveP[1]-nsolveP[2])+nsolveP[1]^2},{nsolveP[1],nsolveP[2]}], True, TestID->"PolynomialEquationsCompoundUnknowns"]
VerificationTest[EcoEvo`Private`polynomialEquationsQ[{nsolveN==Exp[1.5(1-nsolveN)]nsolveN},{nsolveN}], False, TestID->"PolynomialEquationsRejectsRicker"]
VerificationTest[EcoEvo`Private`polynomialEquationsQ[{0==nsolveN/(1+nsolveN)},{nsolveN}], False, TestID->"PolynomialEquationsRejectsStateDenominator"]
VerificationTest[EcoEvo`Private`polynomialEquationsQ[{0==nsolveN^nsolveRate-1},{nsolveN}], False, TestID->"PolynomialEquationsRejectsUnresolvedExponent"]
VerificationTest[EcoEvo`Private`polynomialEquationsQ[{nsolveN==Piecewise[{{nsolveN^2,nsolveN>0}},1]},{nsolveN}], False, TestID->"PolynomialEquationsConservativePiecewise"]
VerificationTest[EcoEvo`Private`polynomialEquationsQ[{True,False},{}], True, TestID->"PolynomialEquationsBooleanConstants"]
VerificationTest[EcoEvo`Private`polynomialEquationsQ[{},{}], True, TestID->"PolynomialEquationsEmptyList"]

(* Rational responses retain their denominators and use Automatic by default. *)
EcoEvo`SetModel[{
  EcoEvo`Pop[rationalPrey]->{EcoEvo`Equation:>rationalPrey(1-rationalPrey)-rationalPrey rationalPredator/(1+rationalPrey)},
  EcoEvo`Pop[rationalPredator]->{EcoEvo`Equation:>rationalPrey rationalPredator/(1+rationalPrey)-rationalPredator/4}}];
nsolveRational = EcoEvo`NSolveEcoEq[];
VerificationTest[near[Sort[{rationalPrey,rationalPredator}/.nsolveRational],Sort[{{0,0},{1,0},{1/3,8/9}}]], True, TestID->"NSolveEcoEqRationalPredatorPreyRoots"]
EcoEvo`SetModel[{EcoEvo`Pop[nsolveN]->{EcoEvo`Equation:>(nsolveN^2-1)/(nsolveN-1)^2}}];
VerificationTest[near[nsolveN/.EcoEvo`NSolveEcoEq[],{-1}], True, TestID->"NSolveEcoEqRationalPoleExcluded"]

(* Three-species SI regression from si.nb. Automatic/Homotopy returns repeated
   roots in 15.0.1; the polynomial default must return each real root once. *)
siDs := (siBirth[Subscript[siB,\[FormalI]]] (Subscript[siS,\[FormalI]]+siF Subscript[siI,\[FormalI]])
  (1-siCC Sum[Subscript[siS,j]+Subscript[siI,j],{j,Subscript[EcoEvo`\[ScriptCapitalN],1]}])-
  siM Subscript[siS,\[FormalI]]-siNN Subscript[siS,\[FormalI]]-
  Sum[Subscript[siB,\[FormalI]] Subscript[siS,\[FormalI]] Subscript[siI,j],{j,Subscript[EcoEvo`\[ScriptCapitalN],1]}]);
siDi := (Sum[Subscript[siB,\[FormalI]] Subscript[siS,\[FormalI]] Subscript[siI,j],{j,Subscript[EcoEvo`\[ScriptCapitalN],1]}]-
  siNN Subscript[siI,\[FormalI]]-siV Subscript[siI,\[FormalI]]-siTheta siM Subscript[siI,\[FormalI]]);
siBirth[siBeta_] := siBmin+(siBmax-siBmin)((siBeta-siBMin)/(siBMax-siBMin))^siAlpha;
EcoEvo`SetModel[{EcoEvo`Guild[1]->{
  EcoEvo`Component[siS]->{EcoEvo`Equation:>siDs},
  EcoEvo`Component[siI]->{EcoEvo`Equation:>siDi},
  EcoEvo`Traits->{0<siB<1}},
  EcoEvo`Parameters:>{siBmin,siBmax,siBMin,siBMax,siAlpha,siF,siCC,siM,siNN,siV,siTheta}}];
EcoEvo`RuleListSet[{siBmin->0.3,siBmax->0.35,siBMin->0,siBMax->0.05,siAlpha->1,
  siF->0.75,siCC->0.05,siM->0.02,siNN->0.05,siV->0.05,siTheta->9}];
siTraits = {Subscript[siB,1]->0,Subscript[siB,2]->0.5,Subscript[siB,3]->0.4};
siUnknowns = Flatten[Table[{Subscript[siS,j],Subscript[siI,j]},{j,3}]];
siEquations = EcoEvo`EcoEqns[siTraits]/.EcoEvo`Eq/.siTraits;
siSolutions = EcoEvo`NSolveEcoEq[siTraits];
siBaseline = NSolve[siEquations,siUnknowns,Method->"EndomorphismMatrix"];
siBaselineReal = Select[siBaseline,Max[Abs[Im[siUnknowns/.#]]]<10^-8&];
siSameRoots[siA_,siB_] := Length[siA]==Length[siB] &&
  near[Sort[Chop[siUnknowns/.siA,10^-8]],Sort[Chop[siUnknowns/.siB,10^-8]],10^-8];
VerificationTest[Length[siSolutions], 10, TestID->"NSolveEcoEqSIThreeSpeciesCount"]
VerificationTest[Min[Norm[Subtract@@#,Infinity]&/@Subsets[siUnknowns/.siSolutions,{2}]]>10^-6, True, TestID->"NSolveEcoEqSIThreeSpeciesDistinct"]
VerificationTest[siSameRoots[siSolutions,siBaselineReal], True, TestID->"NSolveEcoEqSIThreeSpeciesMatchesBaselineRealRoots"]
VerificationTest[near[(Subtract@@@siEquations)/.siSolutions,ConstantArray[0,{10,6}],10^-8], True, TestID->"NSolveEcoEqSIThreeSpeciesResiduals"]
siAutomaticReference = NSolve[Append[siEquations,Element[siUnknowns,Reals]],siUnknowns,Method->Automatic];
VerificationTest[siSameRoots[EcoEvo`NSolveEcoEq[siTraits,EcoEvo`NSolveOpts->{Method->Automatic}],siAutomaticReference], True, TestID->"NSolveEcoEqPreservesExplicitAutomaticMethod"]
VerificationTest[siSameRoots[EcoEvo`NSolveEcoEq[siTraits,EcoEvo`NSolveOpts->{Method:>Automatic}],siAutomaticReference], True, TestID->"NSolveEcoEqPreservesDelayedAutomaticMethod"]

(* External and aggregate variables have no model-assigned LineStyle. Plotting
   must still produce graphics without warnings, while honoring explicit styles. *)
VerificationTest[plotted[EcoEvo`PlotDynamics[{plotExternal->scalar}]], True, TestID->"PlotDynamicsExternalTimeSeries"]
VerificationTest[plotted[EcoEvo`PlotDynamics[{plotExternal->line}]], True, TestID->"PlotDynamicsExternalInterpolation"]
VerificationTest[plotted[EcoEvo`PlotDynamics[{plotExternal->{{0,1},{1,2},{2,1}}}]], True, TestID->"PlotDynamicsExternalList"]
VerificationTest[Head[EcoEvo`PlotInterpolatingFunction[{plotExternal->scalar}]]===Graphics, True, TestID->"PlotInterpolatingFunctionExternalVariable"]
VerificationTest[Head[EcoEvo`PlotRuleList[{plotExternal->scalar}]]===Graphics, True, TestID->"PlotRuleListExternalVariable"]
VerificationTest[With[{g=EcoEvo`PlotDynamics[{plotExternal->scalar},EcoEvo`LineStyles->{Dashed}]},
  plotted[g] && !FreeQ[g,Dashing[{Small,Small}]] && !FreeQ[g,ColorData[97][1]]], True, TestID->"PlotDynamicsExternalExplicitLineStyles"]
VerificationTest[With[{g=EcoEvo`PlotDynamics[{plotExternal->scalar},PlotStyle->Directive[Purple,Dashed]]},
  plotted[g] && !FreeQ[g,Purple] && !FreeQ[g,Dashing[{Small,Small}]]], True, TestID->"PlotDynamicsExternalExplicitPlotStyle"]
EcoEvo`SetModel[{EcoEvo`Pop[plotRegistered]->{EcoEvo`Equation:>plotRegistered(1-plotRegistered),
  EcoEvo`Color->Purple,EcoEvo`LineStyle->Dashed}}];
VerificationTest[With[{g=EcoEvo`PlotDynamics[{plotRegistered->scalar}]},
  plotted[g] && !FreeQ[g,Purple] && !FreeQ[g,Dashing[{Small,Small}]]], True, TestID->"PlotDynamicsPreservesDeclaredModelStyles"]
EcoEvo`SetModel[{EcoEvo`ModelType->"DiscreteTime",
  EcoEvo`Pop[plotStages]:>EcoEvo`MatrixToPopComponents[{{0,2},{1/2,1/2}},plotStages]}];
plotStageSolution=EcoEvo`EcoSim[{plotStages[1]->1,plotStages[2]->0},4];
plotStageAggregate=EcoEvo`WeightedAbundance[plotStageSolution];
VerificationTest[plotted[EcoEvo`PlotDynamics[plotStageAggregate]], True, TestID->"PlotDynamicsStructuredPopulationAggregate"]
VerificationTest[With[{g=EcoEvo`PlotDynamics[plotStageSolution]},plotted[g] && Length[Cases[g,_Line,Infinity]]==2], True, TestID->"PlotDynamicsStructuredPopulationComponents"]
EcoEvo`UnsetModel;
VerificationTest[plotted[EcoEvo`PlotDynamics[{plotExternal->scalar}]], True, TestID->"PlotDynamicsWithoutSetModel"]

(* Numeric guild names differ from their component/trait names. Default
   abundance plots must have valid colors with and without a plotted trait. *)
EcoEvo`SetModel[{EcoEvo`Guild[1]->{
  EcoEvo`Component[plotGuildBiomass]->{EcoEvo`Equation:>0},
  EcoEvo`Component[plotGuildQuota]->{EcoEvo`Equation:>0,EcoEvo`Type->"Intensive"},
  EcoEvo`Traits->{0<=plotGuildTrait<=1}}}];
plotGuildTraits={Subscript[plotGuildTrait,1]->0.2,Subscript[plotGuildTrait,2]->0.8};
plotGuildState={Subscript[plotGuildBiomass,1]->1.,Subscript[plotGuildBiomass,2]->2.,
  Subscript[plotGuildQuota,1]->3.,Subscript[plotGuildQuota,2]->4.};
VerificationTest[plotted[EcoEvo`PlotGuild[plotGuildTraits,plotGuildState]], True,
  TestID->"PlotGuildNumericGuildTraitColors"]
VerificationTest[plotted[EcoEvo`PlotGuild[plotGuildTraits,plotGuildState,EcoEvo`Trait->None]], True,
  TestID->"PlotGuildNumericGuildNoTraitColors"]
VerificationTest[plotted[EcoEvo`PlotGuild[plotGuildTraits,plotGuildState,EcoEvo`Species->1]], True,
  TestID->"PlotGuildHighlightedSpeciesColors"]
VerificationTest[plotted[EcoEvo`PlotGuild[plotGuildTraits,plotGuildState,EcoEvo`Trait->None,EcoEvo`Species->1]], True,
  TestID->"PlotGuildHighlightedSpeciesNoTraitColors"]
VerificationTest[With[{g=EcoEvo`PlotGuild[plotGuildTraits,plotGuildState,PlotStyle->Blue]},
  plotted[g] && !FreeQ[g,Blue]], True, TestID->"PlotGuildExplicitStyle"]
EcoEvo`SetModel[{EcoEvo`Guild[plotGuildName]->{
  EcoEvo`Component[plotGuildBiomass]->{EcoEvo`Equation:>0},
  EcoEvo`Component[plotGuildQuota]->{EcoEvo`Equation:>0,EcoEvo`Type->"Intensive"}}}];
VerificationTest[plotted[EcoEvo`PlotGuild[plotGuildState]], True,
  TestID->"PlotGuildAutomaticallyTraitFree"]

EcoEvo`UnsetModel[];
End[];

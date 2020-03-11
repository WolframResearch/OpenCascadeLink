(* Wolfram Language package *)

(* Package stolen from https://stash.wolfram.com/users/robertc/repos/utilities/browse/checkGraphicsRendering/checkGraphicsRendering.m *)

(* ::Package:: *)

BeginPackage["checkGraphicsRendering`"];

checkGraphicsRendering;
$defaultNotebookOptions;
$defaultTest;

Begin["`Private`"];
ClearAll[checkGraphicsRendering, linkedNotebookEvaluate];
SetAttributes[checkGraphicsRendering, HoldAll];

$defaultNotebookOptions = If[ValueQ@$defaultNotebookOptions,
  $defaultNotebookOptions, 
  {Visible -> False}
];

$defaultTest = If[ValueQ@$defaultTest, $defaultTest, Identity];

Options[checkGraphicsRendering] := {
	"NotebookEvaluate" -> False, 
	"NotebookOptions" :> $defaultNotebookOptions,
	"HoldInput" -> False
};

linkedNotebookEvaluate[expr_] := 
 If[$Linked && Cases[$FrontEnd, _LinkObject, -1] =!= {$ParentLink}
   , 
   Block[{$ParentLink}, NotebookEvaluate[expr, InsertResults->True]]
   , 
   NotebookEvaluate[expr, InsertResults->True]
];

checkGraphicsRendering[test_, expr_, OptionsPattern[]]:=
UsingFrontEnd@Module[{nb, res, pinks, evalFlag, out},
	evalFlag= TrueQ@OptionValue["NotebookEvaluate"];
   
	nb = CreateDocument[
		If[evalFlag
			,
			ExpressionCell[Defer[expr], "Input"]
			,
			ExpressionCell[res = expr, "Output"]
		]
		, 
		##
	]& @@ Flatten[{OptionValue["NotebookOptions"]}]; 
	res = If[evalFlag, linkedNotebookEvaluate[nb], res];
	SelectionMove[nb, All, Cell];
	pinks = MathLink`CallFrontEnd[FrontEnd`GetErrorsInSelectionPacket[nb]];
	NotebookClose[nb];
	out = {test@res, "Rendering Errors" -> pinks};
	If[TrueQ@OptionValue["HoldInput"],
		Hold[expr] -> out,
		out
	]
]

checkGraphicsRendering[expr:Except[_Rule|_RuleDelayed], opts:OptionsPattern[]] := 
  checkGraphicsRendering[$defaultTest, expr, opts]


checkGraphicsRendering::usage = "checkGraphicsRendering[test_, expr_] returns {test@res, \"Rendering Errors\" -> {errors}} where res is the result of \
evaluating expr and errors are any FE errors generated.
checkGraphicsRendering[expr_] returns {Identity@res, \"Rendering Errors\" -> {errors}}.
Setting the option \"NotebookEvaluate\" to True, runs the notebook inside NotebookEvaluate to generate the result.
\"NotebookOptions\" accepts a list of notebook options which are passed to the created notebook.
Setting \"HoldInput\" to True causes the output returned to be of the form Hold[expr] -> {test@res, \"Rendering Errors\" -> {errors}}.";


End[(* `Private` *)];
EndPackage[]
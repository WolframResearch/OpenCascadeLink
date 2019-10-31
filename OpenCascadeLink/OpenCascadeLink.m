
BeginPackage["OpenCascadeLink`"]

$OpenCascadeLibrary::usage = "$OpenCascadeLibrary is the full path to the OpenCascade Library loaded by OpenCascadeLink."

$OpenCascadeInstallationDirectory::usage = "$OpenCascadeInstallationDirectory gives the top-level directory in which your OpenCascade installation resides."

$OpenCascadeVersion::usage = "$OpenCascadeVersion gives the version number of the OpenCascade library."

OpenCascadeShapeExpression::usage = "OpenCascadeShapeExpression[ id] represents an instance of a OpenCascadeShape object."

OpenCascadeShapeExpressionQ::usage = "OpenCascadeShapeExpressionQ[ expr] returns True if expr represents an active instance of a OpenCascadeShape object."

LoadOpenCascade::usage = "LoadOpenCascade[] loads the OpenCascade Library."

OpenCascadeShapeCreate::usage = "OpenCascadeShapeCreate[] creates an instance of a OpenCascadeShape expression."

OpenCascadeShapeDelete::usage = "OpenCascadeShapeDelete[ expr] removes an instance of a OpenCascadeShape expression, freeing up memory."

OpenCascadeShapeExpressions::usage = "OpenCascadeShapeExpressions[] returns a list of active OpenCascadeShape expressions."

OpenCascadeShape::usage = "";

OpenCascadeShapeDifference::usage = "";
OpenCascadeShapeIntersection::usage = "";
OpenCascadeShapeUnion::usage = "";
OpenCascadeShapeBooleanRegion::usage = "";

OpenCascadeShapeFillet::usage = "";

OpenCascadeShapeSurfaceMesh::usage = "";
OpenCascadeShapeSurfaceMeshCoordinates::usage = "";
OpenCascadeShapeSurfaceMeshElements::usage = "";
OpenCascadeShapeSurfaceMeshElementOffsets::usage = "";

OpenCascadeShapeNumberOfEdges::usage = "";

OpenCascadeShapeSurfaceMeshToBoundaryMesh::usage = "";

OpenCascadeShapeExport::usage = "OpenCascadeShapeExport[ \"file.ext\", expr] exports data from a OpenCascadeShape expression into a file. OpenCascadeShapeExport[ \"file\", expr, \"format\"] exports data in the specified format."

OpenCascadeShapeImport::usage = "OpenCascadeShapeImport[ \"file.ext\", expr] imports data from a file into a OpenCascadeShape expression. OpenCascadeShapeImport[ \"file\", expr, \"format\"] imports data in the specified format."


Options[OpenCascadeShapeExport] = {"ShapeSurfaceMeshOptions"->Automatic};
Options[OpenCascadeShapeSurfaceMesh] = Sort[ {
	"LinearDeflection"->Automatic,
	"AngularDeflection"->Automatic
}];

Options[OpenCascadeShapeSurfaceMeshToBoundaryMesh] = Sort[{
	"ShapeSurfaceMeshOptions"->Automatic,
	"ElementMeshOptions"->Automatic
}];

Begin["`Private`"]


pack = Developer`ToPackedArray;

$OpenCascadeVersion = "7.4.0"

$OpenCascadeLibrary = FindLibrary[ "openCascadeWolframDLL"]
$OpenCascadeLibrary = "/home/ruebenko/wri_git/OpenCascadeLink/build/Linux-x86-64/openCascadeWolframDLL.so" 

$OpenCascadeInstallationDirectory = DirectoryName[ $InputFileName]

pack = Developer`ToPackedArray;

needInitialization = True;



(*
 Load all the functions from the OpenCascade library.
*)
LoadOpenCascade[] :=
Module[{},
	deleteFun	= LibraryFunctionLoad[$OpenCascadeLibrary, "delete_ocShapeInstance", {Integer}, Integer];

	ocShapeInstanceListFun	= LibraryFunctionLoad[$OpenCascadeLibrary, "ocShapeInstanceList", {}, {Integer,1}];
	makeBallFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeBall", {Integer, {Real, 1, "Shared"}, Real}, Integer];
	makeConeFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeCone", {Integer, {Real, 1, "Shared"}, {Real, 1, "Shared"}, Real, Real}, Integer];
	makeCuboidFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeCuboid", {Integer, {Real, 1, "Shared"}, {Real, 1, "Shared"}}, Integer];
	makeCylinderFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeCylinder", {Integer, {Real, 1, "Shared"}, {Real, 1, "Shared"}, Real, Real}, Integer];
	makePrismFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makePrism", {Integer, {Real, 2, "Shared"}, {Real, 2, "Shared"}}, Integer];

	makeDifferenceFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeDifference", {Integer, Integer, Integer}, Integer];
	makeIntersectionFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeIntersection", {Integer, Integer, Integer}, Integer];
	makeUnionFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeUnion", {Integer, Integer, Integer}, Integer];

	makeFilletFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeFillet", {Integer, Integer, Real, {Integer, 1, "Shared"}}, Integer];

	makeSurfaceMeshFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeSurfaceMesh", {Integer, {Real, 1, "Shared"}, {Integer, 1, "Shared"}}, Integer];
	getSurfaceMeshCoordinatesFun = LibraryFunctionLoad[$OpenCascadeLibrary, "getSurfaceMeshCoordinates", {Integer}, {Real, 2}];
	getSurfaceMeshElementsFun = LibraryFunctionLoad[$OpenCascadeLibrary, "getSurfaceMeshElements", {Integer}, {Integer, 2}];
	getSurfaceMeshElementOffsetsFun = LibraryFunctionLoad[$OpenCascadeLibrary, "getSurfaceMeshElementOffsets", {Integer}, {Integer, 1}];

	getShapeNumberOfEdgesFun = LibraryFunctionLoad[$OpenCascadeLibrary, "getShapeNumberOfEdges", {Integer}, Integer];

	fileOperationFun = LibraryFunctionLoad[$OpenCascadeLibrary, "fileOperation", LinkObject, LinkObject];

	needInitialization = False;
]


(*
 Functions for working with OpenCascadeShapeExpression
*)
getOpenCascadeShapeExpressionID[e_OpenCascadeShapeExpression] := ManagedLibraryExpressionID[e, "OpenCascadeShapeManager"];

OpenCascadeShapeExpressionQ[e_OpenCascadeShapeExpression] := ManagedLibraryExpressionQ[e, "OpenCascadeShapeManager"];

testOpenCascadeShapeExpression[][e_] := testOpenCascadeShapeExpression[OpenCascadeShapeExpression][OpenCascadeShapeExpression][e];

testOpenCascadeShapeExpression[mhead_Symbol][e_] := 
	If[
		TrueQ[OpenCascadeShapeExpressionQ[e]], 
		True
	,
		Message[MessageName[mhead,"ocinst"], e];
		False
	];
	
testOpenCascadeShapeExpression[_][e_] :=	TrueQ[OpenCascadeShapeExpressionQ[e]];
	
General::ocinst = "`1` does not represent an active OpenCascade object.";

OpenCascadeShapeCreate[] :=
	Module[{instance},
		If[ needInitialization, LoadOpenCascade[]];
		CreateManagedLibraryExpression["OpenCascadeShapeManager", OpenCascadeShapeExpression]
	]

OpenCascadeShapeDelete[OpenCascadeShapeExpression[ id_]?(testOpenCascadeShapeExpression[OpenCascadeShapeDelete])] :=
	Module[{},
		deleteFun[ id]
	]

OpenCascadeShapeDelete[ l:{_OpenCascadeShapeExpression..}] := OpenCascadeShapeDelete /@ l

OpenCascadeShapeExpressions[] :=
	Module[ {list},
		If[ needInitialization, LoadOpenCascade[]];
		list = ocShapeInstanceListFun[];
		If[ !ListQ[ list], 
			$Failed,
			Map[ OpenCascadeShapeExpression, list]]
	]



(*
 Functions for with the file formats that OpenCascade supports
*)

OpenCascadeShapeImport::file = "An error was found loading `1` file, `2`."

OpenCascadeShapeImport[ file:(_String|_File)] :=
	Module[{dir, fileName, ext},
		dir = FileNameDrop[ file, -1];
		fileName = FileBaseName[ file];
		ext = FileExtension[file];
		If[ dir =!= "", fileName = FileNameJoin[{dir, fileName}]];
		OpenCascadeShapeImport[ fileName, ext]
	]

OpenCascadeShapeImport[ file:(_String|_File), form_String] :=
	Module[{res, fileOperation, fileName, fileWithExtension,
		fns, newDir, validDirQ, instance},
		fileOperation = Switch[ form,
						"stp"|"step", "load_step",
						_, $Failed];
		If[ fileOperation === $Failed, Return[ $Failed, Module]];

		fileWithExtension = file;
		If[ FileExtension[file]=="",
			fileWithExtension = StringJoin[file, ".", form];
		];

		(* bug: 191880 *)
		fns = FileNameSplit[file];

		If[ Length[fns] == 0,
			Message[OpenCascadeShapeImport::file, form, fileWithExtension];
			Return[$Failed, Module];
		];

		If[ Length[fns] >= 1,
			fileName = FileBaseName[ Last[fns]];
		,
			Message[OpenCascadeShapeImport::file, form, fileWithExtension];
			Return[$Failed, Module];
		];

		If[ Length[fns] > 1,
			newDir = FileNameJoin[Most[fns]];
			validDirQ = DirectoryQ[newDir];
			If[ !validDirQ,
				Message[OpenCascadeShapeImport::file, form, fileWithExtension];
				Return[$Failed, Module];
			,
				SetDirectory[newDir];
			];
		];

		If[ !FileExistsQ[StringJoin[{fileName, ".", form}]],
			If[ validDirQ, ResetDirectory[]];
			Message[OpenCascadeShapeImport::file, form, fileWithExtension];
			Return[$Failed, Module];
		];

		instance = OpenCascadeShapeCreate[];

		res = fileOperationFun[ instanceID[ instance],
			StringJoin[{fileName, ".", form}], fileOperation];

		If[ validDirQ, ResetDirectory[]; ];

		If[ res =!= True,
			Message[ OpenCascadeShapeImport::file, form, fileWithExtension];
			$Failed
		,
			instance
		]
	]

OpenCascadeShapeExport::file = "An error was found saving `1` file, `2`."

OpenCascadeShapeExport[
	file:(_String|_File),
	OpenCascadeShapeExpression[ id_]?(testOpenCascadeShapeExpression[OpenCascadeShapeExport]),
	opts:OptionsPattern[OpenCascadeShapeExport]] :=
Module[
	{dir, fileName, ext},
	dir = FileNameDrop[ file, -1];
	fileName = FileBaseName[ file];
	ext = FileExtension[file];
	If[ dir =!= "", fileName = FileNameJoin[{dir, fileName}]];
	OpenCascadeShapeExport[
		fileName, 
		OpenCascadeShapeExpression[id],
		ext,
		opts
	]
]

OpenCascadeShapeExport[
	file:(_String|_File),
	OpenCascadeShapeExpression[ id_]?(testOpenCascadeShapeExpression[OpenCascadeShapeExport]),
	form_String,
	opts:OptionsPattern[OpenCascadeShapeExport]
] :=
Module[{res, fileOperation, fileName, fileWithExtension,
	fns, newDir, validDirQ, surfaceMeshOpts},
	fileOperation = Switch[ form,
					"STL" | "stl", "save_stl",
					"step" | "stp", "save_step",
					_, $Failed];
	If[ fileOperation === $Failed, Return[ $Failed, Module]];

	fileWithExtension = file;
	If[ FileExtension[file]=="",
		fileWithExtension = StringJoin[file, ".", form];
	];

	(* bug: 191880 *)
	fns = FileNameSplit[file];

	If[ Length[fns] == 0,
		Message[OpenCascadeShapeExport::file, form, fileWithExtension];
		Return[$Failed, Module];
	];

	If[ Length[fns] >= 1,
		fileName = FileBaseName[ Last[fns]];
		,
		Message[OpenCascadeShapeExport::file, form, fileWithExtension];
		Return[$Failed, Module];
	];

	If[ Length[fns] > 1,
		newDir = FileNameJoin[Most[fns]];
		validDirQ = DirectoryQ[newDir];
		If[ !validDirQ,
			Message[OpenCascadeShapeExport::file, form, fileWithExtension];
			Return[$Failed, Module];
		,
			SetDirectory[newDir];
		];
	];

	If[ fileOperation === "save_stl",
		surfaceMeshOpts = Flatten[{ OptionValue["ShapeSurfaceMeshOptions"]}];
		If[ surfaceMeshOpts === {Automatic}, surfaceMeshOpts = {}];
		surfaceMeshOpts = FilterRules[surfaceMeshOpts,
			Options[OpenCascadeShapeSurfaceMesh]];

		ok = OpenCascadeShapeSurfaceMesh[ OpenCascadeShapeExpression[ id],
			surfaceMeshOpts];
		If[ ok === $Failed,
			Message[OpenCascadeShapeExport::file, form, fileWithExtension];
			Return[$Failed, Module];
		];
	];

	res = fileOperationFun[ id, StringJoin[fileName, ".", form], fileOperation];

	If[ validDirQ,
		ResetDirectory[];
	];

	If[ res =!= True,
		Message[ OpenCascadeShapeExport::file, form, fileWithExtension];
		$Failed
		,
		Null
	];
]


instanceID[ OpenCascadeShapeExpression[ id_]] := id

(* map graphics primitives to open cascade *)

OpenCascadeShape[Ball[p_, r_]] /;
		VectorQ[p, NumericQ] && (Length[ p] == 3) :=
Module[{instance, res, origin, radius},

	origin = pack[ N[ p]];
	radius = N[ r];
	instance = OpenCascadeShapeCreate[];
	res = makeBallFun[ instanceID[ instance], origin, radius];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]

OpenCascadeShape[Ball[p_]] /; VectorQ[ p, NumericQ] && (Length[ p] === 3) := 
OpenCascadeShape[Ball[p, 1.]]

OpenCascadeShape[Ball[p_, r___]] /; 
	ArrayQ[ p, 2, NumericQ] && (Last[ Dimensions[ p]] === 3) := 
OpenCascadeShape[Ball[#, r]]& /@ p


OpenCascadeShape[Cone[{pMin_, pMax_}, r_]] /;
		VectorQ[pMin, NumericQ] && (Length[ pMin] == 3) && 
		VectorQ[pMax, NumericQ] && (Length[ pMax] == 3) :=
Module[{instance, res, origin, h},

	p1 = pack[ N[ pMin]];
	p2 = pack[ N[ pMax]];

	h = Norm[p1 - p2];

	instance = OpenCascadeShapeCreate[];
	res = makeConeFun[ instanceID[ instance], p1, p2, r, h];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]

OpenCascadeShape[Cone[{pMin_, pMax_}]] /;
		VectorQ[pMin, NumericQ] && (Length[ pMin] == 3) && 
		VectorQ[pMax, NumericQ] && (Length[ pMax] == 3) :=
OpenCascadeShape[Cone[{pMin, pMax}, 1.]]


OpenCascadeShape[Cuboid[pMin_, pMax_]] /;
		VectorQ[pMin, NumericQ] && (Length[ pMin] == 3) && 
		VectorQ[pMax, NumericQ] && (Length[ pMax] == 3) :=
Module[{instance, res, origin, radius},

	p1 = pack[ N[ pMin]];
	p2 = pack[ N[ pMax]];

	instance = OpenCascadeShapeCreate[];
	res = makeCuboidFun[ instanceID[ instance], p1, p2];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]

OpenCascadeShape[Cuboid[pMin_]] /;
		VectorQ[pMin, NumericQ] && (Length[ pMin] == 3) :=
OpenCascadeShape[Cuboid[pMin, pMin + 1]] 


OpenCascadeShape[Cylinder[{pMin_, pMax_}, r_]] /;
		VectorQ[pMin, NumericQ] && (Length[ pMin] == 3) && 
		VectorQ[pMax, NumericQ] && (Length[ pMax] == 3) :=
Module[{instance, res, origin, h},

	p1 = pack[ N[ pMin]];
	p2 = pack[ N[ pMax]] - p1;

	h = Norm[pMin - pMax];

	instance = OpenCascadeShapeCreate[];
	res = makeCylinderFun[ instanceID[ instance], p1, p2, r, h];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]

OpenCascadeShape[Cylinder[{pMin_, pMax_}]] /;
		VectorQ[pMin, NumericQ] && (Length[ pMin] == 3) && 
		VectorQ[pMax, NumericQ] && (Length[ pMax] == 3) :=
OpenCascadeShape[Cylinder[{pMin, pMax}, 1.]]


OpenCascadeShape[Prism[p_]] /;
		MatrixQ[p, NumericQ] && (Dimensions[ p] == {6, 3}) :=
Module[{instance, base, target, direcction, res},

	If[ Length[ DeleteDuplicates[p]] =!= 6, Return[$Failed, Module]];

	base = pack[ N[ p[[ 1;;3]]]];
	target = pack[ N[ p[[ 4;;6]]]];

	direction = pack[ { Mean[ base], Mean[ target]}];

	instance = OpenCascadeShapeCreate[];
	res = makePrismFun[ instanceID[ instance], base, direction];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]




(*
	open cascde boolean operation
*)

OpenCascadeShapeDifference[ shape1_] /; 
	OpenCascadeShapeExpressionQ[shape1] := shape1

OpenCascadeShapeDifference[ shape1_, shape2_] /; And[
	OpenCascadeShapeExpressionQ[shape1],
	OpenCascadeShapeExpressionQ[shape2]
] := Module[
	{instance, id1, id2, res, origin, radius},

	instance = OpenCascadeShapeCreate[];
	id1 = instanceID[ shape1];
	id2 = instanceID[ shape2];
	res = makeDifferenceFun[ instanceID[ instance], id1, id2];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]

OpenCascadeShapeDifference[eN__] := Fold[OpenCascadeShapeDifference, {eN}]


OpenCascadeShapeIntersection[ shape1_] /; 
	OpenCascadeShapeExpressionQ[shape1] := shape1

OpenCascadeShapeIntersection[ shape1_, shape2_] /; And[
	OpenCascadeShapeExpressionQ[shape1],
	OpenCascadeShapeExpressionQ[shape2]
] := Module[
	{instance, id1, id2, res, origin, radius},

	instance = OpenCascadeShapeCreate[];
	id1 = instanceID[ shape1];
	id2 = instanceID[ shape2];
	res = makeIntersectionFun[ instanceID[ instance], id1, id2];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]

OpenCascadeShapeIntersection[eN__] := Fold[OpenCascadeShapeIntersection, {eN}]


OpenCascadeShapeUnion[ shape1_] /; 
	OpenCascadeShapeExpressionQ[shape1] := shape1

OpenCascadeShapeUnion[shape1_, shape2_] /; And[ 
		OpenCascadeShapeExpressionQ[shape1],
		OpenCascadeShapeExpressionQ[shape2]
] := Module[
	{instance, id1, id2, res, origin, radius},

	instance = OpenCascadeShapeCreate[];
	id1 = instanceID[ shape1];
	id2 = instanceID[ shape2];
	res = makeUnionFun[ instanceID[ instance], id1, id2];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]

OpenCascadeShapeUnion[eN__] := Fold[OpenCascadeShapeUnion, {eN}]


OpenCascadeShapeBooleanRegion[ br_BooleanRegion] /; Length[br] == 2 :=
Module[
	{booleanFunction, regions},

	(* TODO: check for Xor and complain *)
	booleanFunction = br[[1]] /. {
		Or :> OpenCascadeShapeUnion,
		And[s1_, Not[s2_]] :> OpenCascadeShapeDifference[s1, s2],
		And[Not[s2_], s1_] :> OpenCascadeShapeDifference[s1, s2],
		And :> OpenCascadeShapeIntersection
	};

	regions = OpenCascadeShape /@ br[[2]];
	(* TODO: check that all regions valid *)

	booleanFunction @@ regions
]



OpenCascadeShapeFillet[shape_, radius_, edgeIDs_] /; 
		OpenCascadeShapeExpressionQ[shape] &&
		NumericQ[ radius] &&
		(edgeIDs === All || VectorQ[edgeIDs, NumericQ]) := Module[
	{instance, numEdges, id1, res, r, eIDs = edgeIDs},

	r = N[ radius];
	If[ r < $MachineEpsilon, Return[ shape, Module]; ];

	numEdges = getShapeNumberOfEdgesFun[ instanceID[ shape]];
	If[ eIDs === All, eIDs = Range[ numEdges]; ];

	eIDs = Sort[ pack[ eIDs]];
	If[ eIDs === {}, Return[ shape, Module]; ];

	If[ Max[ eIDs] > numEdges, Return[ shape, Module]; ];

	instance = OpenCascadeShapeCreate[];
	id1 = instanceID[ shape];
	(* - 1 since C uses 0 index start *)
	res = makeFilletFun[ instanceID[ instance], id1, r, eIDs - 1];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]

OpenCascadeShapeFillet[shape_, radius_] :=
	OpenCascadeShapeFillet[ shape, radius, All] 

OpenCascadeShapeNumberOfEdges[shape_] /; OpenCascadeShapeExpressionQ[shape] :=
getShapeNumberOfEdgesFun[ instanceID[ shape]]




(*
	surface meshing and meshed component extraction
*)

OpenCascadeShapeSurfaceMesh[
	OpenCascadeShapeExpression[ id_]?(testOpenCascadeShapeExpression[OpenCascadeShapeSurfaceMesh]),
	opts:OptionsPattern[OpenCascadeShapeSurfaceMesh]
] := 
Module[{res, realParams, boolParams, ldeflection, adeflection},

	(* TODO: this is an absolute value and should be scaled
		with the shape bounds. *)
	ldeflection = N[ OptionValue["LinearDeflection"]];
	If[ !NumericQ[ ldeflection] || ldeflection <= 0.,
		ldeflection = 0.01
	];

	adflection = N[ OptionValue["AngularDeflection"]];
	If[ !NumericQ[ adeflection] || adeflection <= 0.,
		adeflection = 0.5
	];	


	realParams = pack[{
		(* Angle *)				adeflection,
		(* Deflection *)		ldeflection,
		(* AngleInterior *)		0.,
		(* DeflectionInterior*)	0.,
		(* MinSize *)			0.
	}];

	boolParams = pack[Boole[{
		(* InParallel *)				False,
		(* Relative *)					False,
		(* InternalVerticesMode *)		True,
		(* ControlSurfaceDeflection *)	True,
		(* CleanModel *) 				False,
		(* AdjustMinSize *)				False
	}]];

	res = makeSurfaceMeshFun[ id, realParams, boolParams];
	If[ res =!= 0, Return[$Failed, Module]];

	Null
]

OpenCascadeShapeSurfaceMeshCoordinates[
	OpenCascadeShapeExpression[ id_]?(testOpenCascadeShapeExpression[OpenCascadeShapeSurfaceMeshCoordinates]),
	opts:OptionsPattern[OpenCascadeShapeSurfaceMeshCoordinates]
] :=
Module[{coords},
	coords = getSurfaceMeshCoordinatesFun[id];
	coords
]


OpenCascadeShapeSurfaceMeshElements[
	OpenCascadeShapeExpression[ id_]?(testOpenCascadeShapeExpression[OpenCascadeShapeSurfaceMeshElements]),
	opts:OptionsPattern[OpenCascadeShapeSurfaceMeshElements]
] :=
Module[{ele},
	ele = getSurfaceMeshElementsFun[id];
	ele	
]

OpenCascadeShapeSurfaceMeshElementOffsets[
	OpenCascadeShapeExpression[ id_]?(testOpenCascadeShapeExpression[OpenCascadeShapeSurfaceMeshElementOffsets]),
	opts:OptionsPattern[OpenCascadeShapeSurfaceMeshElementOffsets]
] :=
Module[{offsets},
	offsets = getSurfaceMeshElementOffsetsFun[id];
	offsets
]

OpenCascadeShapeSurfaceMeshToBoundaryMesh[
	instance:OpenCascadeShapeExpression[ id_]?(testOpenCascadeShapeExpression[OpenCascadeShapeSurfaceMeshToBoundaryMesh]),
	opts:OptionsPattern[OpenCascadeShapeSurfaceMeshToBoundaryMesh]
] := 
Module[
	{surfaceMeshOpts, ok, coords, bEle, offsets, stop, start, spans, markers,
	markerOffset},

	surfaceMeshOpts = Flatten[{ OptionValue["ShapeSurfaceMeshOptions"]}];
	If[ surfaceMeshOpts === {Automatic}, surfaceMeshOpts = {}];
	surfaceMeshOpts = FilterRules[surfaceMeshOpts,
		Options[OpenCascadeShapeSurfaceMesh]];

	ok = OpenCascadeShapeSurfaceMesh[ instance, surfaceMeshOpts];
	If[ ok === $Failed, Return[$Failed, Module]; ];

	coords = OpenCascadeShapeSurfaceMeshCoordinates[instance];
	bEle = OpenCascadeShapeSurfaceMeshElements[instance];
	offsets = OpenCascadeShapeSurfaceMeshElementOffsets[instance];

	elementMeshOpts = Flatten[{ OptionValue["ElementMeshOptions"]}];
	If[ elementMeshOpts === {Automatic}, elementMeshOpts = {}];
	elementMeshOpts = FilterRules[elementMeshOpts,
		Options[NDSolve`FEM`ToBoundaryMesh]];

	markerOffset = OptionValue[NDSolve`FEM`ToBoundaryMesh,
		elementMeshOpts, "MarkerOffset"];
	If[ !MatchQ[ markerOffset, {_Integer?Positive}],
		markerOffset = 0;
	];

	stop = FoldList[Plus, offsets];
	start = Most[Join[{1}, stop + 1]];
	spans = MapThread[Span, {start, stop}];
	markers = MapThread[ ConstantArray[#1, #2]&,
		{Range[Length[offsets]] + markerOffset, offsets}];
	bEle = MapThread[NDSolve`FEM`TriangleElement,
		{bEle[[#]] & /@ spans, markers}];

	elementMeshOpts = FilterRules[elementMeshOpts,
		Options[NDSolve`FEM`ElementMesh]];
	NDSolve`FEM`ElementMesh[coords, Automatic, bEle, elementMeshOpts]
]

End[]

EndPackage[]


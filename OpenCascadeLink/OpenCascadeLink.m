
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

OpenCascadeShapeSurfaceMesh::usage = "";
OpenCascadeShapeSurfaceMeshCoordinates::usage = "";
OpenCascadeShapeSurfaceMeshElements::usage = "";
OpenCascadeShapeSurfaceMeshElementOffsets::usage = "";

OpenCascadeShapeSurfaceMeshToBoundaryMesh::usage = "";

OpenCascadeShapeExport::usage = "OpenCascadeShapeExport[ \"file.ext\", expr] exports data from a OpenCascadeShape expression into a file. OpenCascadeShapeExport[ \"file\", expr, \"format\"] exports data in the specified format."

(*

OpenCascadeShapeImport::usage = "OpenCascadeShapeImport[ \"file.ext\", expr] imports data from a file into a OpenCascadeShape expression. OpenCascadeShapeImport[ \"file\", expr, \"format\"] imports data in the specified format."

*)

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

	makeDifferenceFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeDifference", {Integer, Integer, Integer}, Integer];
	makeIntersectionFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeIntersection", {Integer, Integer, Integer}, Integer];
	makeUnionFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeUnion", {Integer, Integer, Integer}, Integer];

	makeSurfaceMeshFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeSurfaceMesh", {Integer, {Real, 1, "Shared"}, {Integer, 1, "Shared"}}, Integer];
	getSurfaceMeshCoordinatesFun = LibraryFunctionLoad[$OpenCascadeLibrary, "getSurfaceMeshCoordinates", {Integer}, {Real, 2}];
	getSurfaceMeshElementsFun = LibraryFunctionLoad[$OpenCascadeLibrary, "getSurfaceMeshElements", {Integer}, {Integer, 2}];
	getSurfaceMeshElementOffsetsFun = LibraryFunctionLoad[$OpenCascadeLibrary, "getSurfaceMeshElementOffsets", {Integer}, {Integer, 1}];

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
		True,
		Message[MessageName[mhead,"ocinst"], e]; False
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
OpenCascadeShapeImport::file = "An error was found loading `1` file, `2`. Try Import as an alternative."

OpenCascadeShapeImport[ file:(_String|_File), OpenCascadeShapeExpression[ id_]?(testOpenCascadeShapeExpression[OpenCascadeShapeImport]), form_String] :=
	Module[{res, formName, fileName, fileWithExtension,
		fns, newDir, validDirQ},
		formName = Switch[ form,
						"node", "load_node",
						"poly", "load_poly",
						"pbc", "load_pbc",
						"var", "load_var",
						"mtr", "load_mtr",
						"off", "load_off",
						"ply", "load_ply",
						"stl", "load_stl",
						"mesh", "load_medit",
						"tetmesh", "load_tetmesh",
						"voronoi", "load_voronoi",
						_, $Failed];
		If[ formName === $Failed, Return[ $Failed]];

		fileWithExtension = file;
		If[ FileExtension[file]=="",
			fileWithExtension = StringJoin[file, ".", form];
		];

		(* bug: 191880 *)
		fns = FileNameSplit[file];

		If[ Length[fns] == 0,
			Message[OpenCascadeShapeImport::file, form, fileWithExtension];
			Return[$Failed];
		];

		If[ Length[fns] >= 1,
			fileName = FileBaseName[ Last[fns]];
		,
			Message[OpenCascadeShapeImport::file, form, fileWithExtension];
			Return[$Failed];
		];

		If[ Length[fns] > 1,
			newDir = FileNameJoin[Most[fns]];
			validDirQ = DirectoryQ[newDir];
			If[ !validDirQ,
				Message[OpenCascadeShapeImport::file, form, fileWithExtension];
				Return[$Failed];
			,
				SetDirectory[newDir];
			];
		];

		If[ !FileExistsQ[StringJoin[{fileName, ".", form}]],
			If[ validDirQ, ResetDirectory[]];
			Message[OpenCascadeShapeImport::file, form, fileWithExtension];
			Return[$Failed];
		];

		res = fileOperationFun[ id, fileName, formName];

		If[ validDirQ, ResetDirectory[]; ];

		If[ res =!= True,
			Message[ OpenCascadeShapeImport::file, form, fileWithExtension];
			$Failed;
		,
			Null
		];
	]

OpenCascadeShapeExport::file = "An error was found saving `1` file, `2`."

OpenCascadeShapeExport[
	file:(_String|_File),
	OpenCascadeShapeExpression[ id_]?(testOpenCascadeShapeExpression[OpenCascadeShapeExport]),
	form_String,
	opts:OptionsPattern[OpenCascadeShapeExport]
] :=
Module[{res, formName, fileName, fileWithExtension,
	fns, newDir, validDirQ, surfaceMeshOpts},
	formName = Switch[ form,
					"STL" | "stl", "STL",
					_, $Failed];
	If[ formName === $Failed, Return[ $Failed, Module]];

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

	If[ formName === "STL",
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

	res = fileOperationFun[ id, StringJoin[fileName, ".", form], formName];

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

OpenCascadeShapeImport[ file:(_String|_File), OpenCascadeShapeExpression[ id_]?(testOpenCascadeShapeExpression[OpenCascadeShapeImport])] :=
	Module[{dir, fileName, ext},
		dir = FileNameDrop[ file, -1];
		fileName = FileBaseName[ file];
		ext = FileExtension[file];
		If[ dir =!= "", fileName = FileNameJoin[{dir, fileName}]];
		OpenCascadeShapeImport[ fileName, OpenCascadeShapeExpression[id], ext]
	]

OpenCascadeShapeExport[
	file:(_String|_File),
	OpenCascadeShapeExpression[ id_]?(testOpenCascadeShapeExpression[OpenCascadeShapeExport]),
	opts:OptionsPattern[OpenCascadeShapeExport]] :=
	Module[{dir, fileName, ext},
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
	p2 = pack[ N[ pMax]];

	h = Norm[p1 - p2];

	instance = OpenCascadeShapeCreate[];
	res = makeCylinderFun[ instanceID[ instance], p1, p2, r, h];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]

OpenCascadeShape[Cylinder[{pMin_, pMax_}]] /;
		VectorQ[pMin, NumericQ] && (Length[ pMin] == 3) && 
		VectorQ[pMax, NumericQ] && (Length[ pMax] == 3) :=
OpenCascadeShape[Cylinder[{pMin, pMax}, 1.]]




(*
	open cascde boolean operation
*)

OpenCascadeShapeDifference[
	OpenCascadeShapeExpression[ id1_]?(testOpenCascadeShapeExpression[OpenCascadeUnion]),
	OpenCascadeShapeExpression[ id2_]?(testOpenCascadeShapeExpression[OpenCascadeUnion])] :=
Module[{instance, res, origin, radius},

	instance = OpenCascadeShapeCreate[];
	res = makeDifferenceFun[ instanceID[ instance], id1, id2];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]

OpenCascadeShapeIntersection[
	OpenCascadeShapeExpression[ id1_]?(testOpenCascadeShapeExpression[OpenCascadeUnion]),
	OpenCascadeShapeExpression[ id2_]?(testOpenCascadeShapeExpression[OpenCascadeUnion])] :=
Module[{instance, res, origin, radius},

	instance = OpenCascadeShapeCreate[];
	res = makeIntersectionFun[ instanceID[ instance], id1, id2];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]

OpenCascadeShapeUnion[
	OpenCascadeShapeExpression[ id1_]?(testOpenCascadeShapeExpression[OpenCascadeUnion]),
	OpenCascadeShapeExpression[ id2_]?(testOpenCascadeShapeExpression[OpenCascadeUnion])] :=
Module[{instance, res, origin, radius},

	instance = OpenCascadeShapeCreate[];
	res = makeUnionFun[ instanceID[ instance], id1, id2];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]


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


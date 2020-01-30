
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

OpenCascadeShape::usage = "OpenCascadeShape[ expr] returns an instance of an OpenCascade expression representing expr in OpenCascade.";

OpenCascadeShapeDifference::usage = "OpenCascadeShapeDifference[ shape1, shape2] returns a new instance of an OpenCascade expression representing the difference of the shapes shape1 and shape2.";
OpenCascadeShapeIntersection::usage = "OpenCascadeShapeIntersection[ shape1, shape2] returns a new instance of an OpenCascade expression representing the intersection of the shapes shape1 and shape2.";
OpenCascadeShapeUnion::usage = "OpenCascadeShapeUnion[ shape1, shape2] returns a new instance of an OpenCascade expression representing the union of the shapes shape1 and shape2.";
OpenCascadeShapeBooleanRegion::usage = "OpenCascadeShape[ expr] returns a new instance of an OpenCascade expression representing the BooleanRegion expr.";
OpenCascadeShapeDefeaturing::usage = "OpenCascadeShapeDefeaturing[ shape, {face1, ..}] returns a new instance of an OpenCascade expression with faces faces1,.. removed.";

OpenCascadeShapeFillet::usage = "OpenCascadeShapeFillet[ shape, r] returns a new instance of an OpenCascade expression with edges filleted with radius r.";
OpenCascadeShapeChamfer::usage = "OpenCascadeShapeChamfer[ shape, d] returns a new instance of an OpenCascade expression with edges chamfered with distance d.";
OpenCascadeShapeShelling::usage = "OpenCascadeShapeShelling[ shape, t, {face1, ..}] returns a new instance of an OpenCascade expression with faces thickened by t and faces1,.. removed.";

OpenCascadeShapeSewing::usage = "OpenCascadeShapeSewing[ {shape1, shape2,..}] returns a new instance of an OpenCascade expression with sewn shape1, shape2,...";
OpenCascadeShapeRotationalSweep::usage = "OpenCascadeShapeRotationalSweep[ shape, {p1, p2}, angle] returns a new instance of an OpenCascade expression that rotates shape by angle radians around the axis between p1 and p2.";
OpenCascadeShapeLinearSweep::usage = "OpenCascadeShapeLinearSweep[ shape, {p1, p2}] returns a new instance of an OpenCascade expression that linearly sweepes shape from p1 to p2.";

(* BRepBuilderAPI_GTransform seems to have issues with non-uniform scaling *)
(* https://www.opencascade.com/content/creating-ellipsoid-sphere-transformation-function-applied *)
(* OpenCascadeShapeGeometricTransformation::usage = "OpenCascadeShapeGeometricTransformation[ shape, tfun] returns a new instance of an OpenCascade expression that applies the transformation function tfun to the OpenCascade expression shape."; *)

OpenCascadeShapeSurfaceMesh::usage = "OpenCascadeShapeSurfaceMesh[ shape] returns a new instance of an OpenCascade expression with it's surface meshed.";
OpenCascadeShapeSurfaceMeshCoordinates::usage = "OpenCascadeShapeSurfaceMeshCoordinates[ shape] returns the meshed shape's coordinates.";
OpenCascadeShapeSurfaceMeshElements::usage = "OpenCascadeShapeSurfaceMeshElements[ shape] returns the meshed shape's surface elements.";
OpenCascadeShapeSurfaceMeshElementOffsets::usage = "OpenCascadeShapeSurfaceMeshElementOffsets[ shape] returns the meshed shape's element offsets.";

OpenCascadeShapeNumberOfFaces::usage = "OpenCascadeShapeNumberOfFaces[ shape] returns the number of faces in a shape.";
OpenCascadeShapeNumberOfEdges::usage = "OpenCascadeShapeNumberOfEdges[ shape] returns the number of edges in a shape.";
OpenCascadeShapeType::usage = "OpenCascadeShapeType[ shape] returns the shape type.";

OpenCascadeShapeSurfaceMeshToBoundaryMesh::usage = "OpenCascadeShapeSurfaceMeshToBoundaryMesh[ shape] returns the shape as a boundary ElementMesh.";

OpenCascadeShapeExport::usage = "OpenCascadeShapeExport[ \"file.ext\", expr] exports data from a OpenCascadeShape expression into a file. OpenCascadeShapeExport[ \"file\", expr, \"format\"] exports data in the specified format."

OpenCascadeShapeImport::usage = "OpenCascadeShapeImport[ \"file.ext\", expr] imports data from a file into a OpenCascadeShape expression. OpenCascadeShapeImport[ \"file\", expr, \"format\"] imports data in the specified format."


Options[OpenCascadeShapeExport] = {"ShapeSurfaceMeshOptions"->Automatic};
Options[OpenCascadeShapeSurfaceMesh] = Sort[ {
	"LinearDeflection"->Automatic,
	"AngularDeflection"->Automatic,
	"ComputeInParallel"->Automatic,
	"RelativeDeflection"->Automatic
}];

Options[OpenCascadeShapeSurfaceMeshToBoundaryMesh] = Sort[{
	"ShapeSurfaceMeshOptions"->Automatic,
	"ElementMeshOptions"->Automatic
}];

Begin["`Private`"]


pack = Developer`ToPackedArray;

$OpenCascadeVersion = "7.4.0"

$OpenCascadeInstallationDirectory = DirectoryName[ $InputFileName]
baseLibraryName = FileNameJoin[{ $OpenCascadeInstallationDirectory,
	"LibraryResources", $SystemID}];
$OpenCascadeLibrary = FindLibrary[ FileNameJoin[{ baseLibraryName,
		"openCascadeWolframDLL" }]];

pack = Developer`ToPackedArray;

needInitialization = True;

(*
 Load all the functions from the OpenCascade library.
*)
LoadOpenCascade[] :=
Module[{libDir, oldpath, preLoadLibs, success},

	(* since open cascade needs to be build as a shared library
	(because it is LGPL) we need to pre load the library such that
	the LibraryFunctionLoad can work *)

	libDir = FileNameJoin[{baseLibraryName, "lib"}];
	If[$OperatingSystem === "Windows",
		oldpath = Environment["PATH"];
		SetEnvironment["PATH" -> oldpath <> ";" <> libDir]
	];
	preLoadLibs = FileNames["*.*", libDir];
	success = Union[LibraryLoad /@ preLoadLibs] === {Null};
	If[$OperatingSystem === "Windows",
		SetEnvironment["PATH" -> oldpath]
	];
	If[ !success, Return[ $Failed, Module]];

	deleteFun	= LibraryFunctionLoad[$OpenCascadeLibrary, "delete_ocShapeInstance", {Integer}, Integer];

	ocShapeInstanceListFun	= LibraryFunctionLoad[$OpenCascadeLibrary, "ocShapeInstanceList", {}, {Integer,1}];
	makeBallFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeBall", {Integer, {Real, 1, "Shared"}, Real}, Integer];
	makeConeFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeCone", {Integer, {Real, 1, "Shared"}, {Real, 1, "Shared"}, Real, Real}, Integer];
	makeCuboidFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeCuboid", {Integer, {Real, 1, "Shared"}, {Real, 1, "Shared"}}, Integer];
	makeCylinderFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeCylinder", {Integer, {Real, 1, "Shared"}, {Real, 1, "Shared"}, Real, Real}, Integer];
	makePrismFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makePrism", {Integer, {Real, 2, "Shared"}, {Real, 2, "Shared"}}, Integer];

	makeSewingFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeSewing", {Integer, {Integer, 1, "Shared"}}, Integer];
	makeRotationalSweepFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeRotationalSweep", {Integer, Integer, {Real, 2, "Shared"}, Real}, Integer];
	makeLinearSweepFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeLinearSweep", {Integer, Integer, {Real, 2, "Shared"}}, Integer];
	makeGeometicTransformationFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeGeometicTransformation", {Integer, Integer, {Real, 2, "Shared"}}, Integer];

	makePolygonFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makePolygon", {Integer, {Real, 2, "Shared"}}, Integer];
	makeBSplineSurfaceFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeBSplineSurface", {Integer, {Real, 3, "Shared"}, {Real, 2, "Shared"},
		{Real, 1, "Shared"}, {Real, 1, "Shared"}, {Integer, 1, "Shared"}, {Integer, 1, "Shared"}, Integer, Integer, Integer, Integer}, Integer];

	makeDifferenceFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeDifference", {Integer, Integer, Integer}, Integer];
	makeIntersectionFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeIntersection", {Integer, Integer, Integer}, Integer];
	makeUnionFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeUnion", {Integer, Integer, Integer}, Integer];
	makeDefeaturingFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeDefeaturing", {Integer, Integer, {Integer, 1, "Shared"}}, Integer];

	makeFilletFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeFillet", {Integer, Integer, Real, {Integer, 1, "Shared"}}, Integer];
	makeChamferFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeChamfer", {Integer, Integer, Real, {Integer, 1, "Shared"}}, Integer];
	makeShellingFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeShelling", {Integer, Integer, Real, {Integer, 1, "Shared"}}, Integer];

	makeSurfaceMeshFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeSurfaceMesh", {Integer, {Real, 1, "Shared"}, {Integer, 1, "Shared"}}, Integer];
	getSurfaceMeshCoordinatesFun = LibraryFunctionLoad[$OpenCascadeLibrary, "getSurfaceMeshCoordinates", {Integer}, {Real, 2}];
	getSurfaceMeshElementsFun = LibraryFunctionLoad[$OpenCascadeLibrary, "getSurfaceMeshElements", {Integer}, {Integer, 2}];
	getSurfaceMeshElementOffsetsFun = LibraryFunctionLoad[$OpenCascadeLibrary, "getSurfaceMeshElementOffsets", {Integer}, {Integer, 1}];

	getShapeNumberOfFacesFun = LibraryFunctionLoad[$OpenCascadeLibrary, "getShapeNumberOfFaces", {Integer}, Integer];
	getShapeNumberOfEdgesFun = LibraryFunctionLoad[$OpenCascadeLibrary, "getShapeNumberOfEdges", {Integer}, Integer];
	getShapeTypeFun = LibraryFunctionLoad[$OpenCascadeLibrary, "getShapeType", {Integer}, Integer];

	fileOperationFun = LibraryFunctionLoad[$OpenCascadeLibrary, "fileOperation", LinkObject, LinkObject];

	needInitialization = False;
]


(*
 Functions for working with OpenCascadeShapeExpression
*)
getOpenCascadeShapeExpressionID[e_OpenCascadeShapeExpression] := ManagedLibraryExpressionID[e, "OpenCascadeShapeManager"];

OpenCascadeShapeExpressionQ[e_OpenCascadeShapeExpression] := TrueQ[ ManagedLibraryExpressionQ[e, "OpenCascadeShapeManager"]];
OpenCascadeShapeExpressionQ[___] := False; 

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
						"STL" | "stl", "load_stl",
						"stp"|"step", "load_step",
						"brep" | "rle", "load_brep",
						_, $Failed];
		If[ fileOperation === $Failed, Return[ $Failed, Module]];

		fileWithExtension = file;
		If[ FileExtension[file] == "",
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
					"brep", "save_brep",
					_, $Failed];
	If[ fileOperation === $Failed, Return[ $Failed, Module]];

	fileWithExtension = file;
	If[ FileExtension[file] == "",
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
		fileWithExtension
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

(**)
(* derived 3D primitives *)
(**)

OpenCascadeShape[CapsuleShape[{pMin_, pMax_}, r_]] /;
		VectorQ[pMin, NumericQ] && (Length[ pMin] == 3) && 
		VectorQ[pMax, NumericQ] && (Length[ pMax] == 3) :=
Module[{cylinder, ball1, ball2},
	cylinder = OpenCascadeShape[ Cylinder[{pMin, pMax}, r]];
	ball1 = OpenCascadeShape[ Ball[ pMin, r]];
	ball2 = OpenCascadeShape[ Ball[ pMax, r]];
	OpenCascadeShapeUnion[ball1, cylinder, ball2]
]

OpenCascadeShape[CapsuleShape[{pMin_, pMax_}]] /;
	VectorQ[pMin, NumericQ] && (Length[ pMin] == 3) && 
	VectorQ[pMax, NumericQ] && (Length[ pMax] == 3) :=
OpenCascadeShape[CapsuleShape[{pMin, pMax}, 1]]


OpenCascadeShape[ Ellipsoid[ center_, vec_]] /; 
	VectorQ[center, NumericQ] && (Length[ center] == 3) && 
	VectorQ[vec, NumericQ] && (Length[ vec] == 3) :=
OpenCascadeShape[ Ellipsoid[ center, DiagonalMatrix[vec^2]]]

OpenCascadeShape[ Ellipsoid[ center_, mat_]] /; 
	VectorQ[center, NumericQ] && (Length[ center] == 3) && 
	MatrixQ[mat, NumericQ] && (Dimensions[ mat] == {3, 3}) :=
Module[
	{temp, vals, vecs, composition, pts, pts1, pts2, pts3, pts4, bsss, 
	bsurfs},

	temp = Eigensystem[N[mat]];
	If[ Length[ temp] =!= 2, Return[ $Failed, Module]];
	{vals, vecs} = temp;

	composition = Composition[TranslationTransform[center], 
		AffineTransform[Transpose[vecs]], ScalingTransform[Sqrt[vals]]];

	pts1 = {{{1, 0, 0}, {1, 1, 0}, {0, 1, 0}},
		{{1, 0, 1}, {1, 1, 1}, {0, 1, 1}},
			{{0, 0, 1}, {0, 0, 1}, {0, 0, 1}}};
	pts2 = {{{0, 1, 0}, {-1, 1, 0}, {-1, 0, 0}},
		{{0, 1, 1}, {-1, 1, 1}, {-1, 0, 1}},
			{{0, 0, 1}, {0, 0, 1}, {0, 0, 1}}};
	pts3 = {{{-1, 0, 0}, {-1, -1, 0}, {0, -1, 0}},
		{{-1, 0, 1}, {-1, -1, 1}, {0, -1, 1}},
			{{0, 0, 1}, {0, 0, 1}, {0, 0, 1}}};
	pts4 = {{{0, -1, 0}, {1, -1, 0}, {1, 0, 0}},
		{{0, -1, 1}, {1, -1, 1}, {1, 0, 1}},
			{{0, 0, 1}, {0, 0, 1}, {0, 0, 1}}};
	pts = {pts1, pts2, pts3, pts4, -pts1, -pts2, -pts3, -pts4};

	bsss = Table[ BSplineSurface[composition /@ d,
		SplineDegree -> 2,
		SplineKnots -> {{0, 0, 0, 1, 1, 1}, {0, 0, 0, 1, 1, 1}},
		SplineWeights -> {{1, 1/Sqrt[2], 1}, {1/Sqrt[2], 1/2, 1/Sqrt[2]},
			{1, 1/Sqrt[2], 1}}
		], {d, pts}];

	bsurfs = OpenCascadeShape /@ bsss;

	bsurfs = Select[bsurfs, OpenCascadeShapeExpressionQ];

	If[ Length[ bsurfs] > 0,
		OpenCascadeShapeSewing[bsurfs]
	,
		$Failed
	]
]


OpenCascadeShape[ er:EmptyRegion[_]] := er


OpenCascadeShape[Hexahedron[p_]] /;
		MatrixQ[p, NumericQ] && (Dimensions[ p] == {8, 3}) :=
Module[{c, inci, sewenFaces},

	If[ Length[ DeleteDuplicates[p]] =!= 8, Return[$Failed, Module]];

	c = pack[ N[ p]];
	(* OpenCascade uses reverse ordering *)
	(* Reverse /@ {{1, 2, 3, 4}, {8, 7, 6, 5}, {1, 2, 6, 5}, {2, 3, 7, 6},
		{3, 4, 8, 7}, {4, 1, 5, 8}} *)
	inci = {{4, 3, 2, 1}, {5, 6, 7, 8}, {5, 6, 2, 1}, {6, 7, 3, 2},
		{7, 8, 4, 3}, {8, 5, 1, 4}};

	faces = OpenCascadeShape[Polygon[#]]& /@ (c[[#]]& /@ inci);

	(* This is sewing and making it a solid *)
	sewenFaces = OpenCascadeShapeSewing[faces];

	sewenFaces
]


OpenCascadeShape[Parallelepiped[base_, {c1_, c2_, v_}]] /;
		VectorQ[base, NumericQ] && (Length[ base] === 3) && 
		VectorQ[c1, NumericQ] && (Length[ c1] === 3) && 
		VectorQ[c2, NumericQ] && (Length[ c2] === 3) && 
		VectorQ[v, NumericQ] && (Length[ v] === 3) :=
Module[{polygon, shape, sweep},
	polygon = Polygon[{base, c1, c1 + c2, c2}];
	shape = OpenCascadeShape[polygon];
	sweep = OpenCascadeShapeLinearSweep[shape, {base, v}];
	sweep
]


OpenCascadeShape[p_Polyhedron] :=
Module[{cp, op, ip, s1, s2, shape, pc, pi, ipp},
	cp = CanonicalizePolyhedron[p];
	op = OuterPolyhedron[cp];
	ip = InnerPolyhedron[cp];

	If[ Head[op] =!= Polyhedron, Return[$Failed, Module]];

	s1 = OpenCascadeShape[Polygon @@ op];
	If[ !OpenCascadeShapeExpressionQ[ s1], Return[$Failed, Module]];

	Switch[ Head[ip],
		Polyhedron,
			If[ Length[ip] =!= 2, Return[$Failed, Module]];
			pc = ip[[1]];
			pi = ip[[2]];
			(* ip needs to be reversed *)
			ipp = Polyhedron[pc, Reverse /@ pi];
			s2 = OpenCascadeShape[Polygon @@ ipp];
			If[ !OpenCascadeShapeExpressionQ[ s2], Return[$Failed, Module]];
			shape = OpenCascadeShapeDifference[s1, s2];
			If[ !OpenCascadeShapeExpressionQ[ shape], Return[$Failed, Module]];
		,
		EmptyRegion,
			shape = s1;
		,
		_,
			Return[$Failed, Module];
		];

	shape
]


OpenCascadeShape[Pyramid[p_]] /;
		MatrixQ[p, NumericQ] && (Dimensions[ p] == {5, 3}) :=
Module[{c, inci, sewenFaces},

	If[ Length[ DeleteDuplicates[p]] =!= 5, Return[$Failed, Module]];

	c = pack[ N[ p]];
	(* OpenCascade uses reverse ordering *)
	(* Reverse /@ {{1, 2, 3, 4}, {1, 2, 5}, {2, 3, 5}, {3, 4, 5}, {4, 1, 5}} *)
	inci = {{4, 3, 2, 1}, {5, 2, 1}, {5, 3, 2}, {5, 4, 3}, {5, 1, 4}};

	faces = OpenCascadeShape[Polygon[#]]& /@ (c[[#]]& /@ inci);

	(* This is sewing and making it a solid *)
	sewenFaces = OpenCascadeShapeSewing[faces];

	sewenFaces
]


OpenCascadeShape[SphericalShell[c_, {r1_, r2_}]] /;
		VectorQ[c, NumericQ] && (Length[ c] == 3) &&
		NumericQ[r1] && NumericQ[r2] :=
Module[{balls},
	balls = OpenCascadeShape /@ {Ball[c, r2], Ball[c, r1]};
	OpenCascadeShapeDifference @@ balls
]


OpenCascadeShape[Tetrahedron[p_]] /;
		MatrixQ[p, NumericQ] && (Dimensions[ p] == {4, 3}) :=
Module[{c, inci, sewenFaces},

	If[ Length[ DeleteDuplicates[p]] =!= 4, Return[$Failed, Module]];

	c = pack[ N[ p]];
	(* OpenCascade uses reverse ordering *)
	inci = pack[{{3, 2, 1}, {4, 2, 1}, {4, 3, 2}, {4, 1, 3}}];

	faces = OpenCascadeShape[Polygon[#]]& /@ (c[[#]]& /@ inci);
	(* This is sewing and making it a solid *)
	sewenFaces = OpenCascadeShapeSewing[faces];

	sewenFaces
]


OpenCascadeShape[ br_BooleanRegion] /; Length[br] == 2 :=
	OpenCascadeShapeBooleanRegion[ br]



(* Surface operations *)

OpenCascadeShapeSewing[oces:{e1_, e2__}] /;
	 And @@ (OpenCascadeShapeExpressionQ /@ oces) :=
Module[{p, instance, res},

	ids = pack[ instanceID /@ oces];

	If[ Length[ DeleteDuplicates[ids]] =!= Length[ids], Return[$Failed, Module]];

	instance = OpenCascadeShapeCreate[];
	res = makeSewingFun[ instanceID[ instance], ids];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]
OpenCascadeShapeSewing[{e1_}] /;
	 OpenCascadeShapeExpressionQ[e1] := e1

OpenCascadeShapeRotationalSweep[ shape1_, {p1_, p2_}, a_] /;
	OpenCascadeShapeExpressionQ[shape1] &&
		VectorQ[p1, NumericQ] && (Length[p1] === 3) &&
		VectorQ[p2, NumericQ] && (Length[p2] === 3) &&
		NumericQ[a] :=
Module[
	{instance, id1, res, axis},

	axis = pack[ N[{p1, p2 - p1}]];
	angle = N[ a];

	instance = OpenCascadeShapeCreate[];
	id1 = instanceID[ shape1];
	res = makeRotationalSweepFun[ instanceID[ instance], id1, axis, angle];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]
OpenCascadeShapeRotationalSweep[ shape1_, {p1_, p2_}] :=
	OpenCascadeShapeRotationalSweep[shape1,{p1, p2}, 2 Pi]


OpenCascadeShapeLinearSweep[ shape1_, {p1_, p2_}] /;
	OpenCascadeShapeExpressionQ[shape1] &&
	VectorQ[p1, NumericQ] && (Length[p1] === 3) &&
	VectorQ[p2, NumericQ] && (Length[p2] === 3) :=
Module[
	{instance, id1, res, length, direction},

	direction = pack[ N[ { p1, p2}]];

	instance = OpenCascadeShapeCreate[];
	id1 = instanceID[ shape1];
	res = makeLinearSweepFun[ instanceID[ instance], id1, direction];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]

OpenCascadeShapeGeometricTransformation[ shape1_,
	a_TransformationFunction] /; OpenCascadeShapeExpressionQ[shape1] :=
Module[
	{tm, instance, id1, res},

	tm = pack[ N[ TransformationMatrix[a]]];

	(* OCCT can not deal with this at the moment *)
	If[ tm[[-1]] =!= {0.,0.,0.,1.}, Return[ $Failed, Module]];
	tm = tm[[1;;-2]];

	instance = OpenCascadeShapeCreate[];
	id1 = instanceID[ shape1];
	res = makeGeometicTransformationFun[ instanceID[ instance], id1, tm];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]

(* surfaces in 3D *)

OpenCascadeShape[Polygon[coords_]] /;
		MatrixQ[coords, NumericQ] && MatchQ[ Dimensions[coords], {_, 3}] :=
Module[{p, instance, res},

	p = pack[ N[ coords]];
	p = DeleteDuplicates[p];

	instance = OpenCascadeShapeCreate[];
	res = makePolygonFun[ instanceID[ instance], N[ p]];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]


OpenCascadeShape[p:Polygon[coords_, data_]] /;
	MatrixQ[coords, NumericQ] && MatchQ[ Dimensions[coords], {_, 3}] :=
Module[{mesh, c, cells, inci, poly, shapes},
	mesh = Quiet[ DiscretizeRegion[p, MaxCellMeasure -> Infinity]];
	If[ MeshRegionQ[ mesh],
		c = MeshCoordinates[ mesh];
		cells = MeshCells[ mesh, {2, All}, Multicells -> True];
		inci = Join @@ cells[[All, 1]];
		poly = Polygon /@ (c[[#]]& /@ inci);
		shapes = OpenCascadeShape /@ poly;
		If[ Union[ OpenCascadeShapeExpressionQ /@ shapes] === {True},
			OpenCascadeShapeSewing[ shapes]
		, (* else *)
			Return[ $Failed, Module]
		]
	, (* else *)
		Return[ $Failed, Module]
	]
]


strictIncreaseQ := strictIncreaseQ = Compile[{{d, _Real, 1}},
Module[{len = Length[d], i = 1},
	If[len == 1, Return[True]];
	While[i < len,
		If[d[[i]] >= d[[i + 1]], Break[]];
		i++;
	];
	If[i < (len - 1), False, True]
	]
]

OpenCascadeShape[bss:BSplineSurface[pts_, OptionsPattern[]]] /;
	Length[ Dimensions[ pts]] === 3 :=
Module[
	{poles, weights, uknots, vknots, umults, vmults, udegree, vdegree, 
	uperiodic, vperiodic, instance, res, temp, nrows, ncols, k, w, d, c},

	poles = pack[ N[ pts]];
	{nrows, ncols} = Dimensions[poles][[{1,2}]];

	{k, w, d, c} = OptionValue[BSplineSurface,
		{SplineKnots, SplineWeights, SplineDegree, SplineClosed}];

	d = d /. Automatic -> 3;
	d = Flatten[{d, d}][[{1,2}]];
	If[ !VectorQ[ d, (Positive[#] && IntegerQ[#]) &],
		Return[ $Failed, Module]
	];
	{udegree, vdegree} = d;

	If[ w === Automatic,
		weights = ConstantArray[1., Most[Dimensions[poles]]];
	,
		weights = pack[ N[ w]];
	];

(*
	c = c /. Automatic -> False;
	c = Boole[ Flatten[{c, c}][[{1,2}]]];
	If[ !VectorQ[ temp, IntegerQ],
		Return[ $Failed, Module]
	];
	{uperiodic, vperiodic} = c;
*)
	(* It is not clear how periodic BSplineSurface works in OCCT, however,
	for discretization it might not be that important. The difference will
	be that the BSpline surface is not truly closed and will have a line
	along the connected edge in the discretization *)
	{uperiodic, vperiodic} = {0, 0};

	If[ Length[ k] === 1, k = {k, k};];

	If[ !ListQ[ k[[1]]],
        Switch[k[[1]],
            "Clamped" | Automatic,
			t = 1;
			temp = Join[
				Table[0, {udegree + 1}],
				Table[t++, {nrows - 1 - udegree}],
				Table[t, {udegree + 1}]
			];
            k[[1]] = temp;
		, 
            "Unclamped", 
			t = -udegree;
			k[[1]] = Table[t++, {nrows + udegree + 1}];
        ];
	];

	If[ !ListQ[ k[[2]]],
        Switch[k[[2]],
            "Clamped" | Automatic, 
			t = 1;
			temp = Join[
				Table[0, {vdegree + 1}],
				Table[t++, {ncols - 1 - vdegree}],
				Table[t, {vdegree + 1}]
			];
            k[[2]] = temp;
		, 
            "Unclamped", 
			t = -vdegree;
			k[[2]] = Table[t++, {ncols + vdegree + 1}];
        ];
	]; 

	{uknots, vknots} = N[ k];
	(* TODO: check (?) WL requitement: u_i >= u_i+1 *)
	{uknots, umults} = pack /@ Transpose[Tally[uknots]];
	{vknots, vmults} = pack /@ Transpose[Tally[vknots]];
	(* u_i > u_i+1: This is an OpenCascde requirement *)
	If[ !strictIncreaseQ[ uknots] || !strictIncrease[ vknots],
		Return[ $Failed, Module];
	];

	If[ (Length[ umults] != Length[ uknots]) ||
		(Length[ vmults] != Length[ vknots]) ||
		Length[ uknots] < 2 || Length[ vknots] < 2 ,
		Return[ $Failed, Module];
	]; 


	(* more needs to be implemented for the u/v-periodic case
	(SplineClosed->True) *)

	If[ uperiodic == 1,
		If[ umults[[-1]] != umults[[1]], Return[ $Failed, Module]];
		If[ Total[ umults[[1;;-2]]] =!= nrows, Return[ $Failed, Module]];
	,
		(* NON periodic surface (SplineClosed -> False) *)
		If[ (Total[umults] - udegree -1) =!= nrows, Return[ $Failed, Module]];
	];

	If[ vperiodic == 1,
		If[ vmults[[-1]] != vmults[[1]], Return[ $Failed, Module]];
		If[ Total[ vmults[[1;;-2]]] =!= ncols, Return[ $Failed, Module]];
	,
		(* NON periodic surface (SplineClosed -> False) *)
		If[ (Total[vmults] - vdegree -1) =!= ncols, Return[ $Failed, Module]];
	];

	instance = OpenCascadeShapeCreate[];
	res = makeBSplineSurfaceFun[ instanceID[ instance], poles, weights,
		uknots, vknots, umults, vmults, udegree, vdegree, uperiodic, vperiodic];
	If[ res =!= 0, Return[ $Failed, Module]];

	instance
]


OpenCascadeShape[mesh_] /;
	!NDSolve`FEM`BoundaryElementMeshQ[ mesh] && NDSolve`FEM`ElementMeshQ[mesh] :=
OpenCascadeShape[ NDSolve`FEM`ToBoundaryMesh[ mesh]]

OpenCascadeShape[bmesh_] /;
	NDSolve`FEM`BoundaryElementMeshQ[ bmesh] :=
Module[{coords, faces, polygons, faceCoords},
	coords = bmesh["Coordinates"];
	faces = NDSolve`FEM`ElementIncidents[bmesh["BoundaryElements"]];
	polygons = {};
	Do[
		faceCoords = NDSolve`FEM`GetElementCoordinates[coords, f];
		Do[
			polygons = {polygons, OpenCascadeShape[Polygon[p]]};
		, {p, faceCoords}
		];
	, {f, faces}
	];
	polygons = Flatten[polygons];
	OpenCascadeShapeSewing[polygons]
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

OpenCascadeShapeDifference[eN__] /;
	And @@ (OpenCascadeShapeExpressionQ /@ {eN}) === True :=
Fold[OpenCascadeShapeDifference, {eN}]


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

OpenCascadeShapeIntersection[eN__] /;
	And @@ (OpenCascadeShapeExpressionQ /@ {eN}) === True :=
Fold[OpenCascadeShapeIntersection, {eN}]


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

OpenCascadeShapeUnion[eN__] /;
	And @@ (OpenCascadeShapeExpressionQ /@ {eN}) === True :=
Fold[OpenCascadeShapeUnion, {eN}]


OpenCascadeShapeBooleanRegion[ br_BooleanRegion] /; Length[br] == 2 :=
Module[
	{booleanFunction, regions},

	booleanFunction = br[[1]] //. {
		Or :> OpenCascadeShapeUnion,
		And[s1_, Not[s2_]] :> OpenCascadeShapeDifference[s1, s2],
		And[Not[s2_], s1_] :> OpenCascadeShapeDifference[s1, s2],
		And :> OpenCascadeShapeIntersection,
		Xor[s1_, sn__] :> OpenCascadeShapeUnion @@
			(OpenCascadeShapeDifference @@ Tuples[{s1, sn}, 2])
	};

	regions = OpenCascadeShape /@ br[[2]];
	(* TODO: check that all regions valid *)

	booleanFunction @@ regions
]


OpenCascadeShapeDefeaturing[shape_, faceIDs_] /; 
		OpenCascadeShapeExpressionQ[shape] &&
		VectorQ[faceIDs, NumericQ] :=
Module[
	{instance, numFaces, id1, res, t, fIDs = faceIDs},

	numFaces = getShapeNumberOfFacesFun[ instanceID[ shape]];

	fIDs = Sort[ pack[ fIDs]];
	If[ fIDs === {}, Return[ shape, Module]; ];

	If[ Max[ fIDs] > numFaces, Return[ shape, Module]; ];

	instance = OpenCascadeShapeCreate[];
	id1 = instanceID[ shape];
	(* - 1 since C uses 0 index start *)
	res = makeDefeaturingFun[ instanceID[ instance], id1, fIDs - 1];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]


OpenCascadeShapeNumberOfFaces[shape_] /; OpenCascadeShapeExpressionQ[shape] :=
getShapeNumberOfFacesFun[ instanceID[ shape]]

OpenCascadeShapeNumberOfEdges[shape_] /; OpenCascadeShapeExpressionQ[shape] :=
getShapeNumberOfEdgesFun[ instanceID[ shape]]

OpenCascadeShapeType[shape_] /; OpenCascadeShapeExpressionQ[shape] :=
Module[{type},
	type = getShapeTypeFun[ instanceID[ shape]];

	(* These come from the TopAbs_ShapeEnum *)

	Switch[ type,
		0, "Compound",
		1, "CompundSolid",
		2, "Solid",
		3, "Shell",
		4, "Face",
		5, "Wire",
		6, "Edge",
		7, "Vertex",
		8, "Shape",
		_, $Failed
	]
]



OpenCascadeShapeFillet[shape_, radius_, edgeIDs_] /; 
		OpenCascadeShapeExpressionQ[shape] &&
		NumericQ[ radius] &&
		(edgeIDs === All || VectorQ[edgeIDs, NumericQ]) :=
Module[
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


OpenCascadeShapeChamfer[shape_, distance_, edgeIDs_] /; 
		OpenCascadeShapeExpressionQ[shape] &&
		NumericQ[ distance] &&
		(edgeIDs === All || VectorQ[edgeIDs, NumericQ]) :=
Module[
	{instance, numEdges, id1, res, d, eIDs = edgeIDs},

	d = N[ distance];
	If[ d < $MachineEpsilon, Return[ shape, Module]; ];

	numEdges = getShapeNumberOfEdgesFun[ instanceID[ shape]];
	If[ eIDs === All, eIDs = Range[ numEdges]; ];

	eIDs = Sort[ pack[ eIDs]];
	If[ eIDs === {}, Return[ shape, Module]; ];

	If[ Max[ eIDs] > numEdges, Return[ shape, Module]; ];

	instance = OpenCascadeShapeCreate[];
	id1 = instanceID[ shape];
	(* - 1 since C uses 0 index start *)
	res = makeChamferFun[ instanceID[ instance], id1, d, eIDs - 1];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]

OpenCascadeShapeChamfer[shape_, distance_] :=
	OpenCascadeShapeChamfer[ shape, distance, All] 


OpenCascadeShapeShelling[shape_, thickness_, faceIDs_] /; 
		OpenCascadeShapeExpressionQ[shape] &&
		NumericQ[ thickness] &&
		VectorQ[faceIDs, NumericQ] :=
Module[
	{instance, numFaces, id1, res, t, fIDs = faceIDs},

	t = N[ thickness];
	If[ t < $MachineEpsilon, Return[ shape, Module]; ];

	numFaces = getShapeNumberOfFacesFun[ instanceID[ shape]];

	fIDs = Sort[ pack[ fIDs]];
	If[ fIDs === {}, Return[ shape, Module]; ];

	If[ Max[ fIDs] > numFaces, Return[ shape, Module]; ];

	instance = OpenCascadeShapeCreate[];
	id1 = instanceID[ shape];
	(* - 1 since C uses 0 index start *)
	res = makeShellingFun[ instanceID[ instance], id1, t, fIDs - 1];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]



(*
	surface meshing and meshed component extraction
*)

OpenCascadeShapeSurfaceMesh[
	OpenCascadeShapeExpression[ id_]?(testOpenCascadeShapeExpression[OpenCascadeShapeSurfaceMesh]),
	opts:OptionsPattern[OpenCascadeShapeSurfaceMesh]
] := 
Module[
	{res, realParams, boolParams, ldeflection, adeflection, parallelQ,
	relativeQ},

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

	parallelQ = OptionValue["ComputeInParallel"];
	If[ !BooleanQ[ parallelQ], parallelQ = False];

	relativeQ = OptionValue["RelativeDeflection"];
	If[ !BooleanQ[ relativeQ], relativeQ = True];

	realParams = pack[{
		(* Angle *)				adeflection,
		(* Deflection *)		ldeflection,
		(* AngleInterior *)		0.,
		(* DeflectionInterior*)	0.,
		(* MinSize *)			0.
	}];

	boolParams = pack[Boole[{
		(* InParallel *)				parallelQ,
		(* Relative *)					relativeQ,
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
	If[ Length[coords] < 3, Return[$Failed, Module]; ];

	bEle = OpenCascadeShapeSurfaceMeshElements[instance];
	If[ Length[bEle] < 1, Return[$Failed, Module]; ];

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


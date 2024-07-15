
BeginPackage["OpenCascadeLink`"]

$OpenCascadeLibrary::usage = "$OpenCascadeLibrary is the full path to the OpenCascade Library loaded by OpenCascadeLink."

$OpenCascadeInstallationDirectory::usage = "$OpenCascadeInstallationDirectory gives the top-level directory in which your OpenCascade installation resides."

$OpenCascadeVersion::usage = "$OpenCascadeVersion gives the version number of the OpenCascade library."

OpenCascadeShapeExpression::usage = "OpenCascadeShapeExpression[ id] represents an instance of a OpenCascadeShape object."

OpenCascadeShapeExpression2D::usage = "OpenCascadeShapeExpressionw2D[ id] represents an instance of a 2D OpenCascadeShape object."

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
OpenCascadeShapeCSGRegion::usage = "OpenCascadeShape[ expr] returns a new instance of an OpenCascade expression representing the CSGRegion expr.";

OpenCascadeShapeSplit::usage = "OpenCascadeShapeSplit[ shapes, tools] returns a list of instances of OpenCascade expressions representing the shapes split by tools.";

OpenCascadeShapeDefeaturing::usage = "OpenCascadeShapeDefeaturing[ shape, {face1, ..}] returns a new instance of an OpenCascade expression with faces faces1,.. removed.";
OpenCascadeShapeSimplify::usage = "OpenCascadeShapeSimplify[ shape] returns a new instance of an OpenCascade expression with a simplified shape.";
OpenCascadeShapeFix::usage = "OpenCascadeShapeFix[ shape] returns a new instance of an OpenCascade expression with a fixed shape.";

OpenCascadeShapeFillet::usage = "OpenCascadeShapeFillet[ shape, r] returns a new instance of an OpenCascade expression with edges filleted with radius r.";
OpenCascadeShapeChamfer::usage = "OpenCascadeShapeChamfer[ shape, d] returns a new instance of an OpenCascade expression with edges chamfered with distance d.";
OpenCascadeShapeShelling::usage = "OpenCascadeShapeShelling[ shape, t, {face1, ..}] returns a new instance of an OpenCascade expression with faces thickened by t and faces1,.. removed.";

OpenCascadeShapeSewing::usage = "OpenCascadeShapeSewing[ {shape1, shape2,..}] returns a new instance of an OpenCascade expression with sewn shape1, shape2,...";
OpenCascadeShapeRotationalSweep::usage = "OpenCascadeShapeRotationalSweep[ shape, {p1, p2}, angle] returns a new instance of an OpenCascade expression that rotates shape by angle radians around the axis between p1 and p2.";
OpenCascadeShapeLinearSweep::usage = "OpenCascadeShapeLinearSweep[ shape, {p1, p2}] returns a new instance of an OpenCascade expression that linearly sweepes shape from p1 to p2.";
OpenCascadeShapePathSweep::usage = "OpenCascadeShapePathSweep[ shape, path] returns a new instance of an OpenCascade expression that sweepes shape along path.";

OpenCascadeShapeLoft::usage = "OpenCascadeShapeLoft[ {shape1, shape2,..}] returns a new instance of an OpenCascade expression with a shape that is lofted through shape1, shape2,...";

(* BRepBuilderAPI_GTransform seems to have issues with non-uniform scaling *)
(* https://www.opencascade.com/content/creating-ellipsoid-sphere-transformation-function-applied *)
OpenCascadeShapeTransformation::usage = "OpenCascadeShapeTransformation[ shape, tfun] returns a new instance of an OpenCascade expression that applies the transformation function tfun to the OpenCascade expression shape.";

OpenCascadeShapeCompound::usage = "OpenCascadeShapeCompound[ {shape1,..}] returns a new instance of an OpenCascade expression with a compound from shape1, ...";
OpenCascadeShapeCompSolid::usage = "OpenCascadeShapeCompSolid[ {shape1,..}] returns a new instance of an OpenCascade expression with a compsolid from solid shape1, ...";
OpenCascadeShapeSolid::usage = "OpenCascadeShapeSolid[ {shape1,..}] returns a new instance of an OpenCascade expression with a solid from shape1, ...";
OpenCascadeShapeShell::usage = "OpenCascadeShapeShell[ {shape1,..}] returns a new instance of an OpenCascade expression with a shell from face shape1, ...";
OpenCascadeShapeFace::usage = "OpenCascadeShapeFace[ {shape1,..}] returns a new instance of an OpenCascade expression with a face from shape1, ...";
OpenCascadeShapeWire::usage = "OpenCascadeShapeWire[ {shape1,..}] returns a new instance of an OpenCascade expression with a wire from shape1, ...";

OpenCascadeShapeSurfaceMesh::usage = "OpenCascadeShapeSurfaceMesh[ shape] returns a new instance of an OpenCascade expression with it's surface meshed.";
OpenCascadeShapeSurfaceMeshCoordinates::usage = "OpenCascadeShapeSurfaceMeshCoordinates[ shape] returns the meshed shape's coordinates.";
OpenCascadeShapeSurfaceMeshElements::usage = "OpenCascadeShapeSurfaceMeshElements[ shape] returns the meshed shape's surface elements.";
OpenCascadeShapeSurfaceMeshElementOffsets::usage = "OpenCascadeShapeSurfaceMeshElementOffsets[ shape] returns the meshed shape's element offsets.";

OpenCascadeShapeNumberOfSolids::usage = "OpenCascadeShapeNumberOfSolids[ shape] returns the number of solids in a shape.";
OpenCascadeShapeNumberOfFaces::usage = "OpenCascadeShapeNumberOfFaces[ shape] returns the number of faces in a shape.";
OpenCascadeShapeNumberOfEdges::usage = "OpenCascadeShapeNumberOfEdges[ shape] returns the number of edges in a shape.";
OpenCascadeShapeNumberOfVertices::usage = "OpenCascadeShapeNumberOfVertices[ shape] returns the number of vertices in a shape.";
OpenCascadeShapeType::usage = "OpenCascadeShapeType[ shape] returns the shape type.";

OpenCascadeShapeSolids::usage = "OpenCascadeShapeSolids[ shape] returns the solids in a shape.";
OpenCascadeShapeFaces::usage = "OpenCascadeShapeFaces[ shape] returns the faces in a shape.";
OpenCascadeShapeEdges::usage = "OpenCascadeShapeEdges[ shape] returns the edges in a shape.";
OpenCascadeShapeVertices::usage = "OpenCascadeShapeVertices[ shape] returns the vertices in a shape.";

OpenCascadeShapeSurfaceMeshToBoundaryMesh::usage = "OpenCascadeShapeSurfaceMeshToBoundaryMesh[ shape] returns the shape as a boundary ElementMesh.";

OpenCascadeFaceType::usage = "OpenCascadeFaceType[ shape] returns the type of a face.";
OpenCascadeEdgeType::usage = "OpenCascadeEdgeType[ shape] returns the type of an edge.";
OpenCascadeFaceBSplineSurface::usage = "OpenCascadeFaceBSplineSurface[ shape] returns a BSplineSurface of shape.";

OpenCascadeGraphics3D::usage = "OpenCascadeGraphics3D[ shape] returns a Graphics3D of shape.";
OpenCascadeGraphics3DPrimitives::usage = "OpenCascadeGraphics3DPrimitives[ shape] returns a Graphics3D primitives of shape.";

OpenCascadeShapeExport::usage = "OpenCascadeShapeExport[ \"file.ext\", expr] exports data from a OpenCascadeShape expression into a file. OpenCascadeShapeExport[ \"file\", expr, \"format\"] exports data in the specified format."

OpenCascadeShapeImport::usage = "OpenCascadeShapeImport[ \"file.ext\", expr] imports data from a file into a OpenCascadeShape expression. OpenCascadeShapeImport[ \"file\", expr, \"format\"] imports data in the specified format."


OpenCascadeTorus::usage = "OpenCascadeTorus[ axis, r1, r2] represents an open cascade torus.";
OpenCascadeDisk::usage = "OpenCascadeDisk[{center, vector}, radius, {angle1, angle2}] represents an open cascade disk.";
OpenCascadeCircle::usage = "OpenCascadeCircle[{center, vector}, radius, {angle1, angle2}] represents an open cascade circle.";

Circle3D::usage = "Circle3D[{centre_, normal_}, radius_ : 1, angle_ : {0, 2 Pi}] returns a 3D circle graphics primitive to be used in Graphics3D."
Disk3D::usage = "Disk3D[{centre_, normal_}, radius_ : 1, angle_ : {0, 2 Pi}] returns a 3D disk graphics primitive to be used in Graphics3D."
OpenCascadeAxis3D::usage = "OpenCascadeAxis3D[o, s] returns a Graphics3D with an axis system with origin o and possibly scaled by s."

(**)
(* TODO: possible extensions *)
(**)
(* Pipes:
https://dev.opencascade.org/doc/occt-7.6.0/refman/html/class_b_rep_offset_a_p_i___make_pipe.html#details
https://dev.opencascade.org/doc/occt-7.6.0/refman/html/class_b_rep_feat___make_pipe.html#a34a5e6e5c648a9d951e9d403f6bcf53f
https://dev.opencascade.org/comment/24234#comment-24234
*)


Options[OpenCascadeShapeExport] = {"ShapeSurfaceMeshOptions"->Automatic};

Options[OpenCascadeShapeSurfaceMesh] = Sort[ {
	"LinearDeflection"->Automatic,
	"AngularDeflection"->Automatic,
	"ComputeInParallel"->Automatic,
	"RelativeDeflection"->Automatic,
	"Rediscretization"->Automatic
}];

Options[OpenCascadeShapeSurfaceMeshToBoundaryMesh] = Sort[{
	"ShapeSurfaceMeshOptions"->Automatic,
	"ElementMeshOptions"->Automatic,
	"MarkerMethod"->Automatic
}];

Options[OpenCascadeShapeSewing] = Sort[ {
	"BuildSolid" -> Automatic
}];

Options[OpenCascadeShapeSimplify] = Sort[ {
	"SimplifyFaces" -> Automatic,
	"SimplifyEdges" -> Automatic,
	"SimplifyBSplineEdges" -> Automatic,
	"LinearTolerance" -> Automatic,
	"AngularTolerance" -> Automatic,
	"AngularTolerance" -> Automatic,
	"KeepEdges" -> Automatic,
	"KeepVertices" -> Automatic,
	"AllowInternalEdges" -> Automatic
}];

Options[OpenCascadeShapeLoft] = Sort[ {
	"BuildSolid" -> Automatic,
	"CheckCompatibility" -> Automatic
}];

Options[OpenCascadeShapeInactiveRegion] = 
Options[OpenCascadeShapeBooleanRegion] = 
Options[OpenCascadeShapeCSGRegion] = 
Options[OpenCascadeShapeDifference] =
Options[OpenCascadeShapeIntersection] =
Options[OpenCascadeShapeUnion] = Sort[ {
	"SimplifyResult" -> Automatic
}];


Options[OpenCascadeShapePathSweep] = Sort[{
	"ForceC1Continuity" -> Automatic
}]

Options[OpenCascadeFaceBSplineSurface] = Sort[ {
	"SetPeriodic"->Automatic
}];

Begin["`Private`"]


pack = Developer`ToPackedArray;
packedQ = Developer`PackedArrayQ;

$OpenCascadeVersion = "7.6.3"

$OpenCascadeInstallationDirectory = DirectoryName[ $InputFileName]
baseLibraryName = FileNameJoin[{ $OpenCascadeInstallationDirectory,
	"LibraryResources", $SystemID}];
$OpenCascadeLibrary = FindLibrary[ FileNameJoin[{ baseLibraryName,
		"openCascadeWolframDLL" }]];

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
	preLoadLibs = If[$OperatingSystem === "MacOSX", {}, FileNames["*.*", libDir]];
	success = FreeQ[ Union[LibraryLoad /@ preLoadLibs], $Failed];
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
	makeTorusFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeTorus", {Integer, {Real, 2, "Shared"}, Real, Real, Real, Real, Real}, Integer];

	makeSewingFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeSewing", {Integer, {Integer, 1, "Shared"}, Integer}, Integer];
	makeRotationalSweepFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeRotationalSweep", {Integer, Integer, {Real, 2, "Shared"}, Real}, Integer];
	makeLinearSweepFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeLinearSweep", {Integer, Integer, {Real, 2, "Shared"}}, Integer];
	makePathSweepFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makePathSweep", {Integer, Integer, Integer, Integer, Integer}, Integer];
	makeTransformationFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeTransformation", {Integer, Integer, {Real, 2, "Shared"}}, Integer];

	makeBSplineSurfaceFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeBSplineSurface", {Integer, {Real, 3, "Shared"}, {Real, 2, "Shared"},
		{Real, 1, "Shared"}, {Real, 1, "Shared"}, {Integer, 1, "Shared"}, {Integer, 1, "Shared"}, Integer, Integer, Integer, Integer}, Integer];
	makeBSplineCurveFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeBSplineCurve", {Integer, {Real, 2, "Shared"}, {Real, 1, "Shared"},
		{Real, 1, "Shared"}, {Integer, 1, "Shared"}, Integer, Integer}, Integer];
	makeBezierCurveFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeBezierCurve", {Integer, {Real, 2, "Shared"}}, Integer];

	makePolygonFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makePolygon", {Integer, {Real, 2, "Shared"}}, Integer];
	makeCircleFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeCircle", {Integer, {Real, 2, "Shared"}, Real, Integer, Real, Real, {Real, 2, "Shared"}}, Integer];
	makeLineFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeLine", {Integer, {Real, 2, "Shared"}}, Integer];

	makeCompoundFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeCompound", {Integer, {Integer, 1, "Shared"}}, Integer];
	makeCompSolidFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeCompSolid", {Integer, {Integer, 1, "Shared"}}, Integer];
	makeSolidFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeSolid", {Integer, {Integer, 1, "Shared"}}, Integer];
	makeShellFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeShell", {Integer, {Integer, 1, "Shared"}}, Integer];
	makeFaceFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeFace", {Integer, {Integer, 1, "Shared"}}, Integer];
	makeWireFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeWire", {Integer, {Integer, 1, "Shared"}}, Integer];

	makeDifferenceFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeDifference", {Integer, Integer, Integer, Integer}, Integer];
	makeIntersectionFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeIntersection", {Integer, Integer, Integer, Integer}, Integer];
	makeUnionFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeUnion", {Integer, Integer, Integer, Integer}, Integer];

	makeSplitFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeSplit", {Integer, {Integer, 1, "Shared"}, {Integer, 1, "Shared"}, Integer, Integer, Integer}, Integer];

	makeDefeaturingFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeDefeaturing", {Integer, Integer, {Integer, 1, "Shared"}}, Integer];
	makeSimplifyFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeSimplify", {Integer, Integer, {Integer, 1, "Shared"}, {Integer, 1, "Shared"}, Integer, Real, Real}, Integer];
	makeShapeFixFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeShapeFix", {Integer, Integer}, Integer];

	makeFilletFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeFillet", {Integer, Integer, Real, {Integer, 1, "Shared"}}, Integer];
	makeChamferFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeChamfer", {Integer, Integer, Real, {Integer, 1, "Shared"}}, Integer];
	makeShellingFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeShelling", {Integer, Integer, Real, {Integer, 1, "Shared"}}, Integer];

	makeLoftFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeLoft", {Integer, {Integer, 1, "Shared"}, Integer}, Integer];

	makeSurfaceMeshFun = LibraryFunctionLoad[$OpenCascadeLibrary, "makeSurfaceMesh", {Integer, {Real, 1, "Shared"}, {Integer, 1, "Shared"}}, Integer];
	getSurfaceMeshCoordinatesFun = LibraryFunctionLoad[$OpenCascadeLibrary, "getSurfaceMeshCoordinates", {Integer}, {Real, 2}];
	getSurfaceMeshElementsFun = LibraryFunctionLoad[$OpenCascadeLibrary, "getSurfaceMeshElements", {Integer}, {Integer, 2}];
	getSurfaceMeshElementOffsetsFun = LibraryFunctionLoad[$OpenCascadeLibrary, "getSurfaceMeshElementOffsets", {Integer}, {Integer, 1}];

	getShapeTypeFun = LibraryFunctionLoad[$OpenCascadeLibrary, "getShapeType", {Integer}, Integer];

	getShapeNumberOfSolidsFun = LibraryFunctionLoad[$OpenCascadeLibrary, "getShapeNumberOfSolids", {Integer}, Integer];
	getShapeNumberOfFacesFun = LibraryFunctionLoad[$OpenCascadeLibrary, "getShapeNumberOfFaces", {Integer}, Integer];
	getShapeNumberOfEdgesFun = LibraryFunctionLoad[$OpenCascadeLibrary, "getShapeNumberOfEdges", {Integer}, Integer];
	getShapeNumberOfVerticesFun = LibraryFunctionLoad[$OpenCascadeLibrary, "getShapeNumberOfVertices", {Integer}, Integer];

	getShapeSolidsFun = LibraryFunctionLoad[$OpenCascadeLibrary, "getShapeSolids", {{Integer, 1, "Shared"}, Integer, {Integer, 1, "Shared"}}, Integer];
	getShapeFacesFun = LibraryFunctionLoad[$OpenCascadeLibrary, "getShapeFaces", {{Integer, 1, "Shared"}, Integer, {Integer, 1, "Shared"}}, Integer];
	getShapeEdgesFun = LibraryFunctionLoad[$OpenCascadeLibrary, "getShapeEdges", {{Integer, 1, "Shared"}, Integer, {Integer, 1, "Shared"}}, Integer];
	getShapeVerticesFun = LibraryFunctionLoad[$OpenCascadeLibrary, "getShapeVertices", {{Integer, 1, "Shared"}, Integer, {Integer, 1, "Shared"}}, Integer];

	getFaceTypeFun = LibraryFunctionLoad[$OpenCascadeLibrary, "getFaceType", {Integer}, Integer];
	getEdgeTypeFun = LibraryFunctionLoad[$OpenCascadeLibrary, "getEdgeType", {Integer}, Integer];
	getFaceBSplineSurfaceFun = LibraryFunctionLoad[$OpenCascadeLibrary, "getFaceBSplineSurface", {Integer, Integer}, {Real, 1}];

	fileOperationFun = LibraryFunctionLoad[$OpenCascadeLibrary, "fileOperation", LinkObject, LinkObject];

	needInitialization = False;
]


(* Utility functions *)

Circle3D[{centre_, normal_}, radius_:1, angle_:{0, 2 Pi}] /; 
	NumericQ[radius] && radius > 0 && 
	NumericQ[angle[[1]]] && NumericQ[angle[[2]]] && (Abs[angle[[1]] - angle[[2]]] <= 2 Pi) :=
Module[{r, mp, mp3D},
	r = DiscretizeRegion[Circle[centre[[{1, 2}]], radius, angle]];
	mp = MeshPrimitives[r, 1, Multicells -> True];
	mp3D = mp /. {x_Real, y_Real} :> {x, y, centre[[3]]};
	RotationTransform[{{0, 0, 1}, normal}, centre] /@ mp3D
]


Disk3D[{centre_, normal_}, radius_:1, angle_:{0, 2 Pi}] /; 
	NumericQ[radius] && radius > 0 && 
	NumericQ[angle[[1]]] && NumericQ[angle[[2]]] && (Abs[angle[[1]] - angle[[2]]] <= 2 Pi) :=
Module[{r, mp, mp3D},
	r = BoundaryDiscretizeRegion[ Disk[centre[[{1, 2}]], radius, angle]];
	mp = MeshPrimitives[r, 2, Multicells -> True];
	mp3D = mp /. {x_Real, y_Real} :> {x, y, centre[[3]]};
	RotationTransform[{{0, 0, 1}, normal}, centre] /@ mp3D
]

OpenCascadeAxis3D[o_ : {0, 0, 0}, s_ : 1] := OpenCascadeAxis3D[o, {s, s, s}]
OpenCascadeAxis3D[o_ : {0, 0, 0}, {sx_, sy_, sz_}] :=
Graphics3D[{
	{Red, Arrow[{o, o + {1, 0, 0}*sx}]},
	{Green, Arrow[{o, o + {0, 1, 0}*sy}]},
	{Blue, Arrow[{o, o + {0, 0, 1}*sz}]},
	{	Text["X", o + {1, 0, 0}*sx],
		Text["Y", o + {0, 1, 0}*sy],
		Text["Z", o + {0, 0, 1}*sz]
	}
}, Axes -> True];

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
						"stp" | "step" | "STP" | "STEP", "load_step",
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
					"step" | "stp" | "STP" | "STEP", "save_step",
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
OpenCascadeShapeUnion[OpenCascadeShape[Ball[#, r]]& /@ p]


OpenCascadeShape[Cone[{pMin_, pMax_}, r_]] /;
		VectorQ[pMin, NumericQ] && (Length[ pMin] == 3) && 
		VectorQ[pMax, NumericQ] && (Length[ pMax] == 3) &&
		NumericQ[r] :=
Module[{instance, res, origin, h},

	p1 = pack[ N[ pMin]];
	p2 = pack[ N[ pMax]];

	h = Norm[p1 - p2];

	instance = OpenCascadeShapeCreate[];
	res = makeConeFun[ instanceID[ instance], p1, p2 - p1, N[ r], h];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]

OpenCascadeShape[Cone[{pMin_, pMax_}]] /;
		VectorQ[pMin, NumericQ] && (Length[ pMin] == 3) && 
		VectorQ[pMax, NumericQ] && (Length[ pMax] == 3) :=
OpenCascadeShape[Cone[{pMin, pMax}, 1.]]

OpenCascadeShape[Cone[{pMin_, pMax_}]] /;
		MatrixQ[pMin, NumericQ] && (Last[ Dimensions[ pMin]] == 3) &&
		MatrixQ[pMax, NumericQ] && (Last[ Dimensions[ pMax]] == 3) &&
		Dimensions[ pMin] === Dimensions[ pMax] :=
OpenCascadeShape /@ Thread[ Cone[{pMin, pMax}]]

OpenCascadeShape[Cone[{pMin_, pMax_}, r_]] /;
		MatrixQ[pMin, NumericQ] && (Last[ Dimensions[ pMin]] == 3) &&
		MatrixQ[pMax, NumericQ] && (Last[ Dimensions[ pMax]] == 3) &&
		Dimensions[ pMin] === Dimensions[ pMax] &&
		VectorQ[ r, NumericQ] && Length[ r] === Length[ pMin]:=
OpenCascadeShape /@ Thread[ Cone[{pMin, pMax}, r]]


OpenCascadeShape[Cube[]] := OpenCascadeShape[Cube[1]]

OpenCascadeShape[Cube[l_]] /; NumericQ[l] := OpenCascadeShape[
	Cube[{0, 0, 0}, l]]

OpenCascadeShape[Cube[base_, l_]] /; 
	VectorQ[base, NumericQ] && (Length[base] == 3) &&
	NumericQ[l] := OpenCascadeShape[
	Cuboid[{-1, -1, -1}*l/2 + base, {1, 1, 1}*l/2 + base]]


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

OpenCascadeShape[
	OpenCascadeTorus[{p1_, p2_}, rIn1_, rIn2_, angle_, {angle1_, angle2_}]
	] /;
		VectorQ[p1, NumericQ] && (Length[ p1] == 3) &&
		VectorQ[p2, NumericQ] && (Length[ p2] == 3) &&
		NumericQ[rIn1] && NumericQ[rIn2] && (rIn1 > rIn2) &&
		NumericQ[angle] && (0 < angle <= 2 Pi) && 
		NumericQ[angle1] && NumericQ[angle2] && (0 < angle2 - angle1 <= 2 Pi) := 
Module[{instance, res, axis, r1, r2, a1, a2, a},

	axis = pack[ N[{p1, p2 - p1}]];
	r1 = N[ rIn1];
	r2 = N[ rIn2];
	a1 = N[ angle1];
	a2 = N[ angle2];
	a = N[ angle];

	instance = OpenCascadeShapeCreate[];
	res = makeTorusFun[ instanceID[ instance], axis, r1, r2, a1, a2, a];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]

OpenCascadeShape[OpenCascadeTorus[{p1_, p2_}, r1_, r2_]] :=
	OpenCascadeShape[OpenCascadeTorus[{p1, p2}, r1, r2, 2 Pi, {0, 2 Pi}]]
 
OpenCascadeShape[OpenCascadeTorus[{p1_, p2_}, r1_, r2_, angle_]] :=
	OpenCascadeShape[OpenCascadeTorus[{p1, p2}, r1, r2, angle, {0, 2 Pi}]]

OpenCascadeShape[FilledTorus[]] :=
	OpenCascadeShape[OpenCascadeTorus[{{0, 0, 0}, {0, 0, 1}}, (1 + 1/2)/2, (1 - 1/2)/2]]

OpenCascadeShape[FilledTorus[p1_, r1_, r2_] ] := 
	OpenCascadeShape[FilledTorus[p1, {r1, r2}]]

OpenCascadeShape[FilledTorus[p1_, {r1_, r2_}]
	] /;
		VectorQ[p1, NumericQ] && (Length[ p1] == 3) &&
		NumericQ[r1] && NumericQ[r2] && (r1 < r2) :=
	OpenCascadeShape[OpenCascadeTorus[{p1, p1 + {0, 0, 1}}, (r2 + r1)/2, (r2 - r1)/2]]

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
	OpenCascadeShapeSolid[ OpenCascadeShapeUnion[ball1, cylinder, ball2]]
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
		bsss = OpenCascadeShapeSewing[bsurfs, "BuildSolid" -> True];
		(* for some reason the orientation is not right, as a band aid
			fix, we can have ShapeFix fix that. A better approach would be
			to take a occt shpere and deform that *)
		OpenCascadeShapeFix[bsss]
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
	sewenFaces = OpenCascadeShapeSewing[faces, "BuildSolid" -> True];

	sewenFaces
]


OpenCascadeShape[Parallelepiped[base_, {c1_, c2_}]] /;
		VectorQ[base, NumericQ] && (Length[ base] === 3) && 
		VectorQ[c1, NumericQ] && (Length[ c1] === 3) && 
		VectorQ[c2, NumericQ] && (Length[ c2] === 3) := 
Module[{polygon, shape, sweep},
	OpenCascadeShape[Polygon[{base, base + c1, base + c1 + c2, base + c2}]]
]

OpenCascadeShape[Parallelepiped[base_, {c1_, c2_, v_}]] /;
		VectorQ[base, NumericQ] && (Length[ base] === 3) && 
		VectorQ[c1, NumericQ] && (Length[ c1] === 3) && 
		VectorQ[c2, NumericQ] && (Length[ c2] === 3) && 
		VectorQ[v, NumericQ] && (Length[ v] === 3) :=
Module[{polygon, shape, sweep},
	polygon = Polygon[{base, base + c1, base + c1 + c2, base + c2}];
	shape = OpenCascadeShape[polygon];
	If[ !OpenCascadeShapeExpressionQ[ shape], Return[ $Failed, Module]];
	sweep = OpenCascadeShapeLinearSweep[shape, {base, base + v}];
	sweep
]


OpenCascadeShape[p_Polyhedron] :=
Module[{cp, op, ip, s1, s2, shape, pc, pi, ipp},
	cp = CanonicalizePolyhedron[p];
	op = OuterPolyhedron[cp];
	ip = InnerPolyhedron[cp];

	If[ Head[op] =!= Polyhedron, Return[$Failed, Module]];

	s1 = OpenCascadeShape[Polygon @@ op];
	s1 = OpenCascadeShapeSolid[s1];
	If[ !OpenCascadeShapeExpressionQ[ s1], Return[$Failed, Module]];

	Switch[ Head[ip],
		Polyhedron,
			If[ Length[ip] =!= 2, Return[$Failed, Module]];
			pc = ip[[1]];
			pi = ip[[2]];
			(* ip needs to be reversed *)
			ipp = Polyhedron[pc, Reverse /@ pi];
			s2 = OpenCascadeShape[Polygon @@ ipp];
			s2 = OpenCascadeShapeSolid[s2];
			If[ !OpenCascadeShapeExpressionQ[ s2], Return[$Failed, Module]];
			shape = OpenCascadeShapeDifference[s1, s2];
			shape = OpenCascadeShapeSolid[shape];
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
	sewenFaces = OpenCascadeShapeSewing[faces, "BuildSolid" -> True];

	sewenFaces
]


OpenCascadeShape[SphericalShell[c_, {r1_, r2_}]] /;
		VectorQ[c, NumericQ] && (Length[ c] == 3) &&
		NumericQ[r1] && NumericQ[r2] :=
Module[{balls},
	balls = OpenCascadeShape /@ {Ball[c, r2], Ball[c, r1]};
	OpenCascadeShapeSolid[ OpenCascadeShapeDifference @@ balls]
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
	sewenFaces = OpenCascadeShapeSewing[faces, "BuildSolid" -> True];

	sewenFaces
]

OpenCascadeShape[Rotate[g_, spec__]] :=
	OpenCascadeShape[TransformedRegion[g, RotationTransform[spec]]]

OpenCascadeShape[TransformedRegion[r_, tf:TransformationFunction[mat_]]] /;
	MatrixQ[mat, NumericQ] && (Dimensions[mat] == {4,4}) :=
Module[{shape},
		shape = OpenCascadeShape[r];

		If[ !OpenCascadeShapeExpressionQ[shape],
			Return[ $Failed, Module]
		];

		OpenCascadeShape[shape, tf]
]

(* this is here for backward compatiblity *)
OpenCascadeShape[shape_, tf:TransformationFunction[mat_]] /;
	OpenCascadeShapeExpressionQ[shape] &&
	MatrixQ[mat, NumericQ] && (Dimensions[mat] == {4,4}) :=
OpenCascadeShapeTransformation[shape, tf]

OpenCascadeShapeTransformation[shape_, tf:TransformationFunction[mat_]] /;
	OpenCascadeShapeExpressionQ[shape] &&
	MatrixQ[mat, NumericQ] && (Dimensions[mat] == {4,4}) :=
Module[{instance, tm, res},

	tm = pack[ N[ tf["TransformationMatrix"]]];

	(* OCCT can not deal with this at the moment *)
	If[ tm[[-1]] =!= {0.,0.,0.,1.}, Return[ $Failed, Module]];

	instance = OpenCascadeShapeCreate[];
	res = makeTransformationFun[ instanceID[ instance], instanceID[ shape], tm];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]


OpenCascadeShape[ ir:Inactive[RegionUnion|RegionIntersection|RegionDifference][data__]] :=
	OpenCascadeShapeInactiveRegion[ ir]

OpenCascadeShape[ br_BooleanRegion] /; Length[br] == 2 :=
	OpenCascadeShapeBooleanRegion[ br]

OpenCascadeShape[ cr_CSGRegion] /; Length[cr] == 2 :=
	OpenCascadeShapeCSGRegion[ cr]



(* Surface operations *)

OpenCascadeShapeSewing[oces:{e1_, e2__}, opts:OptionsPattern[OpenCascadeShapeSewing]] /;
	 And @@ (OpenCascadeShapeExpressionQ /@ oces) :=
Module[{p, instance, res, optParam, temp},

	ids = pack[ instanceID /@ oces];
	ids = DeleteDuplicates[ ids];

	optParam = 0;

	temp = OptionValue["BuildSolid"];
	If[ temp === True, optParam = BitSet[ optParam, 1]; ];

	instance = OpenCascadeShapeCreate[];
	res = makeSewingFun[ instanceID[ instance], ids, optParam];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]
OpenCascadeShapeSewing[{e1_}, opts:OptionsPattern[OpenCascadeShapeSewing]] /;
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
OpenCascadeShapeRotationalSweep[ shape_, {p1_, p2_}] /;
	OpenCascadeShapeExpressionQ[shape] :=
OpenCascadeShapeRotationalSweep[shape, {p1, p2}, 2 Pi]


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

OpenCascadeShapePathSweep::needwire = "`1` needs to be an OpenCascadeShapeType \"Wire\" or an \"Edge\", it is, however, a `2`."

OpenCascadeShapePathSweep[ shape_, path_, opts:OptionsPattern[]] /;
	OpenCascadeShapeExpressionQ[shape] &&
	OpenCascadeShapeExpressionQ[ path] :=
Module[
	{optParam, temp, instance, spine, id1, id2, res},


	optParam = 0;
	flagParam = 0;

	temp = OptionValue["ForceC1Continuity"];
	If[ !BooleanQ[temp], temp = False];
	If[ temp === True, flagParam = BitSet[ flagParam, 1]; ];

	spine = path;
	If[ OpenCascadeShapeType[path] === "Edge",
		spine = OpenCascadeShapeWire[path];
	];

	If[ OpenCascadeShapeType[spine] =!= "Wire",
		Message[OpenCascadeShapePathSweep::needwire, path, OpenCascadeShapeType[spine]];
		Return[$Failed, Module];
	];

	instance = OpenCascadeShapeCreate[];
	id1 = instanceID[ shape];
	id2 = instanceID[ spine];
	res = makePathSweepFun[ instanceID[ instance], id1, id2, optParam, flagParam];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]


OpenCascadeShapeLoft[oces:{e1_, e2__}, opts:OptionsPattern[OpenCascadeShapeLoft]] /;
	 And @@ (OpenCascadeShapeExpressionQ /@ oces) :=
Module[{p, instance, res, optParam, temp, types},

	ids = pack[ instanceID /@ oces];
	ids = DeleteDuplicates[ ids];

	optParam = 0;

	temp = OptionValue["BuildSolid"];
	types = Union[OpenCascadeShapeType /@ oces];
	If[ temp === Automatic,
		Switch[ types,
			{"Wire"}, temp = False,
			{"Face"}, temp = True,
			_, Return[$Failed, Module];
		];
	];
	If[ temp === True, optParam = BitSet[ optParam, 1]; ];

	temp = OptionValue["CheckCompatibility"];
	If[ temp === Automatic, temp = True;]
	If[ temp === True, optParam = BitSet[ optParam, 2]; ];

	instance = OpenCascadeShapeCreate[];
	res = makeLoftFun[ instanceID[ instance], ids, optParam];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]


(* surfaces in 3D *)

OpenCascadeShape[Polygon[coords_]] /;
		MatrixQ[coords, NumericQ] && MatchQ[ Dimensions[coords], {_, 3}] :=
Module[{p, instance, res, bmesh},

	p = pack[ N[ coords]];
	p = DeleteDuplicates[p];

	instance = OpenCascadeShapeCreate[];
	res = makePolygonFun[ instanceID[ instance], p];
	If[ res =!= 0,
		(* could be a non-coplanar surface *)
		If[ !TrueQ[ CoplanarPoints[ p]],
			bmesh = Quiet[ NDSolve`FEM`ToBoundaryMesh[
				DiscretizeGraphics[Polygon[p]]]];
			If[ NDSolve`FEM`BoundaryElementMeshQ[bmesh],
				Return[ OpenCascadeShape[ bmesh], Module];
			];
		];

		Return[$Failed, Module];
	];

	instance
]

OpenCascadeShape[Polygon[coords_]] /;
		MatchQ[ Dimensions[coords], {_, _, 3}] :=
Module[{faces, face},

	faces = OpenCascadeShape /@ (Polygon /@ coords);
	If[ !AllTrue[faces, OpenCascadeShapeExpressionQ],
		Return[$Failed, Module];
	];

	face = OpenCascadeShapeUnion[ faces];
	If[ !OpenCascadeShapeExpressionQ[ face],
		Return[$Failed, Module];
	];

	face
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

OpenCascadeShape[Polygon[Rule[ coords_, {}]]] /;
	MatrixQ[coords, NumericQ] && MatchQ[ Dimensions[coords], {_, 3}] :=
OpenCascadeShape[Polygon[coords]]

pholeQ[h_]:= MatrixQ[h, NumericQ] && MatchQ[ Dimensions[h], {_, 3}];

OpenCascadeShape[Polygon[Rule[ coords_, holesCoords:{h1__?pholeQ}]]] /;
	MatrixQ[coords, NumericQ] && MatchQ[ Dimensions[coords], {_, 3}] := 
Module[{basePolygon, result},

	basePolygon = OpenCascadeShape[Polygon[ coords]];
	holes = OpenCascadeShape[Polygon[#]]& /@ holesCoords;

	result = OpenCascadeShapeDifference[Flatten[{basePolygon, holes}]];

	If[ !OpenCascadeShapeExpressionQ[ result],
		result = $Failed;
	];

	result
]


OpenCascadeShape[Triangle[coords_]] /;
		MatrixQ[coords, NumericQ] && MatchQ[ Dimensions[coords], {3, 3}] :=
OpenCascadeShape[Polygon[coords]]

OpenCascadeShape[Triangle[coords_]] /;
		ArrayQ[coords, 3, NumericQ] && MatchQ[ Dimensions[coords], {_, 3, 3}] :=
OpenCascadeShape[Polygon[coords]]


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

clamped[degree_, n_] :=
Module[{t = 1},
	Join[
		Table[0, {degree + 1}],
		Table[t++, {n - 1 - degree}],
		Table[t, {degree + 1}]
	]
]

unclamped[degree_, n_] :=
Module[{t = -degree},
	Table[t++, {n + degree + 1}]
]

computeKnots[ knots_, degree_, n_] :=
Module[{newKnots},

	newKnots = knots;

	If[ !ListQ[ knots],
        Switch[ knots,
            "Clamped" | Automatic,
			newKnots = clamped[degree, n];
		, 
            "Unclamped", 
			newKnots = unclamped[degree, n];
        ];
	];

	pack[N[newKnots]]
]

OpenCascadeShape[bss:BSplineSurface[pts_, OptionsPattern[]]] /;
	Length[ Dimensions[ pts]] === 3 :=
Module[
	{k, w, d, c, bsf},

	{k, w, d, c} = OptionValue[BSplineSurface,
		{SplineKnots, SplineWeights, SplineDegree, SplineClosed}];

	bsf = BSplineFunction[pts,
		SplineClosed -> c,
		SplineDegree -> d,
		SplineWeights -> w,
		SplineKnots -> k
	];

	OpenCascadeShape[bsf]
]

OpenCascadeShape[bsf_BSplineFunction] /;
	Length[ Dimensions[ bsf["ControlPoints"]]] === 3 && bsf["Rank"] === 2 :=
Module[
	{pts, poles, weights, uknots, vknots, umults, vmults, udegree, vdegree, 
	uperiodic, vperiodic, uclosed, vclosed, instance, res, temp, nrows, ncols,
	knots, degree, closed},

	pts = bsf["ControlPoints"];

	knots = bsf["Knots"];
	weights = bsf["Weights"];
	degree = bsf["Degree"];
	closed = bsf["Closed"];

	closed = closed /. Automatic -> False;
	{uclosed, vclosed} = Flatten[{closed, closed}][[{1,2}]];
	If[ !VectorQ[ Boole[ {uclosed, vclosed}], IntegerQ],
		Return[ $Failed, Module];
	];

	(* a closed BSpline is not the same as periodic BSpline *)
	(* more needs to be implemented for the u/v-periodic case *)
	{uperiodic, vperiodic} = {False, False};

	degree = degree /. Automatic -> 3;
	degree = Flatten[{degree, degree}][[{1,2}]];
	If[ !VectorQ[ degree, (Positive[#] && IntegerQ[#]) &],
		Return[ $Failed, Module]
	];
	{udegree, vdegree} = degree;

	poles = pack[ N[ pts]];

	If[ Length[ knots] === 1 || knots === Automatic, knots = {knots, knots};];
	{uknots, vknots} = knots;

	If[ uclosed == True,
		poles = Join[poles, poles[[1 ;; udegree]], 1];
		If[ uknots == Automatic,
			uknots = "Unclamped";
		];
	];

	If[ vclosed == True,
		poles = Join[poles, poles[[All, 1 ;; vdegree]], 2];
		If[ vknots == Automatic,
			vknots = "Unclamped";
		];
	];

	{nrows, ncols} = Dimensions[poles][[{1,2}]];

	If[ weights === Automatic,
		weights = ConstantArray[1., {nrows, ncols}];
	,
		weights = pack[ N[ weights]];
	];

	uknots = computeKnots[uknots, udegree, nrows];
	vknots = computeKnots[vknots, vdegree, ncols];
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

	If[ uperiodic === True,
		If[ umults[[-1]] != umults[[1]], Return[ $Failed, Module]];
		If[ Total[ umults[[1;;-2]]] =!= nrows, Return[ $Failed, Module]];
	,
		(* NON periodic surface *)
		If[ (Total[umults] - udegree -1) =!= nrows, Return[ $Failed, Module]];
	];

	If[ vperiodic == True,
		If[ vmults[[-1]] != vmults[[1]], Return[ $Failed, Module]];
		If[ Total[ vmults[[1;;-2]]] =!= ncols, Return[ $Failed, Module]];
	,
		(* NON periodic surface *)
		If[ (Total[vmults] - vdegree -1) =!= ncols, Return[ $Failed, Module]];
	];


	instance = OpenCascadeShapeCreate[];
	res = makeBSplineSurfaceFun[ instanceID[ instance], poles, weights,
		uknots, vknots, umults, vmults, udegree, vdegree,
		Boole[uperiodic], Boole[vperiodic]];
	If[ res =!= 0, Return[ $Failed, Module]];

	instance
]


OpenCascadeShape[BSplineCurve[pts_, OptionsPattern[]]] /;
	Length[ Dimensions[ pts]] === 2 :=
Module[
	{k, w, d, c, bsf, cpts, poles, weights, knots, mults, degree, periodic,
	closed, instance, res, npoles},

	{k, w, d, c} = OptionValue[BSplineCurve,
		{SplineKnots, SplineWeights, SplineDegree, SplineClosed}];

	bsf = BSplineFunction[pts,
		SplineClosed -> c,
		SplineDegree -> d,
		SplineWeights -> w,
		SplineKnots -> k
	];
	cpts = bsf["ControlPoints"];

	knots = bsf["Knots"];
	weights = bsf["Weights"];
	degree = bsf["Degree"];
	closed = bsf["Closed"];

	closed = closed /. Automatic -> False;
	closed = Flatten[{closed}][[1]];
	If[ !BooleanQ[closed],
		Return[ $Failed, Module];
	];

	(* a closed BSpline is not the same as periodic BSpline *)
	(* more needs to be implemented for the u/v-periodic case *)
	periodic = False;

	degree = degree /. Automatic -> 3;
	degree = Flatten[{degree}][[1]];
	If[ !Positive[degree] || !IntegerQ[degree],
		Return[ $Failed, Module]
	];

	poles = pack[ N[ cpts]];

	If[ closed == True,
		poles = Join[poles, poles[[1 ;; degree]], 1];
		If[ knots == Automatic,
			knots = "Unclamped";
		];
	];

	npoles = Length[poles];

	If[ weights === Automatic,
		weights = ConstantArray[1., {npoles}];
	,
		weights = pack[ N[ weights]];
	];

	knots = computeKnots[knots, degree, npoles];
	knots = Flatten[{knots}];
	(* TODO: check (?) WL requitement: u_i >= u_i+1 *)

	{knots, mults} = pack /@ Transpose[Tally[knots]];
	(* u_i > u_i+1: This is an OpenCascde requirement *)
	If[ !strictIncreaseQ[ knots],
		Return[ $Failed, Module];
	];

	If[ (Length[ mults] != Length[ knots]) || Length[ knots] < 2,
		Return[ $Failed, Module];
	]; 

	If[ periodic === True,
		If[ mults[[-1]] != mults[[1]], Return[ $Failed, Module]];
		If[ Total[ mults[[1;;-2]]] =!= npoles, Return[ $Failed, Module]];
	,
		(* NON periodic surface *)
		If[ (Total[mults] - degree -1) =!= npoles, Return[ $Failed, Module]];
	];

	instance = OpenCascadeShapeCreate[];
	res = makeBSplineCurveFun[ instanceID[ instance], poles, weights,
		knots, mults, degree, Boole[periodic]];
	If[ res =!= 0, Return[ $Failed, Module]];

	instance
]

OpenCascadeShape[bc:BezierCurve[pts_, opts:OptionsPattern[]]] /;
	MatrixQ[pts, NumericQ] && MatchQ[ Dimensions[pts], {_, 3}] :=
Module[
	{bf},

	bf = BezierFunction[pts, opts];
	(* bf["Properties"] *)

	OpenCascadeShape[bf]
]

OpenCascadeShape[bf_BezierFunction] /;
	MatrixQ[bf["ControlPoints"], NumericQ] &&
	MatchQ[ Dimensions[bf["ControlPoints"]], {_, 3}] :=
Module[
	{pts},

	pts = bf["ControlPoints"];
	pts = pack[N[pts]];

	instance = OpenCascadeShapeCreate[];

	res = makeBezierCurveFun[ instanceID[ instance], pts];
	If[ res =!= 0, Return[ $Failed, Module]];

	instance
]


OpenCascadeShape[mesh_] /;
	!NDSolve`FEM`BoundaryElementMeshQ[ mesh] && NDSolve`FEM`ElementMeshQ[mesh] &&
		(mesh["EmbeddingDimension"] === 3) :=
OpenCascadeShapeInternal[ NDSolve`FEM`ToBoundaryMesh[ mesh], True]

OpenCascadeShape[bmesh_] /;
	NDSolve`FEM`BoundaryElementMeshQ[ bmesh] &&
	(bmesh["EmbeddingDimension"] === 3) :=
Module[{closedQ = False, mesh},

	(* this is an expensive test to see if we have a closed surface
		and can return a solid or a shell in case the surface is not 
		closed *)
	mesh = Quiet[ NDSolve`FEM`ToElementMesh[ bmesh, "MeshOrder" -> 1,
		"MaxCellMeasure" -> Infinity]];
	If[ NDSolve`FEM`ElementMeshQ[mesh],
		closedQ = True
	];

	OpenCascadeShapeInternal[ bmesh, closedQ]
]

OpenCascadeShapeInternal[bmeshIn_, closedQ_] /;
	NDSolve`FEM`BoundaryElementMeshQ[ bmeshIn] :=
Module[{bmesh, coords, faces, polygons, faceCoords, shape, numPoly},
	bmesh = NDSolve`FEM`MeshOrderAlteration[bmeshIn, 1];

	coords = bmesh["Coordinates"];
	faces = NDSolve`FEM`ElementIncidents[bmesh["BoundaryElements"]];
	polygons = {};
	Do[
		(* OpenCascade uses reverse ordering *)
		faceCoords = NDSolve`FEM`GetElementCoordinates[coords, f];
		Do[
			polygons = {polygons, OpenCascadeShape[Polygon[p]]};
		, {p, faceCoords}
		];
	, {f, faces}
	];
	polygons = Flatten[polygons];
	numPoly = Length[polygons];
	polygons = Select[polygons, OpenCascadeShapeExpressionQ];
	shape = OpenCascadeShapeSewing[polygons];
	(* if there was a problem, maybe we can repair it *)
	If[ numPoly =!= Length[polygons],
		shape = OpenCascadeShapeFix[shape];
	];

	If[ TrueQ[ closedQ],
		shape = OpenCascadeShapeSolid[shape];
	];

	(* fix possible orientation issues *)
	OpenCascadeShapeFix[shape]
]


OpenCascadeShape[OpenCascadeDisk[axis:{center_, normal_}]] := 
	OpenCascadeShapeFace[OpenCascadeShape[OpenCascadeCircle[axis, 1, {0, 2 Pi}]]]

OpenCascadeShape[OpenCascadeDisk[axis:{center_, normal_}, r_]] := 
	OpenCascadeShapeFace[OpenCascadeShape[OpenCascadeCircle[axis, r, {0, 2 Pi}]]]

OpenCascadeShape[OpenCascadeDisk[axis:{center_, normal_}, radius_, a:{angle1_, angle2_}]] /;
		Dimensions[axis] === {2, 3} && MatrixQ[axis, NumericQ] &&
		NumericQ[radius] && radius > 0 && 
		NumericQ[angle1] && NumericQ[angle2] && (Abs[angle1 - angle2] == 2 Pi) :=
	OpenCascadeShapeFace[OpenCascadeShape[OpenCascadeCircle[axis, radius, a]]]

OpenCascadeShape[OpenCascadeDisk[axis:{center_, normal_}, radius_, a:{angle1_, angle2_}]] /;
		Dimensions[axis] === {2, 3} && MatrixQ[axis, NumericQ] &&
		NumericQ[radius] && radius > 0 && 
		(* we need a line, a circle and a third line for the < 2 Pi case 
		but for the == 2 Pi case we only need a circle *)
		NumericQ[angle1] && NumericQ[angle2] && (0 < Abs[angle1 - angle2] < 2 Pi) :=
Module[{r, a1, a2, l1, c, l2},

	r = N[radius];
	a1 = N[angle1];
	a2 = N[angle2];

	l1 = OpenCascadeShape[Line[{center, {r Cos[a1], r Sin[a1], 0} + center}]];
	c = OpenCascadeShape[OpenCascadeCircle[axis, r, a]];
	l2 = OpenCascadeShape[Line[{{r Cos[a2], r Sin[a2], 0} + center, center}]];

	OpenCascadeShapeFace[{l1, c, l2}]
]

(* wires in 3D *)

OpenCascadeShape[OpenCascadeCircle[axis:{center_, normal_}, radius_, pp:{p1_, p2_}]] /;
		Dimensions[axis] === {2, 3} && MatrixQ[axis, NumericQ] &&
		NumericQ[radius] && radius > 0 &&
		Dimensions[pp] === {2, 3} && MatrixQ[pp, NumericQ] := 
Module[{p, instance, res, r, a1, a2, tp, startStopCoord},

	tp = pack[ N[pp]];

	p = pack[ N[ axis]];
	r = N[radius];

	a1 = N[0];
	a2 = N[0];

	instance = OpenCascadeShapeCreate[];
	(* the 1 is to make use of the coordinates and not the angles *)
	res = makeCircleFun[ instanceID[ instance], p, r, 1, a1, a2, tp];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]

OpenCascadeShape[OpenCascadeCircle[axis:{center_, normal_}, radius_, a:{angle1_, angle2_}]] /;
		Dimensions[axis] === {2, 3} && MatrixQ[axis, NumericQ] &&
		NumericQ[radius] && radius > 0 && 
		NumericQ[angle1] && NumericQ[angle2] && (0 < Abs[(angle1 - angle2)] <= 2 Pi) :=
Module[{p, instance, res, r, a1, a2, tp, startStopCoord},

	(* giving angles diretly does not work for some reason,
		so we compute the start and end points and project to 3D *)
	startStopCoord = (radius*{Cos[#], Sin[#], 0} + center) & /@ a;
	tp = RotationTransform[{{0, 0, 1}, normal}, center] /@ startStopCoord;
	tp = pack[ N[tp]];

	p = pack[ N[ axis]];
	r = N[radius];

	a1 = N[angle1];
	a2 = N[angle2];

	instance = OpenCascadeShapeCreate[];
	(* the 1 is to make use of the coordinates and not the angles *)
	res = makeCircleFun[ instanceID[ instance], p, r, 1, a1, a2, tp];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]

OpenCascadeShape[OpenCascadeCircle[axis:{center_, normal_}]] := 
	OpenCascadeShape[OpenCascadeCircle[axis, 1, {0, 2 Pi}]]

OpenCascadeShape[OpenCascadeCircle[axis:{center_, normal_}, r_]] := 
	OpenCascadeShape[OpenCascadeCircle[axis, r, {0, 2 Pi}]]


OpenCascadeShape[Line[coords_]] /;
		MatrixQ[coords, NumericQ] && MatchQ[ Dimensions[coords], {_, 3}] :=
Module[{p, instance, res},

	p = pack[ N[ coords]];

	instance = OpenCascadeShapeCreate[];
	res = makeLineFun[ instanceID[ instance], p];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]

OpenCascadeShape[Line[coords_]] /;
		MatchQ[ Dimensions[coords], {_, _, 3}] :=
Module[{wires, wire},

	wires = OpenCascadeShape /@ (Line /@ coords);
	If[ !AllTrue[wires, OpenCascadeShapeExpressionQ],
		Return[$Failed, Module];
	];

	wire = OpenCascadeShapeUnion[ wires];
	If[ !OpenCascadeShapeExpressionQ[ wire],
		Return[$Failed, Module];
	];

	wire
]


OpenCascadeShapeCompound[oces:{e__}] /;
	 And @@ (OpenCascadeShapeExpressionQ /@ oces) :=
Module[{p, instance, res},

	ids = pack[ instanceID /@ oces];
	ids = DeleteDuplicates[ ids];

	instance = OpenCascadeShapeCreate[];
	res = makeCompoundFun[ instanceID[ instance], ids];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]

OpenCascadeShapeCompSolid[oces:{e__}] /;
	 And @@ (OpenCascadeShapeExpressionQ /@ oces) :=
Module[{p, instance, res},

	ids = pack[ instanceID /@ oces];
	ids = DeleteDuplicates[ ids];
	iids = Select[ids, OpenCascadeShapeType[#] == "Solid" &];

	instance = OpenCascadeShapeCreate[];
	res = makeCompSolidFun[ instanceID[ instance], ids];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]

OpenCascadeShapeSolid[oces:{e__}] /;
	 And @@ (OpenCascadeShapeExpressionQ /@ oces) :=
Module[{p, instance, res},

	ids = pack[ instanceID /@ oces];
	ids = DeleteDuplicates[ ids];

	instance = OpenCascadeShapeCreate[];
	res = makeSolidFun[ instanceID[ instance], ids];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]

OpenCascadeShapeSolid[e__] /;
	 And @@ (OpenCascadeShapeExpressionQ /@ {e}) :=
OpenCascadeShapeSolid[{e}]

OpenCascadeShapeShell[oces:{e__}] /;
	 And @@ (OpenCascadeShapeExpressionQ /@ oces) :=
Module[{p, instance, res},

	ids = pack[ instanceID /@ oces];
	ids = DeleteDuplicates[ ids];
	iids = Select[ids, OpenCascadeShapeType[#] == "Face" &];

	instance = OpenCascadeShapeCreate[];
	res = makeShellFun[ instanceID[ instance], ids];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]


OpenCascadeShapeFace[oces:{e__}] /;
	 And @@ (OpenCascadeShapeExpressionQ /@ oces) :=
Module[{p, instance, res},

	ids = pack[ instanceID /@ oces];
	ids = DeleteDuplicates[ ids];

	instance = OpenCascadeShapeCreate[];
	res = makeFaceFun[ instanceID[ instance], ids];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]

OpenCascadeShapeFace[e__] /;
	 And @@ (OpenCascadeShapeExpressionQ /@ {e}) :=
OpenCascadeShapeFace[{e}]


OpenCascadeShapeWire[oces:{e__}] /;
	 And @@ (OpenCascadeShapeExpressionQ /@ oces) :=
Module[{p, instance, res},

	ids = pack[ instanceID /@ oces];
	ids = DeleteDuplicates[ ids];

	instance = OpenCascadeShapeCreate[];
	res = makeWireFun[ instanceID[ instance], ids];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]

OpenCascadeShapeWire[e__] /;
	 And @@ (OpenCascadeShapeExpressionQ /@ {e}) :=
OpenCascadeShapeWire[{e}]

(*
	open cascade Boolean operation
*)

OpenCascadeShapeDifference[ shape1_, OptionsPattern[OpenCascadeShapeDifference]] /; 
	OpenCascadeShapeExpressionQ[shape1] := shape1

OpenCascadeShapeDifference[ shape1_, shape2_, opts:OptionsPattern[OpenCascadeShapeDifference]] /;
And[
	OpenCascadeShapeExpressionQ[shape1],
	OpenCascadeShapeExpressionQ[shape2]
] := Module[
	{optParam, temp, instance, id1, id2, res, origin, radius},

	optParam = 0;

	temp = OptionValue["SimplifyResult"];
	If[ temp === True, optParam = BitSet[ optParam, 1]; ];

	instance = OpenCascadeShapeCreate[];
	id1 = instanceID[ shape1];
	id2 = instanceID[ shape2];
	res = makeDifferenceFun[ instanceID[ instance], id1, id2, optParam];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]

OpenCascadeShapeDifference[eN__, opts:OptionsPattern[OpenCascadeShapeDifference]] /;
	And @@ (OpenCascadeShapeExpressionQ /@ {eN}) === True :=
Fold[OpenCascadeShapeDifference[##, opts]&, {eN}]

OpenCascadeShapeDifference[{eN__}, opts:OptionsPattern[OpenCascadeShapeDifference]] /;
	And @@ (OpenCascadeShapeExpressionQ /@ {eN}) === True :=
OpenCascadeShapeDifference[eN, opts];


OpenCascadeShapeIntersection[ shape1_, OptionsPattern[OpenCascadeShapeIntersection]] /; 
	OpenCascadeShapeExpressionQ[shape1] := shape1

OpenCascadeShapeIntersection[ shape1_, shape2_, opts:OptionsPattern[OpenCascadeShapeIntersection]] /;
And[
	OpenCascadeShapeExpressionQ[shape1],
	OpenCascadeShapeExpressionQ[shape2]
] := Module[
	{optParam, temp, instance, id1, id2, res, origin, radius},

	optParam = 0;

	temp = OptionValue["SimplifyResult"];
	If[ temp === True, optParam = BitSet[ optParam, 1]; ];

	instance = OpenCascadeShapeCreate[];
	id1 = instanceID[ shape1];
	id2 = instanceID[ shape2];
	res = makeIntersectionFun[ instanceID[ instance], id1, id2, optParam];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]

OpenCascadeShapeIntersection[eN__, opts:OptionsPattern[OpenCascadeShapeIntersection]] /;
	And @@ (OpenCascadeShapeExpressionQ /@ {eN}) === True :=
Fold[OpenCascadeShapeIntersection[##, opts]&, {eN}]

OpenCascadeShapeIntersection[{eN__}, opts:OptionsPattern[OpenCascadeShapeIntersection]] /;
	And @@ (OpenCascadeShapeExpressionQ /@ {eN}) === True :=
OpenCascadeShapeIntersection[eN, opts]


OpenCascadeShapeUnion[ shape1_, OptionsPattern[OpenCascadeShapeUnion]] /; 
	OpenCascadeShapeExpressionQ[shape1] := shape1

OpenCascadeShapeUnion[shape1_, shape2_, opts:OptionsPattern[OpenCascadeShapeUnion]] /;
And[ 
	OpenCascadeShapeExpressionQ[shape1],
	OpenCascadeShapeExpressionQ[shape2]
] := Module[
	{optParam, temp, instance, id1, id2, res, origin, radius},

	optParam = 0;

	temp = OptionValue["SimplifyResult"];
	If[ temp === True, optParam = BitSet[ optParam, 1]; ];

	instance = OpenCascadeShapeCreate[];
	id1 = instanceID[ shape1];
	id2 = instanceID[ shape2];
	res = makeUnionFun[ instanceID[ instance], id1, id2, optParam];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
]

OpenCascadeShapeUnion[eN__, opts:OptionsPattern[OpenCascadeShapeUnion]] /;
	And @@ (OpenCascadeShapeExpressionQ /@ {eN}) === True :=
Fold[OpenCascadeShapeUnion[##, opts]&, {eN}]

OpenCascadeShapeUnion[{eN__}, opts:OptionsPattern[OpenCascadeShapeUnion]] /;
	And @@ (OpenCascadeShapeExpressionQ /@ {eN}) === True :=
OpenCascadeShapeUnion[eN, opts]


OpenCascadeShape::badconv = "The expression `1` could not be converted to OpenCascade."

OpenCascadeShapeInactiveRegion[ ir:Inactive[RegionUnion|RegionDifference|RegionIntersection][data__],
	opts:OptionsPattern[OpenCascadeShapeInactiveRegion]] :=
Module[
	{booleanOpName, booleanOp, operands, shapes, allGood},

	booleanOpName = ir[[0, 1]];
	booleanOp = getOCBooleanOp[booleanOpName];
	operands = Flatten[{data}];

	shapes = OpenCascadeShape /@ operands;

	allGood = OpenCascadeShapeExpressionQ /@ shapes;
	If[ Union[ allGood] =!= {True},
		Message[OpenCascadeShape::badconv,
			Select[shapes, Not[OpenCascadeShapeExpressionQ[#]]& ]];
		Return[$Failed, Module];
	];

	booleanOp[shapes, opts]
]

OpenCascadeShapeBooleanRegion[ br_BooleanRegion,
	opts:OptionsPattern[OpenCascadeShapeBooleanRegion]] /; Length[br] == 2 :=
Module[
	{booleanFunction, regions},

	booleanFunction = br[[1]] //. {
		Or :> (OpenCascadeShapeUnion[##, opts]&),
		And[s1_, Not[s2_]] :> OpenCascadeShapeDifference[s1, s2, opts],
		And[Not[s2_], s1_] :> OpenCascadeShapeDifference[s1, s2, opts],
		And :> (OpenCascadeShapeIntersection[##, opts]&),
		Xor[s1_, sn__] :> ((OpenCascadeShapeUnion[##, opts]&) @@
			(OpenCascadeShapeDifference[##, opts]& @@ Tuples[{s1, sn}, 2]))
	};

	regions = OpenCascadeShape /@ br[[2]];
	(* TODO: check that all regions valid *)

	booleanFunction @@ regions
]


getOCBooleanOp[RegionUnion] := OpenCascadeShapeUnion
getOCBooleanOp[RegionDifference] := OpenCascadeShapeDifference
getOCBooleanOp[RegionIntersection] := OpenCascadeShapeIntersection

getOCBooleanOp["Union"] := OpenCascadeShapeUnion
getOCBooleanOp["Difference"] := OpenCascadeShapeDifference
getOCBooleanOp["Intersection"] := OpenCascadeShapeIntersection

OpenCascadeShapeCSGRegion[ cr_CSGRegion,
	opts:OptionsPattern[OpenCascadeShapeCSGRegion]] /; Length[cr] == 2 :=
Module[
	{booleanOpName, booleanOp, operands, shapes, allGood},

	booleanOpName = cr[[1]];
	booleanOp = getOCBooleanOp[booleanOpName];
	operands = cr[[2]];

	shapes = OpenCascadeShape /@ operands;

	allGood = OpenCascadeShapeExpressionQ /@ shapes;
	If[ Union[ allGood] =!= {True},
		Message[OpenCascadeShape::badconv,
			Select[shapes, Not[OpenCascadeShapeExpressionQ[#]]& ]];
		Return[$Failed, Module];
	];

	booleanOp[shapes, opts]
]

OpenCascadeShapeSplit::stype = "To split shapes,the list of shapes must be of the same type and also the list of tools must of the same type. In this case the `1` had types `2`."
OpenCascadeShapeSplit::ttype = "If the shapes to be split are of type `1` then the tools must not be of type `2`."
OpenCascadeShapeSplit::badtype = "OpenCascadeShapeSplit is currently not implemented for shape types `1`."

getIntShapeType["Solid"] := 0
getIntShapeType["Face"] := 1
getIntShapeType["Wire"] := 2
getIntShapeType["Vertex"] := 3

OpenCascadeShapeSplit[shapes_, toolsIn_] /;
		VectorQ[shapes, OpenCascadeShapeExpressionQ] &&
		VectorQ[toolsIn, OpenCascadeShapeExpressionQ] :=
Module[
	{tools, optsParam, instance, shapeTypes1, shapeTypes2, ids1, ids2, st1, st2},

	tools = toolsIn;

	(* is not implemented because I don't have a case where setting
		the destruction of input shapes would be useful. See C code.  *)
	optsParam = 0;

	instance = OpenCascadeShapeCreate[];

	shapeTypes1 = Union[ OpenCascadeShapeType /@ shapes];
	shapeTypes2 = Union[ OpenCascadeShapeType /@ tools];

	If[ Length[shapeTypes1] =!= 1,
		Message[OpenCascadeShapeSplit::stype, "shapes", shapeTypes1];
		Return[$Failed, Module]l
	];

	If[ Length[shapeTypes2] =!= 1,
		Message[OpenCascadeShapeSplit::stype, "tools", shapeTypes2];
		Return[$Failed, Module]l
	];

	shapeTypes1 = shapeTypes1[[1]];
	shapeTypes2 = shapeTypes2[[1]];

	(* for conveniance *)
	If[ shapeTypes2 === "Edge",
		tools = OpenCascadeShapeWire /@ tools;
		shapeTypes2 = "Wire";
	];

	If[shapeTypes1 === "Solid" && !(shapeTypes2 === "Solid" || shapeTypes2 === "Face"),
		Message[OpenCascadeShapeSplit::ttype, shapeTypes1, shapeTypes2];
		Return[$Failed, Module];
	];

	If[shapeTypes1 === "Face" && !(shapeTypes2 === "Face" || shapeTypes2 === "Wire"),
		Message[OpenCascadeShapeSplit::ttype, shapeTypes1, shapeTypes2];
		Return[$Failed, Module];
	];
(* OpenCascadeShape[Point[{0,0,0}]] is missing *)
(*
	If[shapeTypes1 === "Wire" && (shapeTypes2 =!= "Wire" || shapeTypes2 =!= "Vertex"),
		Message[OpenCascadeShapeSplit::ttype, shapeTypes1, shapeTypes2];
		Return[$Failed, Module];
	];
*)
(*	If[ shapeTypes1 =!= "Solid" && shapeTypes1 =!= "Face" && shapeTypes1 =!= "Wire", *)
	If[ shapeTypes1 =!= "Solid" && shapeTypes1 =!= "Face",
		Message[OpenCascadeShapeSplit::badtype, shapeType1];
		Return[$Failed, Module];
	];

	st1 = getIntShapeType[shapeTypes1];
	st2 = getIntShapeType[shapeTypes2];

	ids1 = pack[ instanceID /@ shapes];
	ids1 = DeleteDuplicates[ ids1];

	ids2 = pack[ instanceID /@ tools];
	ids2 = DeleteDuplicates[ ids2];

	res = makeSplitFun[ instanceID[ instance], ids1, ids2, st1, st2, optsParam];
	If[ res =!= 0, Return[$Failed, Module]];

	If[ OpenCascadeShapeNumberOfSolids[instance] > 1,
		Return[ OpenCascadeShapeSolids[instance], Module]
	];

	If[ OpenCascadeShapeNumberOfFaces[instance] > 1,
		Return[ OpenCascadeShapeFaces[instance], Module]
	];

	If[ OpenCascadeShapeNumberOfWires[instance] > 1,
		Return[ OpenCascadeShapeWires[instance], Module]
	];

	{instance}
] 

OpenCascadeShapeSplit[shape_, tool_] /;
		OpenCascadeShapeExpressionQ[shape] &&
		OpenCascadeShapeExpressionQ[tool] :=
OpenCascadeShapeSplit[{shape}, {tool}]


OpenCascadeShapeDefeaturing[shape_, faceIDs_] /; 
		OpenCascadeShapeExpressionQ[shape] &&
		VectorQ[faceIDs, NumericQ] :=
Module[
	{instance, numFaces, id1, res, t, fIDs = faceIDs},

	numFaces = OpenCascadeShapeNumberOfFaces[ shape];

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

OpenCascadeShapeSimplify[shape_,
	opts:OptionsPattern[OpenCascadeShapeSimplify]] /; 
OpenCascadeShapeExpressionQ[shape] :=
Module[
	{optParam, temp, linPrec, angPrec, eIDs, vIDs, numEdges, numVertices,
	 instance, id1, res},

	linPrec = N[ OptionValue["LinearTolerance"]];
	If[ !NumericQ[ linPrec] || linPrec <= 0.,
		linPrec = 0.;
	];

	angPrec = N[ OptionValue["AngularTolerance"]];
	If[ !NumericQ[ angPrec] || angPrec <= 0.,
		angPrec = 0.;
	];

	optParam = 0;

	temp = OptionValue["SimplifyFaces"];
	If[ !BooleanQ[temp], temp = True];
	If[ temp === True, optParam = BitSet[ optParam, 1]; ];

	temp = OptionValue["SimplifyEdges"];
	If[ !BooleanQ[temp], temp = True];
	If[ temp === True, optParam = BitSet[ optParam, 2]; ];

	temp = OptionValue["SimplifyBSplineEdges"];
	If[ !BooleanQ[temp], temp = False];
	If[ temp === True, optParam = BitSet[ optParam, 3]; ];

	temp = OptionValue["AllowInternalEdges"];
	If[ !BooleanQ[temp], temp = False];
	If[ temp === True, optParam = BitSet[ optParam, 4]; ];

	eIDs = OptionValue["KeepEdges"];
	If[ VectorQ[eIDs, IntegerQ] && Length[eIDs] > 0,
		numEdges = getShapeNumberOfEdgesFun[ instanceID[ shape]];
		eIDs = Sort[ pack[ eIDs]];
		If[ Max[ eIDs] > numEdges, Return[ shape, Module]; ];

		optParam = BitSet[ optParam, 5];
	,
		(* set up a dummy packed array *)
		eIDs = pack[{0}];
	];

	vIDs = OptionValue["KeepVertices"];
	If[ VectorQ[vIDs, IntegerQ] && Length[vIDs] > 0,
		numVertices = getShapeNumberOfVerticesFun[ instanceID[ shape]];
		vIDs = Sort[ pack[ vIDs]];
		If[ Max[ vIDs] > numVertices, Return[ shape, Module]; ];

		optParam = BitSet[ optParam, 6];
	,
		(* give a dummpy packed array *)
		vIDs = pack[{0}];
	];

	instance = OpenCascadeShapeCreate[];
	id1 = instanceID[ shape];
	(* - 1 since C uses 0 index start *)
	res = makeSimplifyFun[ instanceID[ instance], id1, eIDs - 1, vIDs - 1,
		optParam, linPrec, angPrec];

	If[ res =!= 0, Return[$Failed, Module]];

	instance
]

(* TODO: set precision *)
(* https://dev.opencascade.org/comment/24206#comment-24206 *)
OpenCascadeShapeFix[shape_] /; 
	OpenCascadeShapeExpressionQ[shape] :=
Module[
	{instance, id1, res},

	instance = OpenCascadeShapeCreate[];
	id1 = instanceID[ shape];
	res = makeShapeFixFun[ instanceID[ instance], id1];

	If[ res =!= 0, Return[$Failed, Module]];

	instance
]


OpenCascadeShapeType[shape_] /; OpenCascadeShapeExpressionQ[shape] :=
Module[{type},
	type = getShapeTypeFun[ instanceID[ shape]];

	(* These come from the TopAbs_ShapeEnum *)

	Switch[ type,
		0, "Compound",
		1, "CompSolid",
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

OpenCascadeShapeNumberOfSolids[shape_] /; OpenCascadeShapeExpressionQ[shape] :=
Module[{res},
	res = getShapeNumberOfSolidsFun[ instanceID[ shape]];
	If[ IntegerQ[res], res, 0]
]

OpenCascadeShapeNumberOfFaces[shape_] /; OpenCascadeShapeExpressionQ[shape] :=
Module[{res},
	res = getShapeNumberOfFacesFun[ instanceID[ shape]];
	If[ IntegerQ[res], res, 0]
]


OpenCascadeShapeNumberOfEdges[shape_] /; OpenCascadeShapeExpressionQ[shape] :=
Module[{res},
	res = getShapeNumberOfEdgesFun[ instanceID[ shape]];
	If[ IntegerQ[res], res, 0]
]

OpenCascadeShapeNumberOfVertices[shape_] /; OpenCascadeShapeExpressionQ[shape] :=
Module[{res},
	res = getShapeNumberOfVerticesFun[ instanceID[ shape]];
	If[ IntegerQ[res], res, 0]
]



OpenCascadeShapeSolids[shape_, solidIDs_] /; OpenCascadeShapeExpressionQ[shape] :=
Module[
	{instances, id1, numSolids, res, sIDs = solidIDs, ord},

	numSolids = OpenCascadeShapeNumberOfSolids[shape];
	If[ numSolids < 1, Return[{}, Module]];

	sIDs = Flatten[{sIDs}];
	If[ sIDs === {All}, sIDs = Range[ numSolids]; ];
	sIDs = pack[sIDs];

	sIDs = DeleteDuplicates[sIDs];
	If[ Length[sIDs] < 1, Return[{}, Module]];
	If[ !TrueQ[ Max[ sIDs] <= numSolids] || (Min[sIDs] < 1),
		Return[$Failed, Module];
	];

	instances = Table[ OpenCascadeShapeCreate[], {Length[sIDs]}];

	id1 = instanceID[ shape];

	ord = Ordering[sIDs];
	sIDs = sIDs[[ord]];

	(* - 1 since C uses 0 index start *)
	res = getShapeSolidsFun[ pack[ instanceID /@ instances], id1, sIDs - 1];

	If[ res =!= 0, Return[$Failed, Module]];

	instances[[ord]]
]

OpenCascadeShapeSolids[shape_] /; OpenCascadeShapeExpressionQ[shape] :=
	OpenCascadeShapeSolids[shape, All]


OpenCascadeShapeFaces[shape_, faceIDs_] /; OpenCascadeShapeExpressionQ[shape] :=
Module[
	{instances, id1, numFaces, res, fIDs = faceIDs, ord},

	numFaces = OpenCascadeShapeNumberOfFaces[ shape];
	If[ numFaces < 1, Return[{}, Module]];

	fIDs = Flatten[{fIDs}];
	If[ fIDs === {All}, fIDs = Range[ numFaces]; ];
	fIDs = pack[fIDs];

	fIDs = DeleteDuplicates[fIDs];
	If[ Length[fIDs] < 1, Return[{}, Module]];
	If[ !TrueQ[ Max[ fIDs] <= numFaces] || (Min[fIDs] < 1),
		Return[$Failed, Module];
	];

	instances = Table[ OpenCascadeShapeCreate[], {Length[fIDs]}];

	id1 = instanceID[ shape];

	ord = Ordering[fIDs];
	fIDs = fIDs[[ord]];

	(* - 1 since C uses 0 index start *)
	res = getShapeFacesFun[ pack[ instanceID /@ instances], id1, fIDs - 1];

	If[ res =!= 0, Return[$Failed, Module]];

	instances[[ord]]
]

OpenCascadeShapeFaces[shape_] /; OpenCascadeShapeExpressionQ[shape] :=
	OpenCascadeShapeFaces[shape, All]

OpenCascadeShapeEdges[shape_, edgeIDs_] /; OpenCascadeShapeExpressionQ[shape] :=
Module[
	{instances, id1, numEdges, res, eIDs = edgeIDs, ord},

	numEdges = OpenCascadeShapeNumberOfEdges[ shape];
	If[ numEdges < 1, Return[{}, Module]];

	eIDs = Flatten[{eIDs}];
	If[ eIDs === {All}, eIDs = Range[ numEdges ]; ];
	eIDs = pack[eIDs];

	eIDs = DeleteDuplicates[eIDs];
	If[ Length[eIDs] < 1, Return[{}, Module]];
	If[ !TrueQ[ Max[ eIDs] <= numEdges] || (Min[eIDs] < 1),
		Return[$Failed, Module];
	];

	instances = Table[ OpenCascadeShapeCreate[], {Length[eIDs]}];

	id1 = instanceID[ shape];

	ord = Ordering[eIDs];
	eIDs = eIDs[[ord]];

	(* - 1 since C uses 0 index start *)
	res = getShapeEdgesFun[ pack[ instanceID /@ instances], id1, eIDs - 1];

	If[ res =!= 0, Return[$Failed, Module]];

	instances[[ord]]
]

OpenCascadeShapeEdges[shape_] /; OpenCascadeShapeExpressionQ[shape] :=
	OpenCascadeShapeEdges[shape, All]

OpenCascadeShapeVertices[shape_, vertexIDs_] /; OpenCascadeShapeExpressionQ[shape] :=
Module[
	{instances, id1, numVertices, res, vIDs = vertexIDs, ord},

	numVertices = OpenCascadeShapeNumberOfVertices[ shape];
	If[ numVertices < 1, Return[{}, Module]];

	vIDs = Flatten[{vIDs}];
	If[ vIDs === {All}, vIDs = Range[ numVertices ]; ];
	vIDs = pack[vIDs];

	vIDs = DeleteDuplicates[vIDs];
	If[ Length[vIDs] < 1, Return[{}, Module]];
	If[ !TrueQ[ Max[ vIDs] <= numVertices] || (Min[vIDs] < 1),
		Return[$Failed, Module];
	];

	instances = Table[ OpenCascadeShapeCreate[], {Length[vIDs]}];

	id1 = instanceID[ shape];

	ord = Ordering[vIDs];
	vIDs = vIDs[[ord]];

	(* - 1 since C uses 0 index start *)
	res = getShapeVerticesFun[ pack[ instanceID /@ instances], id1, vIDs - 1];

	If[ res =!= 0, Return[$Failed, Module]];

	instances[[ord]]
]

OpenCascadeShapeVertices[shape_] /; OpenCascadeShapeExpressionQ[shape] :=
	OpenCascadeShapeVertices[shape, All]


OpenCascadeShapeFillet[shape_, radius_, edgeIDs_] /; 
		OpenCascadeShapeExpressionQ[shape] &&
		NumericQ[ radius] &&
		(edgeIDs === All || VectorQ[edgeIDs, IntegerQ]) :=
Module[
	{instance, numEdges, id1, res, r, eIDs = edgeIDs},

	r = N[ radius];
	If[ r < $MachineEpsilon, Return[ shape, Module]; ];

	numEdges = OpenCascadeShapeNumberOfEdges[ shape];
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

OpenCascadeShapeFillet[shape_, radius_] /; OpenCascadeShapeExpressionQ[shape] :=
	OpenCascadeShapeFillet[ shape, radius, All] 

OpenCascadeShapeFillet[shape_, radius_, edgeIDs_] /; IntegerQ[edgeIDs] :=
	OpenCascadeShapeFillet[shape, radius, {edgeIDs}]


OpenCascadeShapeChamfer[shape_, distance_, edgeIDs_] /; 
		OpenCascadeShapeExpressionQ[shape] &&
		NumericQ[ distance] &&
		(edgeIDs === All || VectorQ[edgeIDs, IntegerQ]) :=
Module[
	{instance, numEdges, id1, res, d, eIDs = edgeIDs},

	d = N[ distance];
	If[ d < $MachineEpsilon, Return[ shape, Module]; ];

	numEdges = OpenCascadeShapeNumberOfEdges[ shape];
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

OpenCascadeShapeChamfer[shape_, distance_] /; OpenCascadeShapeExpressionQ[shape] :=
	OpenCascadeShapeChamfer[ shape, distance, All] 

OpenCascadeShapeChamfer[shape_, radius_, edgeIDs_] /; IntegerQ[edgeIDs] :=
	OpenCascadeShapeChamfer[shape, radius, {edgeIDs}]


OpenCascadeShapeShelling[shape_, thickness_, faceIDs_] /; 
		OpenCascadeShapeExpressionQ[shape] &&
		NumericQ[ thickness] &&
		VectorQ[faceIDs, IntegerQ] :=
Module[
	{instance, numFaces, id1, res, t, fIDs = faceIDs},

	t = N[ thickness];
	If[ t < $MachineEpsilon, Return[ shape, Module]; ];

	numFaces = OpenCascadeShapeNumberOfFaces[ shape];

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

OpenCascadeShapeShelling[shape_, thickness_, faceIDs_] /; IntegerQ[faceIDs] :=
	OpenCascadeShapeShelling[shape, thickness, {faceIDs}]


(*
	surface meshing and meshed component extraction
*)

(* information on the OC options
https://dev.opencascade.org/doc/overview/html/occt_user_guides__mesh.html
*)

OpenCascadeShapeSurfaceMesh[
	instance:OpenCascadeShapeExpression[ id_]?(testOpenCascadeShapeExpression[OpenCascadeShapeSurfaceMesh]),
	opts:OptionsPattern[OpenCascadeShapeSurfaceMesh]
] := 
Module[
	{res, realParams, boolParams, ldeflection, adeflection, parallelQ,
	relativeQ, cleanQ},

	ldeflection = N[ OptionValue["LinearDeflection"]];
	If[ !NumericQ[ ldeflection] || ldeflection <= 0.,
		ldeflection = 0.01
	];

	adeflection = N[ OptionValue["AngularDeflection"]];
	If[ !NumericQ[ adeflection] || adeflection <= 0.,
		adeflection = 0.5
	];	

	parallelQ = OptionValue["ComputeInParallel"];
	If[ !BooleanQ[ parallelQ], parallelQ = False];

	relativeQ = OptionValue["RelativeDeflection"];
	If[ !BooleanQ[ relativeQ], relativeQ = True];

	cleanQ = OptionValue["Rediscretization"];
	If[ !BooleanQ[ cleanQ], cleanQ = True];

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
		(* CleanModel *) 				cleanQ,
		(* AdjustMinSize *)				False
	}]];

	res = makeSurfaceMeshFun[ id, realParams, boolParams];
	If[ res =!= 0, Return[$Failed, Module]];

	instance
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


ClearAll[uniqueEdgeMarkers];
uniqueEdgeMarkers[l_, offset_] :=
Module[
	{u, order, union, newMarker, maxMarkerValue = offset, lookup = <||>, value},
	newMarker = ConstantArray[0, {Length[l]}];

	(* we want the sort of union*)
	u = Union/@l;
	order = Ordering[u];
	u = u[[order]];

	Do[
		union = u[[i]];
		If[Length[union] == 1,
			newMarker[[order[[i]]]] = union[[1]];
  		,
			value = lookup[union];
			If[MissingQ[value],
				maxMarkerValue += 1;
				lookup[union] = maxMarkerValue;
			];
  		newMarker[[order[[i]]]] = lookup[union];
  		];
	, {i, Length[l]}];

	newMarker
]

OpenCascadeShapeSurfaceMeshToBoundaryMesh[
	instance:OpenCascadeShapeExpression[ id_]?(testOpenCascadeShapeExpression[OpenCascadeShapeSurfaceMeshToBoundaryMesh]),
	opts:OptionsPattern[OpenCascadeShapeSurfaceMeshToBoundaryMesh]
] := 
Module[
	{surfaceMeshOpts, ok, coords, bEle, offsets, stop, start, spans, markers,
	markerOffset, bMeshOpts, elementMeshOpts, markerMethod, bmesh, pEle, pInci,
	vbc, allBoundaryMarker, automaticPMarker, maxMarker, lengthUnit},

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


	bMeshOpts = Flatten[{ OptionValue["ElementMeshOptions"]}];
	If[ bMeshOpts === {Automatic}, bMeshOpts = {}];
	bMeshOpts = FilterRules[bMeshOpts, Options[NDSolve`FEM`ToBoundaryMesh]];

	elementMeshOpts = FilterRules[bMeshOpts, Options[NDSolve`FEM`ElementMesh]];

	markerMethod = OptionValue["MarkerMethod"];
	Switch[ markerMethod,
		None | "None",
			bEle = {NDSolve`FEM`TriangleElement[ bEle]};
			bmesh = NDSolve`FEM`ElementMesh[coords, Automatic, bEle,
				elementMeshOpts];
		,
		ElementMesh | "ElementMesh",
			bEle = {NDSolve`FEM`TriangleElement[ bEle]};
			bmesh = NDSolve`FEM`ToBoundaryMesh["Coordinates"->coords,
				"BoundaryElements"->bEle, bMeshOpts];
		,
		_,
			markerOffset = OptionValue[NDSolve`FEM`ToBoundaryMesh,
				bMeshOpts, "MarkerOffset"];
			If[ !MatchQ[ markerOffset, {_Integer?Positive}],
				markerOffset = 0;
			];

			offsets = OpenCascadeShapeSurfaceMeshElementOffsets[instance];
			stop = FoldList[Plus, offsets];
			start = Most[Join[{1}, stop + 1]];
			spans = MapThread[Span, {start, stop}];
			markers = MapThread[ ConstantArray[#1, #2]&,
				{Range[Length[offsets]] + markerOffset, offsets}];
			bEle = MapThread[NDSolve`FEM`TriangleElement,
				{bEle[[#]] & /@ spans, markers}];

			bmesh = NDSolve`FEM`ElementMesh[coords, Automatic, bEle,
				elementMeshOpts];

			If[ !NDSolve`FEM`BoundaryElementMeshQ[bmesh],
				Return[$Failed, Module];
			];

			(* acount for deleted duplicates, intersecting faces, etc *)
			coords = bmesh["Coordinates"];
			bEle = bmesh["BoundaryElements"];
			pEle = bmesh["PointElements"];

			pInci = NDSolve`FEM`ElementIncidents[ pEle];
			(* We derive point markers from the automatic boundary markers;
				in cases a node is connected to a boundaries with multiple 
				markes then a point marker function needs to be specified 
				to change the point markers *)
			allBoundaryMarker = Join @@ NDSolve`FEM`ElementMarkers[bEle];
			vbc = bmesh["VertexBoundaryConnectivity"];

			bmesh = Null;

			maxMarker = Max[NDSolve`FEM`ElementMarkers[pEle],
				NDSolve`FEM`ElementMarkers[bEle]];

			pEle = Table[
				automaticPMarker = Extract[ allBoundaryMarker,
					vbc[[#]]["NonzeroPositions"]] & /@ Flatten[pInci[[i]]];

				(* replace points that are not on a boundary with the 
					default 0 marker *)
				automaticPMarker = automaticPMarker /. {} -> {0};

				(* point markers that connect to several surfaces with
					distinnct markers will get a unique marker based on
					the surface markers such that points connected to the
					same surfaces will get the same unique markers  *)
				automaticPMarker = uniqueEdgeMarkers[automaticPMarker, maxMarker];

				(* we replace everything that is not Integer or < 0 with
					the default zero marker, this can happen when a 
					PointElement includes a coordinate that is not on a
					boundary, like a single point in the domain. *)
				automaticPMarker = Replace[ automaticPMarker, 
					x_ /; (Head[x] =!= Integer || x < 0) -> 0, {1}];
				automaticPMarker = pack[ automaticPMarker];

				If[ !packedQ[ automaticPMarker] ||
						(Length[ pInci[[i]]] =!= Length[ automaticPMarker]),
					automaticPMarker = Sequence[];
				];

				NDSolve`FEM`PointElement[ pInci[[i]], automaticPMarker]
 			, {i, Length[pEle]}
			];

			(* the structural tests have already been done above *)
			bmesh = NDSolve`FEM`ElementMesh[coords, Automatic, bEle, pEle,
				Flatten[{elementMeshOpts
					, "CheckIntersections"->False
					, "DeleteDuplicateCoordinates"->False
					, "CheckIncidentsCompleteness"->False
				}]];
	];

	lengthUnit = OptionValue[NDSolve`FEM`ToBoundaryMesh, bMeshOpts, "LengthUnit"];
	(* Automatic is the default for "LengthUnit" and Automatic currently means
		no units *)
	If[ lengthUnit =!= Automatic,
		(* OCCT converts to MM by default *)
		NDSolve`FEM`SetLengthUnit[bmesh, "Millimeter"];
		If[ StringQ[lengthUnit] && (lengthUnit != "Millimeter"),
			bmesh = NDSolve`FEM`ElementMeshCoordinateRescale[bmesh, lengthUnit];
		];
	];

	bmesh
]

OpenCascadeFaceType[shape_] /; OpenCascadeShapeExpressionQ[shape] :=
Module[{type},
	type = getFaceTypeFun[ instanceID[ shape]];

	(* These come from the Geom_Surface Class Reference *)

	Switch[ type,
		1, "BSplineSurface",
		2, "BezierSurface",
		3, "RectangularTrimmedSurface",
		4, "ConeSurface",
		5, "CylindricalSurface",
		6, "PlaneSurface",
		7, "SphericalSurface",
		8, "ToroidalSurface",
		9, "LinearExtrusionSurface",
		10, "RevolutionSurface",
		11, "PlateSurface",
		12, "OffsetSurface",
		13, "CompositeSurface",
		_, $Failed
	]
]

OpenCascadeEdgeType[shape_] /; OpenCascadeShapeExpressionQ[shape] :=
Module[{type},

	type = getEdgeTypeFun[ instanceID[ shape]];

	(* These come from the Geom_Curve Class Reference *)

	Switch[ type,
		0, "NotACurve",
		1, "BSplineCurve",
		2, "BezierCurve",
		3, "TrimmedCurve",
		4, "Circle",
		5, "Ellipse",
		6, "Hyperbola",
		7, "Parabola",
		8, "Line",
		9, "OffsetCurve",
		10, "ComplexCurve",
		_, $Failed
	]
]


OpenCascadeFaceBSplineSurface[
	instance:OpenCascadeShapeExpression[ id_]?(testOpenCascadeShapeExpression[OpenCascadeFaceBSplineSurface]),
	opts:OptionsPattern[]
 ] /; OpenCascadeShapeType[instance] === "Face" :=
Module[
	{data, temp, optParam,
	nuPoles, nvPoles, nuKnots, nvKnots, uDegree, vDegree, uClosedQ, vClosedQ,
	lens, fl, parts, poles, weights, uknows, vknots, umult, vmult, bss},

	optParam = 0;

	temp = Flatten[{OptionValue["SetPeriodic"]}];
	temp = ArrayReshape[temp, 2, temp[[1]]];
	temp /. Automatic -> True;
	If[ temp[[1]] === True, optParam = BitSet[ optParam, 1]; ];
	If[ temp[[2]] === True, optParam = BitSet[ optParam, 2]; ];

	data = getFaceBSplineSurfaceFun[id, optParam];

	{nuPoles, nvPoles, nuKnots, nvKnots} = Floor[data[[1 ;; 4]]];

	{uDegree, vDegree} = Floor[data[[5 ;; 6]]];
	{uClosedQ, vClosedQ} = 
		If[# === 1, True, False] & /@ Floor[data[[7 ;; 8]]];

	lens = {8, nuPoles*nvPoles*3, nuPoles*nvPoles, nuKnots, nvKnots,
		nuKnots, nvKnots};

	fl = FoldList[Plus, lens];
	parts = MapThread[Span, {Most[fl + 1], Rest[fl]}];

	poles = data[[parts[[1]]]];
	weights = data[[parts[[2]]]];
	uknots = data[[parts[[3]]]];
	vknots = data[[parts[[4]]]];
	umult = Floor[data[[parts[[5]]]]];
	vmult = Floor[data[[parts[[6]]]]];

	bss = BSplineSurface[
		ArrayReshape[poles, {nuPoles, nvPoles, 3}],
		SplineKnots -> {
			Join @@ MapThread[ConstantArray, {uknots, umult}], 
	    	Join @@ MapThread[ConstantArray, {vknots, vmult}]
		},
		SplineWeights -> ArrayReshape[weights, {nuPoles, nvPoles}],
		SplineDegree -> {uDegree, vDegree},
		SplineClosed -> {uClosedQ, vClosedQ}
	];

	bss
]



(**)
(* Drafting *)
(**)

Make2DShape[$Failed] := $Failed;
(*Make2DShape[e_] := OpenCascadeShapeExpression2D[e];*)
Make2DShape[e_] := e;
OpenCascadeShape[OpenCascadeShapeExpression2D[e_]] := e

$OpenCascadeDraftAxis = {0,0,1};

OpenCascadeShape[Annulus[c_, {rIn_, rOut_}, a:{angle1_, angle2_}]] := 
Module[{center, iOut, iIn, instance},

	center = Join[c, {0}];
	iOut = OpenCascadeShape[OpenCascadeDisk[{center, $OpenCascadeDraftAxis}, rOut, a]];
	iIn = OpenCascadeShape[OpenCascadeDisk[{center, $OpenCascadeDraftAxis}, rIn, a]];
	instance = OpenCascadeShapeDifference[iOut, iIn];
(* the following is problematic for Annulus[{0, 0}, {1, 2}, {0, 2 \[Pi]}] *)
(*	instance = OpenCascadeShapeFace[instance];*)
	instance = Make2DShape[ instance];

	instance
]

OpenCascadeShape[Disk[c_, radius_:1, a_:{0, 2 Pi}]] := 
Module[{center, instance},

	center = Join[c, {0}];
	instance = OpenCascadeShape[OpenCascadeDisk[{center, $OpenCascadeDraftAxis}, radius, a]];
	instance = Make2DShape[ instance];

	instance
]


OpenCascadeShape[(Parallelepiped|Parallelogram)[base_, {c1_, c2_}]] /;
		VectorQ[base, NumericQ] && (Length[ base] === 2) && 
		VectorQ[c1, NumericQ] && (Length[ c1] === 2) && 
		VectorQ[c2, NumericQ] && (Length[ c2] === 2) := 
	OpenCascadeShape[Polygon[{base, base + c1, base + c1 + c2, base + c2}]]

OpenCascadeShape[Polygon[coords_]] /;
		MatrixQ[coords, NumericQ] && MatchQ[ Dimensions[coords], {_, 2}] :=
Module[{p, instance},

	p = pack[ N[ coords]];
	p = Join[p, ConstantArray[{0.}, {Length[p]}], 2];

	instance = OpenCascadeShape[Polygon[p]];
	instance = Make2DShape[ instance];

	instance
]

OpenCascadeShape[Polygon[coords_]] /;
		MatchQ[ Dimensions[coords], {_, _, 2}] :=
Module[{p, instance},

	p = pack[ N[ #]]& /@ coords;
	p = Join[#, ConstantArray[{0.}, {Length[#]}], 2]& /@ p;

	instance = OpenCascadeShape[Polygon[p]];
	instance = Make2DShape[ instance];

	instance
]

OpenCascadeShape[Polygon[coords_, data_]] /;
	MatrixQ[coords, NumericQ] && MatchQ[ Dimensions[coords], {_, 2}] :=
Module[{p, instance},

	p = pack[ N[ coords]];
	p = Join[p, ConstantArray[{0.}, {Length[p]}], 2];

	instance = OpenCascadeShape[Polygon[p, data]];
	instance = Make2DShape[ instance];

	instance
]

OpenCascadeShape[Rectangle[{xmin_, ymin_}]] :=
	OpenCascadeShape[Rectangle[{xmin, ymin}, {xmin + 1, ymin + 1}]]

OpenCascadeShape[Rectangle[{xmin_, ymin_}, {xmax_, ymax_}]] :=
	OpenCascadeShape[Polygon[{{xmin, ymin}, {xmax, ymin}, {xmax, ymax}, {xmin, ymax}}]];


OpenCascadeShape[RegularPolygon[d__]] :=
	OpenCascadeShape[Polygon[CirclePoints[d]]];



OpenCascadeShape[Triangle[coords_]] /;
		MatrixQ[coords, NumericQ] && MatchQ[ Dimensions[coords], {3, 2}] :=
OpenCascadeShape[Polygon[coords]]

OpenCascadeShape[Triangle[coords_]] /;
		ArrayQ[coords, 3, NumericQ] && MatchQ[ Dimensions[coords], {_, 3, 2}] :=
OpenCascadeShape[Polygon[coords]]


(* 1D primitives *)

OpenCascadeShape[BezierCurve[coords_, opts:OptionsPattern[]]] /;
		MatrixQ[coords, NumericQ] && MatchQ[ Dimensions[coords], {_, 2}] :=
Module[{p, instance},

	p = pack[ N[ coords]];
	p = Join[p, ConstantArray[{0.}, {Length[p]}], 2];

	instance = OpenCascadeShape[BezierCurve[p, opts]];
	instance = Make2DShape[ instance];

	instance
]


OpenCascadeShape[Circle[c:{_, _}]] := 
	OpenCascadeShape[Circle[c, 1, {0, 2 Pi}]]

OpenCascadeShape[Circle[c:{_, _}, r_]] := 
	OpenCascadeShape[Circle[c, r, {0, 2 Pi}]]


OpenCascadeShape[Circle[{x_, y_}, radius_, a:{angle1_, angle2_}]] /;
		NumericQ[radius] && radius > 0 && 
		NumericQ[angle1] && NumericQ[angle2] && (0 < Abs[(angle1 - angle2)] <= 2 Pi) :=
Module[{axis, instance},

	axis = {{x, y, 0.}, $OpenCascadeDraftAxis};

	instance = OpenCascadeShape[OpenCascadeCircle[axis, radius, a]];
	instance = Make2DShape[ instance];

	instance
]

OpenCascadeShape[Line[coords_]] /;
		MatrixQ[coords, NumericQ] && MatchQ[ Dimensions[coords], {_, 2}] :=
Module[{p, instance},

	p = pack[ N[ coords]];
	p = Join[p, ConstantArray[{0.}, {Length[p]}], 2];

	instance = OpenCascadeShape[Line[p]];
	instance = Make2DShape[ instance];

	instance
]

OpenCascadeShape[Line[coords_]] /;
		MatchQ[ Dimensions[coords], {_, _, 2}] :=
Module[{p, instance},

	p = pack[ N[ #]]& /@ coords;
	p = Join[#, ConstantArray[{0.}, {Length[#]}], 2]& /@ p;

	instance = OpenCascadeShape[Line[p]];
	instance = Make2DShape[ instance];

	instance
]


ClearAll[validOCCurvesQ]
validOCCurvesQ[_BezierCurve] := True
validOCCurvesQ[_BSplineCurve] := True
validOCCurvesQ[_Line] := True
(* Circle is not supported by (Joined|Filled)Curve *)
validOCCurvesQ[Circle[{x_, y_}, r_, {a1_, a2_}]] /; Abs[a2 - a1] < (2 Pi) := True
validOCCurvesQ[_] := False

getFirstCoord[BezierCurve[pts_, OptionsPattern[]]] := pts[[1]]
getFirstCoord[BSplineCurve[pts_, OptionsPattern[]]] := pts[[1]]
getFirstCoord[Line[pts_]] := pts[[1]]
getFirstCoord[Circle[c : {x_, y_}, r_, {a1_, a2_}]] := c + r {Cos[a1], Sin[a1]}

getLastCoord[BezierCurve[pts_, OptionsPattern[]]] := pts[[-1]]
getLastCoord[BSplineCurve[pts_, OptionsPattern[]]] := pts[[-1]]
getLastCoord[Line[pts_]] := pts[[-1]]
getLastCoord[Circle[c : {x_, y_}, r_, {a1_, a2_}]] := c + r {Cos[a2], Sin[a2]}

FilledCurve::discon = JoinedCurve::discon = "The last coordinate of segment `1` is not connected to the first coordinate of segment `2`."

getCurveShapes[curves_, head_] :=
Module[{shapes, instance},

	Do[
 		If[getLastCoord[curves[[i]]] != getFirstCoord[curves[[i + 1]]],
			Message[head::discon, curves[[i]], curves[[i+1]]];
			Return[$Failed, Module];
		];
	, {i, Length[curves] - 1} ];

	shapes = OpenCascadeShape /@ curves;

	shapes
]

OpenCascadeShape[JoinedCurve[curves:{__?validOCCurvesQ}, opts:OptionsPattern[]]] /;
	Union[RegionDimension/@ curves] === {1} :=
Module[{shapes, instance},

	shapes = getCurveShapes[curves, JoinedCurve];
	If[ FailureQ[shapes], Return[$Failed, Module];];
	instance = OpenCascadeShapeWire[shapes];

	instance
]

OpenCascadeShape[FilledCurve[curves:{__?validOCCurvesQ}, opts:OptionsPattern[]]] /;
	Union[RegionDimension/@ curves] === {1} :=
Module[{shapes, wire, instance},

	shapes = getCurveShapes[curves, FilledCurve];
	If[ FailureQ[shapes], Return[$Failed, Module];];
	wire = OpenCascadeShapeWire[shapes];
	instance = OpenCascadeShapeFace[wire];

	instance
]

OpenCascadeShape[mesh_] /;
	!NDSolve`FEM`BoundaryElementMeshQ[mesh] && NDSolve`FEM`ElementMeshQ[mesh] &&
		(mesh["EmbeddingDimension"] === 2) :=
Module[{ep},
	ep = NDSolve`FEM`ElementMeshProjection[mesh, {#[[1]], #[[2]], 0.}& ];
	OpenCascadeShape[ep]
]


OpenCascadeShape[mr_] /; (MeshRegionQ[mr] || BoundaryMeshRegionQ[mr]) &&
	(RegionEmbeddingDimension[mr] === 2) && (RegionDimension[mr] === 2) :=
Module[{em, ep},
	em = NDSolve`FEM`ToElementMesh[mr, "MeshOrder" -> 1, "MaxCellMeasure"->Infinity];
	ep = NDSolve`FEM`ElementMeshProjection[em, {#[[1]], #[[2]], 0.}& ];
	OpenCascadeShape[ep]
]


(**)
(* Visualization *)
(**)
OpenCascadeGraphics3D[s_, opts : OptionsPattern[Graphics3D]] /; 
	OpenCascadeShapeExpressionQ[s] :=
Graphics3D[OpenCascadeGraphics3DPrimitives[s], opts]

OpenCascadeGraphics3DPrimitives[s_] /; 
	OpenCascadeShapeExpressionQ[s] := 
Flatten[{OpenCascadeFaceGraphics3DPrimitives[s]}]

OpenCascadeFaceGraphics3DPrimitives[s_] /; 
	OpenCascadeShapeExpressionQ[ s] &&
	(OpenCascadeShapeType[s] === "Solid" ||
	OpenCascadeShapeType[s] === "Compound") := 
OpenCascadeFaceGraphics3DPrimitives /@ OpenCascadeShapeFaces[s]

OpenCascadeFaceGraphics3DPrimitives[f_] /; 
	OpenCascadeShapeExpressionQ[f] && OpenCascadeShapeType[f] === "Face" :=
Module[
	{faceType, bmesh, grp},

	faceType = OpenCascadeFaceType[f];

	Switch[ faceType
		, "BSplineSurface" | "ConeSurface",
			grp = OpenCascadeFaceBSplineSurface[f];
		,_,
			(* Add Option for Visualuzation Mesh Generation *)
			bmesh = OpenCascadeShapeSurfaceMeshToBoundaryMesh[f];
			grp = NDSolve`FEM`ElementMeshToGraphicsComplex[bmesh];
	];

	grp
]


End[]

EndPackage[]


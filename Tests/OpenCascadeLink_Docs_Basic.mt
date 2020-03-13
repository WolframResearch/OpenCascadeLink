(* Wolfram Language Test file *)

(* Basic OpenCascadeShape tests, requires MUnit *)

Test[
	Needs["OpenCascadeLink`"];
	Needs["NDSolve`FEM`"];
	,
	Null
	,
	TestID->"OpenCascadeLink_Docs_Basic-20200311-R2E2L2"
]

TestExecute[
	Get[FileNameJoin[{DirectoryName[$CurrentFile], "checkGraphicsRendering.m"}]];
]

TestExecute[
 Options[basicShapeTests] = {TestIDSuffix -> "", 
   OCShapeType -> ("Solid" | "Compound")};
 basicShapeTests[shape_, options : OptionsPattern[]] :=
     Module[ {shapeCascade, bmesh, testID, 
       openCascadeShapeType},
         iPrint[OptionValue[TestIDSuffix], OptionValue[OCShapeType]];
         testID = If[ OptionValue[TestIDSuffix] === "",
                      ToString[Keys[shape]],
                      OptionValue[TestIDSuffix]
                  ];
         openCascadeShapeType = OptionValue[OCShapeType];
         iPrint[testID, "-", openCascadeShapeType];
         Test[
             shapeCascade = OpenCascadeShape[shape];
             Head[shapeCascade]
             ,
             OpenCascadeShapeExpression
             ,
             TestID -> "OpenCascadeLink_Docs_Basic-20200311-" <> "ShapeExpression-" <> testID
         ];
         TestMatch[
             OpenCascadeShapeType[shapeCascade]
             ,
             openCascadeShapeType
             ,
             TestID -> "OpenCascadeLink_Docs_Basic-20200311-" <> "ShapeType-" <> testID
         ];
         If[testID === "polygonSelfIntersect", Return[]];
         ExactTest[
             bmesh = OpenCascadeShapeSurfaceMeshToBoundaryMesh[shapeCascade];
             Head[bmesh]
             ,
             ElementMesh
             ,
             TestID -> "OpenCascadeLink_Docs_Basic-20200311-" <> "BoundaryMesh-" <> testID
         ];
         Test[
             checkGraphicsRendering[Head, bmesh["Wireframe"]]
             ,
             {Graphics3D, "Rendering Errors" -> {}}
             ,
             TestID -> "OpenCascadeLink_Docs_Basic-20200311-" <> "WireframHead-" <> testID
         ];
     ]]


TestExecute[
	Get[FileNameJoin[{DirectoryName[$CurrentFile], "Data/OpenCascadeLink_Docs_Shapes.m"}]];
]

(* Solid 3D Primitives *)

sanityCheck = 
Test[
 	(* bug 389911 *)
	ball = OpenCascadeShape[Ball[{1, 0, 0}]];
	Head[ball]
	,
	OpenCascadeShapeExpression
	,
	TestID->"OpenCascadeLink_Docs_Basic-20200310-J8W7M2-bug-389911"
]

TestRequirement[
 	(* Requires the following tests to be run based on the status of the sanity test *)
 	FailureMode[sanityCheck] === "Success"
]

(* Solids *)

TestExecute[
 	MapIndexed[
 		basicShapeTests[#, TestIDSuffix -> ToString[First[First[#2]]]] &,
 		solids
 	]
]

(* Surfaces *)
TestExecute[
	MapIndexed[
		basicShapeTests[#, OCShapeType -> 
			If[MemberQ[{polygonWithHole, openMesh, closedMesh}, First[First[#2]]],
			 	"Solid",
			 	"Face"], TestIDSuffix -> ToString[First[First[#2]]]] &,
		surfaces
	]
]

(* Edges *)

Test[
    wire = OpenCascadeShape[
      Line[{{0, 1, 0}, {1, 1, 0}, {1.5, 2, 0}, {2, 2, 0}}]];
    OpenCascadeShapeType[wire]
    ,
    "Wire"
    ,
    TestID -> "ShapeExpression-Wire"
]

(* Operation on Surfaces *)

(* SurfaceMesh *)

Test[
 (* TODO: if possible, extract coordinates of vertices and reconstruct the mesh *)
    cone = OpenCascadeShape[Cone[{{0, 0, 0}, {0, 0, 1}}, 1]];
    OpenCascadeShapeSurfaceMesh[cone];
    Length[ele = OpenCascadeShapeSurfaceMeshElements[cone]]
    ,
    247
	,
	TestID->"OpenCascadeLink_Docs_Basic-20200310-C0T2W0"
]

(* Sewing *)

(* Tetrahedron *)

Test[
    data = {Polygon[{{0, 1, 0}, {1, 0, 0}, {0, 0, 0}}], 
      Polygon[{{0, 0, 2}, {1, 0, 0}, {0, 0, 0}}], 
      Polygon[{{0, 0, 2}, {0, 1, 0}, {1, 0, 0}}], 
      Polygon[{{0, 0, 2}, {0, 0, 0}, {0, 1, 0}}]};
    ocFaces = OpenCascadeShape[#] & /@ data;
    sewenFaces = OpenCascadeShapeSewing[ocFaces];
    OpenCascadeShapeType[sewenFaces]
    ,
    "Solid"
	,
	TestID->"OpenCascadeLink_Docs_Basic-20200310-B3T8H7"
]

Test[
    bmesh = OpenCascadeShapeSurfaceMeshToBoundaryMesh[sewenFaces];
    checkGraphicsRendering[Head, ToElementMesh[bmesh]["Wireframe"]]
	,
	{Graphics3D, "Rendering Errors" -> {}}
	,
	TestID->"OpenCascadeLink_Docs_Basic-20200310-Y0F9U2"
]

TestExecute[
 parametrizeCurve[pts_List, a : (_?NumericQ) : 1/2] :=
     FoldList[Plus, 0, Normalize[(Norm /@ Differences[pts])^a, Total]] /;
       MatrixQ[pts, NumericQ];
 ]

(* BSplineSurface *)

TestExecute[
	 pp = PolarPlot[1 + 0.5 Sin[2 \[Theta]], {\[Theta], 0, 2 \[Pi]}, 
	   MaxRecursion -> 1, PlotPoints -> 45];
	 coordinates = First[Cases[Normal[pp], Line[l_] :> l, \[Infinity]]];
	 tvals = parametrizeCurve[coordinates, 1];
	 bottom = ArrayPad[coordinates, {{0, 0}, {0, 1}}, -1.];
	 top = ArrayPad[coordinates, {{0, 0}, {0, 1}}, 2.];
	 knots = Join[{0., 0.}, tvals[[2 ;; -2]], {1., 1.}];
	 bss = BSplineSurface[Transpose[{bottom, top}], SplineDegree -> 1, 
	   SplineKnots -> {knots, {0, 0, 1, 1}}];
 ]

Test[
    surface = OpenCascadeShape[bss];
    p1 = OpenCascadeShape[Polygon[top]];
    p2 = OpenCascadeShape[Polygon[bottom]];
    bSplineSurface = OpenCascadeShapeSewing[{surface, p1, p2}];
    OpenCascadeShapeType[bSplineSurface]
    ,
    "Solid"
	,
	TestID->"OpenCascadeLink_Docs_Basic-20200310-Q8B0K9"
]

Test[
    bmesh = OpenCascadeShapeSurfaceMeshToBoundaryMesh[bSplineSurface];
    checkGraphicsRendering[Head, bmesh["Wireframe"]]
    ,
    {Graphics3D, "Rendering Errors" -> {}}
	,
	TestID->"OpenCascadeLink_Docs_Basic-20200310-J6O9F2"
]

(* Sewing Ellipsoid from BSplineSurface *)

TestExecute[
	center = {0, 1, -1/2};
	sigma = {{5, 2, 3}, {2, 3, 2}, {3, 2, 5}};
	el = Ellipsoid[center, sigma];
	matrix = If[ VectorQ[sigma],
             DiagonalMatrix[sigma^2],
             sigma
         ];
	{vals, vecs} = Eigensystem[N[matrix]];
	composition = 
		Composition[TranslationTransform[center], 
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
	pts = {pts1, -pts1, pts2, -pts2, pts3, -pts3, pts4, -pts4};
	bsss = Table[
  		BSplineSurface[composition /@ d, SplineDegree -> 2, 
  		SplineKnots -> {{0, 0, 0, 1, 1, 1}, {0, 0, 0, 1, 1, 1}}, 
  		SplineWeights -> {{1, 1/Sqrt[2], 1}, {1/Sqrt[2], 1/2, 
  		1/Sqrt[2]}, {1, 1/Sqrt[2], 1}}], {d, pts}];
]

Test[
    bsurfs = OpenCascadeShape /@ bsss;
    ellipsoidalBSpline = OpenCascadeShapeSewing[bsurfs];
    OpenCascadeShapeType[ellipsoidalBSpline]
    ,
    "Solid"
	,
	TestID->"OpenCascadeLink_Docs_Basic-20200310-G6M7P1"
]

Test[
    bmesh = OpenCascadeShapeSurfaceMeshToBoundaryMesh[ellipsoidalBSpline];
    checkGraphicsRendering[Head, bmesh["Wireframe"]]
    ,
    {Graphics3D, "Rendering Errors" -> {}}
	,
	TestID->"OpenCascadeLink_Docs_Basic-20200310-W4P5E9"
]

Test[
 (* Possible issue *)
    cu = OpenCascadeShape[Cuboid[{0, 0, 0}, {2, 2, 2}]];
    union = OpenCascadeShapeUnion[cu, ellipsoidalBSpline];
    checkGraphicsRendering[Head, OpenCascadeShapeSurfaceMeshToBoundaryMesh[union]["Wireframe"]]
    ,
    {Graphics3D, "Rendering Errors" -> {}}
	,
	TestID->"OpenCascadeLink_Docs_Basic-20200310-U4F2O4"
]

(* RotationalSweep *)

Test[
    pp = Polygon[{{0, 0, 0}, {1, 0, 0}, {1, 1, 0}, {0, 1, 0}}];
    square = OpenCascadeShape[pp];
    axis = {{2, 0, 0}, {2, 1, 0}};
    sweep = OpenCascadeShapeRotationalSweep[square, axis, -3 \[Pi]/2];
    OpenCascadeShapeType[sweep]
    ,
    "Solid"
	,
	TestID->"OpenCascadeLink_Docs_Basic-20200310-O7Y3K3"
]

Test[
    bmesh = OpenCascadeShapeSurfaceMeshToBoundaryMesh[sweep];
    checkGraphicsRendering[Head, bmesh["Wireframe"]]
    ,
    {Graphics3D, "Rendering Errors" -> {}}
	,
	TestID->"OpenCascadeLink_Docs_Basic-20200310-M5J9A5"
]

Test[
    ll = Line[{{0, 1, 0}, {1, 1, 0}, {1.5, 2, 0}, {2, 2, 0}}];
    wire = OpenCascadeShape[ll];
    axis = {{0, 0, 0}, {1, 0, 0}};
    sweep = OpenCascadeShapeRotationalSweep[wire, axis];
    OpenCascadeShapeType[sweep]
    ,
    "Shell"
	,
	TestID->"OpenCascadeLink_Docs_Basic-20200310-P9L6B1"
]

(* LinearSweep *)

Test[
    pp = Polygon[{{0, 0, 0}, {1, 0, 0}, {1, 1, 0}, {0, 1, 0}}];
    tile = OpenCascadeShape[pp];
    sweep = OpenCascadeShapeLinearSweep[tile, {{1/2, 1/2, 0}, {1, 1, 1}}];
    OpenCascadeShapeType[sweep]
    ,
    "Solid"
	,
	TestID->"OpenCascadeLink_Docs_Basic-20200310-A6Z4U7"
]

Test[
    ll = Line[{{0, 1, 0}, {1, 1, 0}, {1.5, 2, 0}, {2, 2, 0}}];
    wire = OpenCascadeShape[ll];
    axis = {{1/2, 1/2, 0}, {1, 1, 1}};
    sweep = OpenCascadeShapeLinearSweep[wire, axis];
    OpenCascadeShapeType[sweep]
    ,
    "Shell"
	,
	TestID->"OpenCascadeLink_Docs_Basic-20200310-F4L5O0"
]

(* Boolean Region *)
Test[
	booleanShape = OpenCascadeShapeBooleanRegion[
 		 BooleanRegion[Or, {Cuboid[], Ball[{1, 1, 1}]}]];
 	bmeshBooleanShape = OpenCascadeShapeSurfaceMeshToBoundaryMesh[booleanShape];
 	groups = bmeshBooleanShape["BoundaryElementMarkerUnion"];
	temp = Most[Range[0, 1, 1/(Length[groups])]];
	colors = ColorData["BrightBands"][#] & /@ temp;
	checkGraphicsRendering[Head, bmeshBooleanShape["Wireframe"["MeshElementStyle" -> FaceForm /@ colors]]]
    ,
    {Graphics3D, "Rendering Errors" -> {}}
	,
	TestID->"OpenCascadeLink_Docs_Basic-20200310-A5N0X5"
]

EndRequirement[]

ClearAll["Global`*"]
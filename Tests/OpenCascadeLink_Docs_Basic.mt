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


(* Loading relevant packages *)
Get[FileNameJoin[{DirectoryName[$CurrentFile], "checkGraphicsRendering.m"}]];

(* Utiltiy functions *)

Options[basicShapeTests] = {TestIDSuffix -> "", OCShapeType -> ("Solid" | "Compound")};

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
             TestID -> "OpenCascadeLink_Docs_Basic-20200311-" <> "ShapeExpression-" <> testID <> "-bug-416930"
         ];
         TestMatch[
             OpenCascadeShapeType[shapeCascade]
             ,
             openCascadeShapeType
             ,
             TestID -> "OpenCascadeLink_Docs_Basic-20200501-U9S8I5" <> "ShapeType-" <> testID
         ];
         If[ testID === "polygonSelfIntersect",
             Return[]
         ];
         ExactTest[
             bmesh = OpenCascadeShapeSurfaceMeshToBoundaryMesh[shapeCascade];
             Head[bmesh]
             ,
             ElementMesh
             ,
             TestID -> "OpenCascadeLink_Docs_Basic-20200501-W4X2X3" <> "BoundaryMesh-" <> testID
         ];
         Test[
             checkGraphicsRendering[Head, bmesh["Wireframe"]]
             ,
             {Graphics3D, "Rendering Errors" -> {}}
             ,
             TestID -> "OpenCascadeLink_Docs_Basic-20200501-M5E3Y1" <> "WireframHead-" <> testID
         ];
     ]

(* Loading relevant data *)
Get[FileNameJoin[{DirectoryName[$CurrentFile], "Data/OpenCascadeLink_Docs_Shapes.m"}]];


(* Tests *)


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

MapIndexed[
     basicShapeTests[#, TestIDSuffix -> ToString[First[First[#2]]]] &,
     solids
]

(* Surfaces *)

MapIndexed[
    basicShapeTests[#, OCShapeType -> 
        Switch[ First[First[#2]],
        	closedMesh, "Solid",
            polygonWithHole|openMesh, "Shell",
            _, "Face"
        ], TestIDSuffix -> ToString[First[First[#2]]]] &,
    surfaces
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
    "Shell"
    ,
    TestID->"OpenCascadeLink_Docs_Basic-20200310-B3T8H7"
]

Test[
    data = {Polygon[{{0, 1, 0}, {1, 0, 0}, {0, 0, 0}}], 
      Polygon[{{0, 0, 2}, {1, 0, 0}, {0, 0, 0}}], 
      Polygon[{{0, 0, 2}, {0, 1, 0}, {1, 0, 0}}], 
      Polygon[{{0, 0, 2}, {0, 0, 0}, {0, 1, 0}}]};
    ocFaces = OpenCascadeShape[#] & /@ data;
    sewenFaces = OpenCascadeShapeSewing[ocFaces, "BuildSolid" -> True];
    OpenCascadeShapeType[sewenFaces]
    ,
    "Solid"
    ,
    TestID->"OpenCascadeLink_Docs_Basic-20201209-B3T8H7"
]

Test[
    bmesh = OpenCascadeShapeSurfaceMeshToBoundaryMesh[sewenFaces];
    checkGraphicsRendering[Head, ToElementMesh[bmesh]["Wireframe"]]
    ,
    {Graphics3D, "Rendering Errors" -> {}}
    ,
    TestID->"OpenCascadeLink_Docs_Basic-20200310-Y0F9U2"
]


(* BSplineSurface *)

Test[
	parametrizeCurve[pts_List, a : (_?NumericQ) : 1/2] :=
		FoldList[Plus, 0, Normalize[(Norm /@ Differences[pts])^a, Total]] /;
	       MatrixQ[pts, NumericQ];
	pp = PolarPlot[1 + 0.5 Sin[2 \[Theta]], {\[Theta], 0, 2 \[Pi]}, 
   		MaxRecursion -> 1, PlotPoints -> 45];
	coordinates = First[Cases[Normal[pp], Line[l_] :> l, \[Infinity]]];
	tvals = parametrizeCurve[coordinates, 1];
	bottom = ArrayPad[coordinates, {{0, 0}, {0, 1}}, -1.];
	top = ArrayPad[coordinates, {{0, 0}, {0, 1}}, 2.];
	knots = Join[{0., 0.}, tvals[[2 ;; -2]], {1., 1.}];
	bss = BSplineSurface[Transpose[{bottom, top}], SplineDegree -> 1, 
	   SplineKnots -> {knots, {0, 0, 1, 1}}];
    surface = OpenCascadeShape[bss];
    p1 = OpenCascadeShape[Polygon[top]];
    p2 = OpenCascadeShape[Polygon[bottom]];
    bSplineSurface = OpenCascadeShapeSewing[{surface, p1, p2},
		"BuildSolid"->True];
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

Test[
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

    bsurfs = OpenCascadeShape /@ bsss;
    ellipsoidalBSpline = OpenCascadeShapeSewing[bsurfs, "BuildSolid"->True];
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

Test[
	Options[OpenCascadeShapeSurfaceMesh]
	,
	{"AngularDeflection" -> Automatic, "ComputeInParallel" -> Automatic, 
	"LinearDeflection" -> Automatic, "RelativeDeflection" -> Automatic}
	,
	TestID->"OpenCascadeLink_Docs_Basic-20200501-D9P2E7-bug-391736"
]

Test[
	Options[OpenCascadeShapeSurfaceMeshToBoundaryMesh]
	,
	{"ElementMeshOptions" -> Automatic, 
	"MarkerMethod" -> Automatic, 
 	"ShapeSurfaceMeshOptions" -> Automatic}
	,
	TestID->"OpenCascadeLink_Docs_Basic-20200501-K9K6O8-bug-391736"
]

Test[
	shape = OpenCascadeShape[Cone[{{0, 0, 0}, {0, 0, 1}}, 1]];
	OpenCascadeShapeSurfaceMesh[shape];
	bmesh = OpenCascadeShapeSurfaceMeshToBoundaryMesh[shape, "ShapeSurfaceMeshOptions" -> {"LinearDeflection" -> 0.001}];
	checkGraphicsRendering[Head, bmesh["Wireframe"]]
	,
	{Graphics3D, "Rendering Errors" -> {}}
	,
	TestID->"OpenCascadeLink_Docs_Basic-20200501-Z2B4T8-bug-391736"
]

NTest[
	torus = OpenCascadeShape[OpenCascadeTorus[{{0, 0, 0}, {0, 0, 1}}, 3, 1]];
	bmesh = OpenCascadeShapeSurfaceMeshToBoundaryMesh[torus];
	bmesh["Bounds"]
	,
	{{-3.9794772935675806, 4.}, {-3.994866028684211, 3.994866028684211}, 
	{-0.9927088740980543, 0.992708874098054}}
	,
	AccuracyGoal -> 1
	,
	TestID->"OpenCascadeLink_Docs_Basic-20201125-V2G0B3-bug-400852"
]

collinear[p_, q_, r_, opts___] := 
	Block[{slopepq = p - q, sloperq = r - q},
		Internal`CompareToPAT[slopepq, sloperq, opts]
	];

NTest[
	seed = ToString[Take[DateList[], 3]];
	axes = BlockRandom[RandomReal[{0, 1}, {2, 3}], RandomSeeding -> seed];
	torus = OpenCascadeShape[OpenCascadeTorus[axes, 3, 1]];
	bmesh = OpenCascadeShapeSurfaceMeshToBoundaryMesh[torus];
	centroid = Mean /@ bmesh["Bounds"];
	collinear[axes[[1]], axes[[2]], centroid, AccuracyGoal -> 2]
	,
	True
	,
	TestID->"OpenCascadeLink_Docs_Basic-20201125-W3A1P0-bug-400852"
]

EndRequirement[]

ClearAll["Global`*"]

(* Wolfram Language Test file *)

Needs["OpenCascadeLink`"];
Needs["NDSolve`FEM`"];

Test[
	shape = OpenCascadeShape[PolyhedronData["MathematicaPolyhedron", "Polyhedron"]];
	OpenCascadeShapeLinearSweep[shape, {{0, 0, 0}, {1, 1, 1}}]
	,
	$Failed
	,
	TestID->"OpenCascadeLink_Bugs-20200708-L0S5G8-bug-395241"
]

Test[
	shape = OpenCascadeShape[PolyhedronData["MathematicaPolyhedron", "Polyhedron"]];
	OpenCascadeShapeRotationalSweep[shape, {{0, 0, 0}, {1, 0, 0}}]
	,
	$Failed
	,
	TestID->"OpenCascadeLink_Bugs-20200708-W1B1T8-bug-395241"
]

NTest[
	reg1 = Cone[{{0, 0, 0}, {0, 0, 985/300}}, 24625/9700];
	reg2 = Cylinder[{{0, 0, 500/300}, {0, 0, 1000/300}}, 125/100];
	reg3 = Cone[{{0, 0, 500/100}, {0, 0, 500/100 - 985/300}}, 24625/9700];
	
	{shape1, shape2, shape3} = OpenCascadeShape /@ {reg1, reg2, reg3};
	union = OpenCascadeShapeUnion [shape1, shape2, shape3];
	OpenCascadeShapeSurfaceMeshToBoundaryMesh[union]["Bounds"]
	,
	{{-(985/388), 985/388}, {-(985/388), 985/388}, {0, 5}}
	, 
	AccuracyGoal -> 5
	,
	TestID->"OpenCascadeLink_Bugs-20201105-R1Q6A6-bug-391662"
]

TestMatch[
	regions = {Ellipsoid[{0, 0, 0}, {{5, 2, 3}, {2, 3, 2}, {3, 2, 5}}], 
				Ball[{1, 0, 0}]};
	Block[{out = {}}, 
 		Internal`HandlerBlock[{"Wolfram.System.Print", (out = {out, #}) &},
	{OpenCascadeShapeIntersection @@ OpenCascadeShape /@ regions, out}]]
	,
	{_OpenCascadeShapeExpression, {}}
	,
	TestID->"OpenCascadeLink_Bugs-20201116-M7T8X0-bug-401214"
]

With[{path = FileNameJoin[{DirectoryName[$CurrentFile], "Data/ClassicalMuffler.stl"}]},
TestMatch[
	shape = OpenCascadeShapeImport[path];
 	elementMesh = OpenCascadeShapeSurfaceMeshToBoundaryMesh[shape, 
 						"MarkerMethod" -> "ElementMesh"];
 	markersLength = AssociationMap[Length[elementMesh[#]]&, {"PointElementMarkerUnion", "BoundaryElementMarkerUnion",
 												"MeshElementMarkerUnion"}]
 	,
 	(* checks if numbers of markers are less than number of elements *)
 	<|"PointElementMarkerUnion" -> _?(# < Length[elementMesh["Coordinates"]] &),
 	"BoundaryElementMarkerUnion" -> _?(# < Length[First@First[elementMesh["BoundaryElements"]]]&),
 	"MeshElementMarkerUnion" -> 1|>
	,
	TestID->"OpenCascadeLink_Bugs-20201117-A5R3Y2-bug-398536"
]
]

Test[
	(*shape = OpenCascadeShapeImport[FileNameJoin[{DirectoryName[$CurrentFile], "Data/ClassicalMuffler.stl"}]];*)
	elementMesh = OpenCascadeShapeSurfaceMeshToBoundaryMesh[shape, 
 						"MarkerMethod" -> None];
 	AssociationMap[elementMesh[#]&, {"PointElementMarkerUnion", "BoundaryElementMarkerUnion",
 									"MeshElementMarkerUnion"}]
 	,
 	<|"PointElementMarkerUnion" -> {0},
 	"BoundaryElementMarkerUnion" -> {0},
 	"MeshElementMarkerUnion" -> {0}|>
	,
	TestID->"OpenCascadeLink_Bugs-20201117-G4W2N0-bug-398536"
]

NTest[
	box1 = Cuboid[{-0.0325`, 0, -0.0135`}, {0.0325`, 0.033`, 0.0135`}];
	boxTransformed = TransformedRegion[box1, RotationTransform[10 \[Degree], {0, 1, 0}]];
	shape = OpenCascadeShape[boxTransformed];
	bmesh = OpenCascadeShapeSurfaceMeshToBoundaryMesh[shape];
	Sort[bmesh["Coordinates"]]
	,
	Sort[First /@ MeshPrimitives[boxTransformed, 0]]
	,
	AccuracyGoal -> 5
	,
	TestID->"OpenCascadeLink_Bugs-20201117-N9A1L2-bug-397202"
]

NTest[
	shape = OpenCascadeShape[Parallelepiped[{0.5, 0, 0}, {{0, 1, 0}, {0, 0, 1}}]];
	bmesh = OpenCascadeShapeSurfaceMeshToBoundaryMesh[shape];
	bmesh["Coordinates"]
	,
	{{0.5, 0., 0.}, {0.5, 1., 0.}, {0.5, 1., 1.}, {0.5, 0., 1.}}
	,
	TestID->"OpenCascadeLink_Bugs-20201117-H2R8O5-bug-399162"
]

TestMatch[
	c1 = Cuboid[{0, 0, 0}, {0.5, 1, 1}];
	c2 = Cuboid[{0.5, 0, 0}, {1, 1, 2}];
	shape1 = OpenCascadeShape[c1];
	shape2 = OpenCascadeShape[c2];
	{s = OpenCascadeShapeIntersection[shape1, shape2],
	OpenCascadeShapeType[s],
	OpenCascadeShapeSolids[s],
	OpenCascadeShapeNumberOfSolids[s]}
	,
	{_OpenCascadeShapeExpression,
	"Compound",
	{},
	0}
	,
	TestID->"OpenCascadeLink_Bugs-20201120-V9G4E3-bug-400507"
]

NTest[
	(* OpenCascadeLink supports coplanar points *)
	{P1, P2, P3, P4} = polydata = {{0.0009750000000000002, 0.003862499999999999,0.00238028772515744}, 
						{0.0009750000000000002, 0.004800000000000002, 0.0021002496030130442}, 
						{0.0017999999999999995, 0.004800000000000002, 0.002066207259773256}, 
						{0.0017999999999999995, 0.003862499999999999, 0.0023417063243405954}};
	shape = OpenCascadeShape[Polygon[polydata]];
	bmesh = OpenCascadeShapeSurfaceMeshToBoundaryMesh[shape];
	<|"ShapeType" -> OpenCascadeShapeType[shape], 
	"Coordinates" -> Sort[bmesh["Coordinates"]], 
	"NumberOfSolids" -> OpenCascadeShapeNumberOfSolids[shape]|>
	,
	<|"ShapeType" -> "Shell", 
	"Coordinates" -> Sort[polydata],
	"NumberOfSolids" -> 0|>
	,
	TestID->"OpenCascadeLink_Bugs-20210506-Z8J9G9-bug-408840"
]

NTest[
	shape = OpenCascadeShape[CapsuleShape[{{0, -2, 0}, {0, 0, 1}}, 1]];
	r = ImplicitRegion[x^4 + y^4 + z^4 - 1 == 0, {x, y, z}];
	bmesh = ToBoundaryMesh[r, {{-2, 2}, {-2, 2}, {-2, 2}}];
	shape2 = OpenCascadeShape[bmesh];
	union = OpenCascadeShapeUnion[shape2, shape];
	mesh = OpenCascadeShapeSurfaceMeshToBoundaryMesh[union];
	NIntegrate[1, {x, y, z} \[Element] mesh]
	,
	32.86149300689737
	,
	PrecisionGoal -> 5
	,
	TestID->"OpenCascadeLink_Bugs-20221014-K8Z2U4-bug-404068"
]

With[{d = 0.001, w = 0.005, h = 0.02},
	Test[
		side = Cuboid[{0, 0, 0}, {d, w, h}];
		top = Cuboid[{0, 0, h - 2 d}, {h, w, h - d}];
		shape = OpenCascadeShape[RegionUnion[side, top]];
		FailureQ /@ {OpenCascadeShapeFillet[shape, d, {2}], OpenCascadeShapeChamfer[shape, d, {2}]}
		,
		{True, True}
		,
		TestID->"OpenCascadeLink_Bugs-20221014-S6S5V5-bug-405722"
	]
]

NTest[
	geometricParameters = {d -> 0.01, w -> 0.05, h -> 0.2};
	side = Cuboid[{0, 0, 0}, {d, w, h}] /. geometricParameters;
	top = Cuboid[{0, 0, h - 2 d}, {h, w, h - d}] /. geometricParameters;
	mount1 =
	  Cylinder[{{-d, w/2, 5 d}, {2 d, w/2, 5 d}}, w/10] /.
	   geometricParameters;
	mount2 =
	  Cylinder[{{-d, w/2, h - 5 d}, {2 d, w/2, h - 5 d}}, w/10] /.
	   geometricParameters;
	region =
	  RegionDifference[RegionDifference[RegionUnion[side, top], mount1],
	   mount2];
	shape = OpenCascadeShape[region];
	bmesh = OpenCascadeShapeSurfaceMeshToBoundaryMesh[shape];
	NIntegrate[1, {x, y, z} \[Element] bmesh]
	,
	0.04811568037375386
	,
	AccuracyGoal -> 2
	,
	TestID->"OpenCascadeLink_Bugs-20221110-B9U6C3"
]

NTest[
	curv1 = {{3, 0, 0}, {1, 1, 0}, {0, 2, 0}, {-2, 0, 0}, {0, -2, 0}, {3,
    0, 0}};
	curv2 = {{2, 0, 5}, {1, 1, 2}, {0, 2, 2}, {-1, 0, 5}, {0, -2, 5}, {3,
	    0, 5}};
	curv3 = {{2, 0, 9}, {1, 1, 9}, {0, 2, 9}, {-1, 0, 6}, {0, -2, 6}, {3,
	    0, 9}};
	sur21 = BSplineSurface[{curv1, curv2}, SplineClosed -> {False, True}, 
	   SplineDegree -> {1, 3}];
	sur22 = BSplineSurface[{curv2, curv3}, SplineClosed -> {False, True}, 
	   SplineDegree -> {1, 3}];
	s1 = OpenCascadeShape[sur21];
	s2 = OpenCascadeShape[sur22];
	surface = OpenCascadeShapeSewing[{s1, s2}];
	bmesh = OpenCascadeShapeSurfaceMeshToBoundaryMesh[surface];
	NIntegrate[1, {x, y, z} \[Element] bmesh]
	,
	74.61852471806743
	,
	PrecisionGoal -> 5
	,
	TestID->"OpenCascadeLink_Bugs-20221208-T5O4L1-bug-399314"
]

NTest[
	bmesh = OpenCascadeShapeSurfaceMeshToBoundaryMesh[
 		OpenCascadeShapeBooleanRegion@
  		RegionDifference[Ball[{0, 0, 0}], Ball[{0, 1, 1}]]];
  	mesh = ToElementMesh[bmesh];
  	{NIntegrate[1, {x, y, z} \[Element] bmesh], NIntegrate[1, {x, y, z} \[Element] mesh]}
  	,
  	{4 Pi, (5 Pi)/(3 Sqrt[2])}
  	,
  	PrecisionGoal -> 1.5
	,
	TestID->"OpenCascadeLink_Bugs-20221213-Z4Z4Y5-bug-392674"
]

NTest[
	bmesh = OpenCascadeShapeSurfaceMeshToBoundaryMesh[
		OpenCascadeShapeDifference @@
 		OpenCascadeShape /@ {Ball[{0, 0, 0}], Ball[{0, 1, 1}]}];
  	mesh = ToElementMesh[bmesh];
  	{NIntegrate[1, {x, y, z} \[Element] bmesh], NIntegrate[1, {x, y, z} \[Element] mesh]}
  	,
  	{4 Pi, (5 Pi)/(3 Sqrt[2])}
  	,
  	PrecisionGoal -> 1.5
	,
	TestID->"OpenCascadeLink_Bugs-20221213-I2B9R7-bug-392674"
]

NTest[
	bmesh = OpenCascadeShapeSurfaceMeshToBoundaryMesh[
		OpenCascadeShapeDifference @@
 		OpenCascadeShape /@ {Ball[{0, 0, 0}], Ball[{0, 11/10, 1}]}];
  	mesh = ToElementMesh[bmesh];
  	{NIntegrate[1, {x, y, z} \[Element] bmesh], NIntegrate[1, {x, y, z} \[Element] mesh]}
  	,
  	{4 Pi, (5 Pi)/(3 Sqrt[2])}
  	,
  	PrecisionGoal -> 1.5
	,
	TestID->"OpenCascadeLink_Bugs-20221213-L1M9I4-bug-392674"
]

Clear["Global`*"];
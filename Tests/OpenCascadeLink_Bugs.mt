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
Test[
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

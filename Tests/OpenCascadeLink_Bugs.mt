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
	unionOpenCascade = DiscretizeGraphics[OpenCascadeShapeSurfaceMeshToBoundaryMesh[union]["Wireframe"]];
	RegionBounds[unionOpenCascade]
	,
	{{-(985/388), 985/388}, {-(985/388), 985/388}, {0, 5}}
	, 
	AccuracyGoal -> 5
	,
	TestID->"OpenCascadeLink_Bugs-20201105-R1Q6A6-bug-391662"
]
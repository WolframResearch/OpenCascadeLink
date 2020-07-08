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
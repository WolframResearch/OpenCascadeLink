(* Wolfram Language Test file *)

(* Tests on boolean operations (union), requires MUnit *)
Test[
	Needs["OpenCascadeLink`"];
	Needs["NDSolve`FEM`"];
	,
	Null
	,
	TestID->"OpenCascadeLink_Docs_BooleanOperations-Union-20200311-R2E2L2"
]


(* Loading relevant packages *)
Get[FileNameJoin[{DirectoryName[$CurrentFile], "checkGraphicsRendering.m"}]];
Get[FileNameJoin[{DirectoryName[$CurrentFile], "TestingUtilities.m"}]];
     
(* Loading relevant data *)
Get[FileNameJoin[{DirectoryName[$CurrentFile], "Data/OpenCascadeLink_Docs_Shapes.m"}]];


(* Tests *)


sanityCheck = 
Test[
	(* bug 389911 *)
	ball = OpenCascadeShape[Ball[{1, 0, 0}]];
	Head[ball]
	,
	OpenCascadeShapeExpression
	,
	TestID->"OpenCascadeLink_Docs_BooleanOperations-Union-20200310-J8W7M2-bug-389911"
]

TestRequirement[
 	(* Requires the following tests to be run based on the status of the sanity test *)
 	FailureMode[sanityCheck] === "Success"
]


(* Boolean operations *)

(* excludes SphercialShell since the resulting region may be too complicated *)
combinationsIndices = Subsets[Range[Length[solids]], {2}];
combinations = solids[[#]] & /@ combinationsIndices;

(* Union of SphericalShell and Tetrahedron hangs, see 391160 *)
combinations = DeleteCases[combinations, <|SphericalShell -> _, Tetrahedron -> _|>];


(* Union *)
 MapIndexed[
  boolOperationTest[#, "Union"] &,
  combinations]

EndRequirement[]

ClearAll["Global`*"]
(* Wolfram Language Test file *)

(* Tests on boolean operations (intersection), requires MUnit *)
Test[
	Needs["OpenCascadeLink`"];
	Needs["NDSolve`FEM`"];
	,
	Null
	,
	TestID->"OpenCascadeLink_Docs_BooleanOperations-Intersection-20200311-R2E2L2"
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
	TestID->"OpenCascadeLink_Docs_BooleanOperations-Intersection-20200310-J8W7M2-bug-389911"
]

TestRequirement[
 	(* Requires the following tests to be run based on the status of the sanity test *)
 	FailureMode[sanityCheck] === "Success"
]


(* Boolean operations *)

(* excludes regionUnionPolyhedron since it hangs. *)
combinationsIndices = DeleteCases[Tuples[Range[Length[solids]], {2}], {x_, x_}];
combinations = solids[[#]] & /@ combinationsIndices;

(* Intersection of Ball and regionUnionPolyhedron hangs, see 391160 *)
combinations = DeleteCases[combinations, <|Ball -> _, regionUnionPolyhedron -> _|> |
										 <|regionUnionPolyhedron -> _, Ball -> _|>];

(* Intersection *)
bugIDIntersection = Merge[{Thread[{{CapsuleShape, Ellipsoid},
							  {Ellipsoid, CapsuleShape}} -> "-bug-391160"],
						  <|{Ball, Ellipsoid} -> "-bug-390059"|>}, Identity];

 MapIndexed[
  boolOperationTest[#, "Intersection", 
  	If[KeyExistsQ[bugIDIntersection, Keys[#]], Lookup[bugIDIntersection,Key[Keys[#]]], ""]] &,
  combinations]

EndRequirement[]
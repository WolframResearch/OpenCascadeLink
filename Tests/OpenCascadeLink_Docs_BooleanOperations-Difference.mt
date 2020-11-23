(* Wolfram Language Test file *)

(* Tests on boolean operations (difference), requires MUnit *)
Test[
	Needs["OpenCascadeLink`"];
	Needs["NDSolve`FEM`"];
	,
	Null
	,
	TestID->"OpenCascadeLink_Docs_BooleanOperations-Difference-20200311-R2E2L2"
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
	TestID->"OpenCascadeLink_Docs_BooleanOperations-Difference-20200310-J8W7M2-bug-389911"
]

TestRequirement[
 	(* Requires the following tests to be run based on the status of the sanity test *)
 	FailureMode[sanityCheck] === "Success"
]


(* Boolean operations *)

combinationsIndices = DeleteCases[Tuples[Range[Length[solids]], {2}], {x_, x_}];
combinations = solids[[#]] & /@ combinationsIndices;

(* SphericalShell\Tetrahedron hangs, see 391160 *)
combinations = DeleteCases[combinations, <|SphericalShell -> _, Tetrahedron -> _|> |
										 <|regionUnionPolyhedron -> _, Ball -> _|> |
										 <|CapsuleShape -> _, Ellipsoid -> _|>];

bugID = Merge[{Thread[{{SphericalShell, Tetrahedron},
				  {CapsuleShape, Ellipsoid},
				  {Ellipsoid, CapsuleShape},
				  {Ellipsoid, SphericalShell}} -> "-bug-391160"],
			  <|{Cone, Ellipsoid} -> "-bug-390054",
			    {regionUnionPolyhedron, Ellipsoid} -> "-bug-392674"|>}, Identity];

(* Difference *)
MapIndexed[
  boolOperationTest[#, "Difference", 
	If[KeyExistsQ[bugID, Keys[#]], Lookup[bugID,Key[Keys[#]]], ""]] &,
  combinations]

EndRequirement[]
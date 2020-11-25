(* Wolfram Language Test file *)

Test[
	Needs["OpenCascadeLink`"];
	Needs["NDSolve`FEM`"];
	,
	Null
	,
	TestID->"OpenCascadeLink_MeshProperties-20201125-R1B8O1"
]


(* Loading relevant packages *)
Get[FileNameJoin[{DirectoryName[$CurrentFile], "checkGraphicsRendering.m"}]];
Get[FileNameJoin[{DirectoryName[$CurrentFile], "TestingUtilities.m"}]];
     
(* Loading relevant data *)
Get[FileNameJoin[{DirectoryName[$CurrentFile], "Data/OpenCascadeLink_Docs_Shapes.m"}]];

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

MapIndexed[
	Block[{shape, shapeData = <||>},
		TestMatch[
			shape = OpenCascadeShape[#];
			shapeData["Vertex"] = OpenCascadeShapeVertices[shape];
			shapeData["Edge"] = OpenCascadeShapeEdges[shape];
			shapeData["Face"] = OpenCascadeShapeFaces[shape];
			
			<|"Shape" -> #,
			"Type unmatch" -> MapIndexed[(DeleteCases[OpenCascadeShapeType /@ #, 
    													First[First[#2]]]) &, shapeData],
    		"Number of Vertices" -> OpenCascadeShapeNumberOfVertices[shape]|>
    		,
    		<|"Shape" -> #,
    		"Type unmatch" -> <|"Vertex" -> {}, "Edge" -> {}, "Face" -> {}|>,
    		"Number of Vertices" -> Length[shapeData["Vertex"]]|>
    		,
    		TestID -> "OpenCascadeLink_MeshProperties-20201125-Properties-" <> ToString[First[First[#2]]] <> "-bug-399166"
		]]&, Join[solids, surfaces]
]

EndRequirement[]
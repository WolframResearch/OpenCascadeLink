(* Wolfram Language Test file *)

(* Tests on boolean operations (difference, union and intersection), requires MUnit *)


Test[
	Needs["OpenCascadeLink`"];
	Needs["NDSolve`FEM`"];
	,
	Null
	,
	TestID->"OpenCascadeLink_Docs_BooleanOperations-20200311-R2E2L2"
]


(* Loading relevant packages *)
Get[FileNameJoin[{DirectoryName[$CurrentFile], "checkGraphicsRendering.m"}]];

(* Utility functions *)

 boolOperationTest[shapeAssoc_Association, operation_, bugID_ : ""] :=
     Block[ {shapeList, shape, bmesh, groups, temp, colors},
         shapeList = Sort[shapeAssoc, RegionMeasure[#1] > RegionMeasure[#2] &];
          Test[
              shape = Switch[operation,
                "Difference",
                OpenCascadeShapeDifference @@ (OpenCascadeShape /@ shapeList),
                "Union",
                OpenCascadeShapeUnion @@ (OpenCascadeShape /@ shapeList),
                "Intersection",
                OpenCascadeShapeIntersection @@ (OpenCascadeShape /@ shapeList),
                True,
                Return[$Failed]
                ];
 		  OpenCascadeShapeType[shape]
 			,
          "Compound"
          ,
          TestID -> "OpenCascadeLink_Docs_BooleanOperations-20200311-"
           <> operation <> "-ShapeType" <> 
            StringJoin["-" <> ToString[#] & /@ Keys[shapeList]] <> bugID
          ];
         Test[
             bmesh = OpenCascadeShapeSurfaceMeshToBoundaryMesh[shape];
             groups = bmesh["BoundaryElementMarkerUnion"];
             temp = Most[Range[0, 1, 1/(Length[groups])]];
             colors = ColorData["BrightBands"][#] & /@ temp;
             checkGraphicsRendering[Head, bmesh["Wireframe"["MeshElementStyle" -> FaceForm /@ colors]]]
             ,
             {Graphics3D, "Rendering Errors" -> {}}
             ,
             TestID -> "OpenCascadeLink_Docs_BooleanOperations-20200311-"
              <> operation <> "-Rendering" <> 
               StringJoin["-" <> ToString[#] & /@ Keys[shapeList]] <> bugID
         ];
     ]
     
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
	TestID->"OpenCascadeLink_Docs_BooleanOperations-20200310-J8W7M2-bug-389911"
]

TestRequirement[
 	(* Requires the following tests to be run based on the status of the sanity test *)
 	FailureMode[sanityCheck] === "Success"
]


(* Boolean operations *)

(* excludes SphercialShell since the resulting region may be too complicated *)
combinationsIndices = Subsets[Drop[Range[Length[solids]], 
    Flatten[Position[Keys[solids], SphericalShell]]], {2}];
combinations = solids[[#]] & /@ combinationsIndices;
 
(* Difference *)
MapIndexed[
  boolOperationTest[#, "Difference"] &,
  combinations]


(* Union *)
 MapIndexed[
  boolOperationTest[#, "Union"] &,
  combinations]

(* Intersection *)
bugIDIntersection = <|{Ball, Ellipsoid} -> "-bug-390059"|>;

 MapIndexed[
  boolOperationTest[#, "Intersection", 
  	If[KeyExistsQ[bugIDIntersection, Keys[#]], Lookup[bugIDIntersection,Key[Keys[#]]], ""]] &,
  combinations]

EndRequirement[]

ClearAll["Global`*"]
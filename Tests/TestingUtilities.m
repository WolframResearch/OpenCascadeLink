(* Wolfram Language package *)

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
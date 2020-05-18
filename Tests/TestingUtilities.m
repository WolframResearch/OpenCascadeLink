(* Wolfram Language package *)

 boolOperationTest[shapeAssoc_Association, operation_, bugID_ : ""] :=
     Block[ {shape, bmesh, groups, temp, colors, isEmpty = False, res},
         Test[
             shape = Switch[operation,
               "Difference",
               isEmpty = (Head[RegionDifference @@ shapeAssoc] === EmptyRegion);
               OpenCascadeShapeDifference @@ (OpenCascadeShape /@ shapeAssoc),
               "Union",
               OpenCascadeShapeUnion @@ (OpenCascadeShape /@ shapeAssoc),
               "Intersection",
               isEmpty = (Head[RegionIntersection @@ shapeAssoc] === EmptyRegion);
               OpenCascadeShapeIntersection @@ (OpenCascadeShape /@ shapeAssoc),
               True,
               Return[$Failed]
               ];
             (res = (OpenCascadeShapeType[shape] === "Compound")) || {shapeAssoc, res}
             ,
             True
             ,
             TestID -> "OpenCascadeLink_Docs_BooleanOperations-20200311-"
              <> operation <> "-ShapeType" <> 
               StringJoin["-" <> ToString[#] & /@ Keys[shapeAssoc]] <> bugID
         ];
         
         Test[
         	 (* OpenCascadeShapeSurfaceMeshToBoundaryMesh on Empty regions will return $Failed *)
         	 bmesh = OpenCascadeShapeSurfaceMeshToBoundaryMesh[shape];
         	 ( res = (If[isEmpty
         	 	 ,
         	 	 bmesh
	             ,
	             groups = bmesh["BoundaryElementMarkerUnion"];
	             temp = Most[Range[0, 1, 1/(Length[groups])]];
	             colors = ColorData["BrightBands"][#] & /@ temp;
	             checkGraphicsRendering[Head, bmesh["Wireframe"["MeshElementStyle" -> FaceForm /@ colors]]]
         	 ]) === If[isEmpty
             	,
             	$Failed
             	,
             	{Graphics3D, "Rendering Errors" -> {}}]) || {shapeAssoc, res}
             ,
             True
             ,
             TestID -> "OpenCascadeLink_Docs_BooleanOperations-20200311-"
              <> operation <> "-Rendering" <> 
               StringJoin["-" <> ToString[#] & /@ Keys[shapeAssoc]] <> bugID
         ];
     ]
(* Wolfram Language package *)

boolOperationTest[shapeAssoc_Association, operation_String, bugID_ : ""] :=
    With[ {timeConstraint = 20, rOp = Symbol["Region"<>operation], 
            ocOp = Symbol["OpenCascadeShape"<>operation]},
        {compoundRegion = TimeConstrained[rOp @@ shapeAssoc, timeConstraint]},
        {compoundRegion = If[ Head[compoundRegion] === rOp,
                              TimeConstrained[rOp @@ (DiscretizeRegion /@ shapeAssoc), timeConstraint],
                              compoundRegion
                          ]},
        {isEmpty = (Head[compoundRegion] === EmptyRegion), 
        dim = TimeConstrained[RegionDimension[compoundRegion], timeConstraint]},
        {dim = If[ NumericQ[dim],
                   dim,
                   Min[RegionDimension /@ shapeAssoc]
               ]},
        Block[ {openCascadeShapes, shape, bmesh, groups, temp, colors, result, head, solids},
            TestMatch[
            	openCascadeShapes = OpenCascadeShape /@ shapeAssoc;
                shape = ocOp[Sequence @@ openCascadeShapes];
                numOfSolids = OpenCascadeShapeNumberOfSolids[shape];
                solids = OpenCascadeShapeSolids[shape];
                bmesh = OpenCascadeShapeSurfaceMeshToBoundaryMesh[shape];
                
                If[!FreeQ[openCascadeShapes, $Failed], 
                	(* If one of the shapes fails to convert, check if subsequent operations return unevaluated *)
                	(MatchQ[shape, _ocOp] && Head[bmash] === OpenCascadeShapeSurfaceMeshToBoundaryMesh) ||
                	<|"Error" -> "One of the shapes fails to convert. Expecting OpenCascadeShape and OpenCascadeShapeSurfaceMeshToBoundaryMesh to fail",
                	"OpenCascadeShape" -> shape,
                	"OpenCascadeShapeSurfaceMeshToBoundaryMesh" -> bmesh|>
                	,				
                
	                result = <||>;
	                result["CompoundQ"] = OpenCascadeShapeType[shape] === "Compound";
	
	                (* RegionDimension could return unevaluated. Assuming the compound region is a solid. *)
	                result["OpenCascadeShapeNumberOfSolids"] = If[ TrueQ[ dim <= 2] || isEmpty,
	                                                               numOfSolids === 0 || <|"Actual" -> numOfSolids, "Expected" -> 0|>,
	                                                               TrueQ[numOfSolids > 0] || <|"Actual" -> numOfSolids, "Expected" -> "Greater than 0"|>
	                                                           ];
	                result["OpenCascadeShapeSolids"] = If[ TrueQ[ dim <= 2],
	                                                       solids === {} || <|"Actual" -> solids, "Expected" -> {}|>,
	                                                       AllTrue[solids, OpenCascadeShapeExpressionQ] === True ||
	                                                       <|"Actual" -> solids, "Expected" -> "AllTrue[solids, OpenCascadeShapeExpressionQ]"|>
	                                                   ];
	                result["ElementMesh"] = If[isEmpty,
	                                            bmesh === $Failed || <|"Actual" -> bmesh, "Expected" -> $Failed|>,
	                                            groups = bmesh["BoundaryElementMarkerUnion"];
	                                            temp = Most[Range[0, 1, 1/(Length[groups])]];
	                                            colors = ColorData["BrightBands"][#] & /@ temp;
	                                            (head = Head[bmesh["Wireframe"["MeshElementStyle" -> FaceForm /@ colors]]]) === Graphics3D
	                                            ||
	                                            <|"Actual" -> head, "Expected" -> Graphics3D|>
	                                        ];
	                result]
                ,
                True | <| "CompoundQ" -> True, "OpenCascadeShapeNumberOfSolids" -> True,
                    "OpenCascadeShapeSolids" -> True, "ElementMesh" -> True |>
                ,
                TestID -> "OpenCascadeLink_Docs_BooleanOperations-20200311-"
                  <> operation <> "-ShapeType" <> 
                   StringJoin["-" <> ToString[#] & /@ Keys[shapeAssoc]] <> "-bug-401678" <> bugID
            ];
        ]
    ]

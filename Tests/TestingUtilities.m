(* Wolfram Language package *)

(* Utility functions *)

Options[maskedQTest] = {"Level" -> 0, "Operation" -> Identity};
(* "Level": the level at which the qTest should be applied;
"Operation": The operation applied on the output *)

(* TODO: map out Repeated/RepeatedNull *)
(* TODO: (package) make into package *)

maskedQTest[qTest_, actual_, expected_, opts : OptionsPattern[]] :=
    Block[ {level = OptionValue[maskedQTest, opts, "Level"]},
    	(* Dimension checks *)
    	If[level > 0 && Length[Level[actual, level]] =!= Length[Level[expected, level]],
    		(* TODO: (package) put into message  *)
    		Print["Message: Cannot thread maskedQTest into level " <> ToString[level] 
    				<> ". Resetting Level to 0."];
    		level = 0;
    	];
        MapThread[maskedQTest[qTest, opts], {actual, expected}, level]
    ];
 
maskedQTest[qTest_, opts : OptionsPattern[]][actual_, expected:List[_RepeatedNull | _Repeated]] :=
	Block[{expectedPattern, res},
		If[MatchQ[expected, List[_RepeatedNull]] && SameQ[actual, {}], Return[True]];
		expectedPattern = First[First[expected]];
		res = Map[If[qTest[#, expectedPattern], True, #]&, actual];
		If[TrueQ[And @@ res] && res =!= {},
			True,
			<|"actual" -> DeleteCases[res, True],
			"expected" -> expected|>
		]
	]

maskedQTest[qTest_, opts : OptionsPattern[]][actual_, expected_] :=
	(*Mask matching output*)
    Block[ {operation = OptionValue[maskedQTest, opts, "Operation"]},
        If[ qTest[actual, expected],
            True,
            <|"actual" -> operation[actual], 
            "expected" -> operation[expected]|>,
            {actual, expected}
        ]
    ];

boolOperationTest[shapeAssoc_Association, operation_, bugID_ : ""] :=
     Block[ {shape, bmesh, groups, temp, colors, compoundRegion, isEmpty = False, solidQ, res, dim,
     		timeConstrain = 20},
         Test[
             shape = Switch[operation,
               "Difference",
               compoundRegion = TimeConstrained[RegionDifference @@ shapeAssoc, timeConstrain, $timedOut];
               isEmpty = (Head[compoundRegion] === EmptyRegion);
               OpenCascadeShapeDifference @@ (OpenCascadeShape /@ shapeAssoc),
               "Union",
               compoundRegion = TimeConstrained[RegionUnion @@ shapeAssoc, timeConstrain, $timedOut];
               OpenCascadeShapeUnion @@ (OpenCascadeShape /@ shapeAssoc),
               "Intersection",
               compoundRegion = TimeConstrained[RegionIntersection @@ shapeAssoc, timeConstrain, $timedOut];
               isEmpty = (Head[compoundRegion] === EmptyRegion);
               OpenCascadeShapeIntersection @@ (OpenCascadeShape /@ shapeAssoc),
               True,
               Return[$Failed]
               ];
             solidQ = If[TrueQ[(dim = TimeConstrained[RegionDimension[compoundRegion], timeConstrain]) <= 2]	
             			,
             			<|"RegionDimension" -> dim,
             			"CompoundQ" -> OpenCascadeShapeType[shape] === "Compound",
             			"OpenCascadeShapeSolids" -> maskedQTest[SameQ, OpenCascadeShapeSolids[shape], {}],
             			"OpenCascadeShapeNumberOfSolids" -> maskedQTest[SameQ, OpenCascadeShapeNumberOfSolids[shape], 0]|>
             			,
             			(* RegionDimension could return unevaluated.
             			Assuming the compound region is a solid. *)
             			<|"RegionDimension" -> dim,
             			"CompoundQ" -> OpenCascadeShapeType[shape] === "Compound",
             			"OpenCascadeShapeSolids" -> maskedQTest[MatchQ, OpenCascadeShapeSolids[shape], {_OpenCascadeShapeExpression..}],
 						"OpenCascadeShapeNumberOfSolids" -> maskedQTest[MatchQ, OpenCascadeShapeNumberOfSolids[shape], _?(# > 0 &)]|>];
             iPrint["Type check" <> ToString /@ Keys[shapeAssoc]];
             MatchQ[res = DeleteCases[solidQ, True], <|"RegionDimension" -> _|>] 
            	|| 
 						<|"Shapes" -> shapeAssoc,  
 						"Operation" -> operation,
 						"Result" -> res|>
             ,
             True
             ,
             TestID -> "OpenCascadeLink_Docs_BooleanOperations-20200311-"
              <> operation <> "-ShapeType" <> 
               StringJoin["-" <> ToString[#] & /@ Keys[shapeAssoc]] <> "-bug-401678" <> bugID
         ];
         
         Test[
         	 (* OpenCascadeShapeSurfaceMeshToBoundaryMesh on Empty regions will return $Failed *)
         	 bmesh = OpenCascadeShapeSurfaceMeshToBoundaryMesh[shape];
         	 iPrint["Rendering check" <> ToString /@ Keys[shapeAssoc]];
         	 {shapeAssoc,
	         (maskedQTest[SameQ, #[[1]], #[[2]]])& @
	         If[isEmpty
	         	 	 ,
	         	 	 {bmesh, $Failed}
		             ,
		             {(* Actual output *)
		             groups = bmesh["BoundaryElementMarkerUnion"];
		             temp = Most[Range[0, 1, 1/(Length[groups])]];
		             colors = ColorData["BrightBands"][#] & /@ temp;
		             checkGraphicsRendering[Head, bmesh["Wireframe"["MeshElementStyle" -> FaceForm /@ colors]]],
         	 		 (*Expected output*)
         	 		 {Graphics3D, "Rendering Errors" -> {}}}]
		             }
             ,
             {shapeAssoc, True}
             ,
             TestID -> "OpenCascadeLink_Docs_BooleanOperations-20200311-"
              <> operation <> "-Rendering" <> 
               StringJoin["-" <> ToString[#] & /@ Keys[shapeAssoc]] <> bugID <> "-bug-400507-401678"
         ];
     ]
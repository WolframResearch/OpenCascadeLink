(* Wolfram Language package *)

boolOperationTest[shapeAssoc_Association, operation_String, bugID_ : ""] :=
With[
	{timeConstraint = 20, rOp = Symbol["Region"<>operation], ocOp = Symbol["OpenCascadeShape"<>operation]},
	{compoundRegion = TimeConstrained[rOp @@ shapeAssoc, timeConstraint]},
	{compoundRegion = If[ Head[compundRegion] === rOp, 
						TimeConstrained[rOp @@ (DiscretizeRegion /@ shapeAssoc), timeConstraint],
						compoundRegion]},
	{isEmpty = (Head[compoundRegion] === EmptyRegion), dim = TimeConstrained[RegionDimension[compoundRegion], timeConstraint]},

	Block[ {shape, bmesh, groups, temp, colors, result},

         Test[
			shape = ocOp @@ (OpenCascadeShape /@ shapeAssoc);
			numOfSolids = OpenCascadeShapeNumberOfSolids[shape];
			solids = OpenCascadeShapeSolids[shape];
			bmesh = OpenCascadeShapeSurfaceMeshToBoundaryMesh[shape];

			result = <||>;
			result["CompoundQ"] = OpenCascadeShapeType[shape] === "Compound";

			(* RegionDimension could have returned unevaluated. Assuming the compound region is a solid. *)
			result["OpenCascadeShapeNumberOfSolids"] = If[ TrueQ[ dim <= 2],
				numOfSolids === 0
			,
				TrueQ[numOfSolids > 0]
			];

			result["OpenCascadeShapeSolids"] = If[ TrueQ[ dim <= 2],
				solids === {}
			,
				Union[OpenCascadeShapeExpressionQ/@ solids] === {True}
			];

			result["ElementMesh"] = If[ isEmpty,
				bmesh === $Failed
			,
				groups = bmesh["BoundaryElementMarkerUnion"];
				temp = Most[Range[0, 1, 1/(Length[groups])]];
				colors = ColorData["BrightBands"][#] & /@ temp;
				Head[bmesh["Wireframe"["MeshElementStyle" -> FaceForm /@ colors]]] === Graphics3D
			];

			result
			,
			<| "CompoundQ" -> True, "OpenCascadeShapeNumberOfSolids" -> True,
				"OpenCascadeShapeSolids" -> True, "ElementMesh" -> True |>
			,
			TestID -> "OpenCascadeLink_Docs_BooleanOperations-20200311-"
              <> operation <> "-ShapeType" <> 
               StringJoin["-" <> ToString[#] & /@ Keys[shapeAssoc]] <> "-bug-401678" <> bugID
         ];
     ]
]

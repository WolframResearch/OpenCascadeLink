(* Wolfram Language package *)

(* Constructing solids *)

solidsList = {Ball[{1,0,0}],
	CapsuleShape[{{0,-2,0},{0,0,1}},1],
	Cone[{{0,0,0},{0,0,1}},1],
	Cuboid[{0,0,0},{1,2,3}],
	Cylinder[{{0,0,0},{1,2,3}},1/2],
	Ellipsoid[{0,0,0},{{5,2,3},{2,3,2},{3,2,5}}],
	Hexahedron[{{0,0,0},{1,0,0},{2,1,0},{1,1,0},{0,0,1},{1,0,1},{2,1,1},{1,1,1}}],
	Parallelepiped[{0,0,0},{{1,0,0},{1,2,1},{0,1,1}}],
	Prism[{{1,0,1},{0,0,0},{2,0,0},{1,2,1},{0,2,0},{2,2,0}}],
	Polyhedron[{{-(1 + 2 5^Rational[-1, 2])^Rational[1, 2], 0, Root[1 - 20 #^2 + 80 #^4& , 3, 0]}, {(1 + 2 5^Rational[-1, 2])^Rational[1, 2], 0, Root[1 - 20 #^2 + 80 #^4& , 2, 0]}, {Root[1 - 20 #^2 + 80 #^4& , 1, 0], Rational[1, 4] (-3 - 5^Rational[1, 2]), Root[1 - 20 #^2 + 80 #^4& , 3, 0]}, {Root[1 - 20 #^2 + 80 #^4& , 1, 0], Rational[1, 4] (3 + 5^Rational[1, 2]), Root[1 - 20 #^2 + 80 #^4& , 3, 0]}, {(Rational[5, 8] + Rational[11, 8] 5^Rational[-1, 2])^Rational[1, 2], Rational[1, 4] (-1 - 5^Rational[1, 2]), Root[1 - 20 #^2 + 80 #^4& , 3, 0]}, {(Rational[5, 8] + Rational[11, 8] 5^Rational[-1, 2])^Rational[1, 2], Rational[1, 4] (1 + 5^Rational[1, 2]), Root[1 - 20 #^2 + 80 #^4& , 3, 0]}, {Root[1 - 20 #^2 + 80 #^4& , 2, 0], Rational[1, 4] (-1 - 5^Rational[1, 2]), (Rational[5, 8] + Rational[11, 8] 5^Rational[-1, 2])^Rational[1, 2]}, {Root[1 - 20 #^2 + 80 #^4& , 2, 0], Rational[1, 4] (1 + 5^Rational[1, 2]), (Rational[5, 8] + Rational[11, 8] 5^Rational[-1, 2])^Rational[1, 2]}, {Rational[-1, 2] (1 + 2 5^Rational[-1, 2])^Rational[1, 2], Rational[-1, 2], Root[1 - 100 #^2 + 80 #^4& , 1, 0]}, {Rational[-1, 2] (1 + 2 5^Rational[-1, 2])^Rational[1, 2], Rational[1, 2], Root[1 - 100 #^2 + 80 #^4& , 1, 0]}, {(Rational[1, 4] + Rational[1, 2] 5^Rational[-1, 2])^Rational[1, 2], Rational[-1, 2], (Rational[5, 8] + Rational[11, 8] 5^Rational[-1, 2])^Rational[1, 2]}, {(Rational[1, 4] + Rational[1, 2] 5^Rational[-1, 2])^Rational[1, 2], Rational[1, 2], (Rational[5, 8] + Rational[11, 8] 5^Rational[-1, 2])^Rational[1, 2]}, {(Rational[1, 10] (5 + 5^Rational[1, 2]))^Rational[1, 2], 0, Root[1 - 100 #^2 + 80 #^4& , 1, 0]}, {Root[1 - 100 #^2 + 80 #^4& , 1, 0], Rational[1, 4] (-1 - 5^Rational[1, 2]), Root[1 - 20 #^2 + 80 #^4& , 2, 0]}, {Root[1 - 100 #^2 + 80 #^4& , 1, 0], Rational[1, 4] (1 + 5^Rational[1, 2]), Root[1 - 20 #^2 + 80 #^4& , 2, 0]}, {Root[1 - 5 #^2 + 5 #^4& , 1, 0], 0, (Rational[5, 8] + Rational[11, 8] 5^Rational[-1, 2])^Rational[1, 2]}, {Root[1 - 20 #^2 + 80 #^4& , 3, 0], Rational[1, 4] (-1 - 5^Rational[1, 2]), Root[1 - 100 #^2 + 80 #^4& , 1, 0]}, {Root[1 - 20 #^2 + 80 #^4& , 3, 0], Rational[1, 4] (1 + 5^Rational[1, 2]), Root[1 - 100 #^2 + 80 #^4& , 1, 0]}, {(Rational[1, 8] + Rational[1, 8] 5^Rational[-1, 2])^Rational[1, 2], Rational[1, 4] (-3 - 5^Rational[1, 2]), Root[1 - 20 #^2 + 80 #^4& , 2, 0]}, {(Rational[1, 8] + Rational[1, 8] 5^Rational[-1, 2])^Rational[1, 2], Rational[1, 4] (3 + 5^Rational[1, 2]), Root[1 - 20 #^2 + 80 #^4& , 2, 0]}, {0., 0., 0.8879400317589019}, {-0.41857894516247873`, -0.725, -0.29598001058630075`}, {-0.41857894516247873`, 0.725, -0.29598001058630075`}, {0.8371578903249575, 0., -0.29598001058630075`}}, {{15, 10, 9, 14, 1}, {2, 6, 12, 11, 5}, {5, 11, 7, 3, 19}, {11, 12, 8, 16, 7}, {12, 6, 20, 4, 8}, {6, 2, 13, 18, 20}, {2, 5, 19, 17, 13}, {4, 20, 18, 10, 15}, {18, 13, 17, 9, 10}, {17, 19, 3, 14, 9}, {3, 7, 16, 1, 14}, {16, 8, 4, 15, 1}, {22, 23, 24}, {23, 22, 21}, {24, 21, 22}, {21, 24, 23}}],
	Pyramid[{{0,0,0},{2,0,0},{2,2,0},{0,2,0},{1,1,2}}],
	SphericalShell[],
	Tetrahedron[{{0,0,0},{1,0,0},{0,1,0},{0,0,2}}],
	FilledTorus[{1, 1, 1}, {1/2, 1}]};

r1 = TransformedRegion[Cuboid[],RotationTransform[Pi/8,{1,0,0}]];
r2 = TransformedRegion[Cuboid[],RotationTransform[Pi/8,{0,1,0}]];

solids = <|Thread[(Head[#]->#)&/@solidsList],regionUnionPolyhedron -> RegionUnion[r1,r2]|>;

(* Constructing surfaces *)

(* BSplineSurface *)
pts = {{{0.5, 0, -0.5}, {0, 0, -0.5}, {0, 1, -0.5}, {0.5, 1, -0.5}, {1, 1, -0.5}, {1, 0, -0.5}, {0.5, 0, -0.5}}, 
 {{0.5, 0, 0.7}, {0, 0, 0.7}, {0, 1, 0.7}, {0.5, 1, 0.7}, {1, 1, 0.7}, {1, 0, 0.7}, {0.5, 0, 0.7}}, 
 {{0.5, 0, 0.9}, {0, 0, 0.9}, {0, 1, 1.5}, {0.5, 1, 1.5}, {1, 1, 1.5}, {1, 0, 0.9}, {0.5, 0, 0.9}}, 
 {{0.5, -0.1, 1}, {0, -0.1, 1}, {0, 0.5, 2}, {0.5, 0.5, 2}, {1, 0.5, 2}, {1, -0.1, 1}, {0.5, -0.1, 1}}, 
 {{0.5, -0.3, 1}, {0, -0.3, 1}, {0, -0.3, 2}, {0.5, -0.3, 2}, {1, -0.3, 2}, {1, -0.3, 1}, {0.5, -0.3, 1}}, 
 {{0.5, -1.5, 1}, {0, -1.5, 1}, {0, -1.5, 2}, {0.5, -1.5, 2}, {1, -1.5, 2}, {1, -1.5, 1}, {0.5, -1.5, 1}}};
w = {{1,.5,.5,1,.5,.5,1},{1,.5,.5,1,.5,.5,1},{1,.5,.5,1,.5,.5,1},{1,.5,.5,1,.5,.5,1},{1,.5,.5,1,.5,.5,1},{1,.5,.5,1,.5,.5,1}};
uk = {0,0,0,1/4,1/2,3/4,1,1,1};
vk = {0,0,0,1/4,1/2,1/2,3/4,1,1,1};
ud = 2;
vd = 2;
closed = {False,True};
bss = BSplineSurface[pts,SplineKnots->{uk,vk},SplineDegree->{ud,vd},
SplineWeights->w,SplineClosed->closed];

(* Special surfaces *)
additionalSurfaces = <|polygonWithHole -> Polygon[{{0,0,0},{3,0,0},{3,3,0},{0,3,0},{1,1,0},{1,2,0},{2,2,0},{2,1,0}},{1,2,3,4}->{{5,6,7,8}}],
	polygonSelfIntersect -> Polygon[{{0.35, 0.2,0}, {0.9, 0.75,0}, {0.1, 0.55,0}, {0.9, 0.35,0}, {0.42, 0.9,0}}],
	openMesh -> ToBoundaryMesh[ImplicitRegion[-4 y^2-4 x y^2+y^4+4 x z^2+4 x^2 z^2+2 y^2 z^2+z^4==0,{x,y,z}],{{-1,1},{-1,1},{-1,1}}],
	closedMesh -> ToBoundaryMesh[ImplicitRegion[x^6-5 x^4 y+3 x^4 y^2+10 x^2 y^3+3 x^2 y^4-y^5+y^6+z^2<=1,{x,y,z}]]|>;

surfaceList = {(*bss, *)
	Polygon[{{0,0,0},{1,0,0},{1,1,0},{0,1,0}}], 
	Triangle[{{0,0,0},{1,0,0},{1,1,0}}]
	};
surfaces = <|Thread[(Head[#]->#)&/@surfaceList], additionalSurfaces|>;
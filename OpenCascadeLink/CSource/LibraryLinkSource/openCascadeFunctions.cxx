

#include "mathlink.h"
#include "WolframLibrary.h"
#include "openCascadeWolframDLL.h"

#include <TopoDS_Shape.hxx>                                                     
#include <gp_Ax2.hxx>
#include <BRepPrimAPI_MakeBox.hxx>
#include <BRepPrimAPI_MakeCone.hxx>
#include <BRepPrimAPI_MakeCylinder.hxx>
#include <BRepPrimAPI_MakeSphere.hxx>                                           

#include <BRepAlgoAPI_Cut.hxx>
#include <BRepAlgoAPI_Common.hxx>
#include <BRepAlgoAPI_Fuse.hxx>

#include <IMeshData_Status.hxx>
#include <IMeshTools_Parameters.hxx>
#include <BRepMesh_IncrementalMesh.hxx>

#include <BRep_Tool.hxx>                                                        
#include <TopoDS.hxx>                                                           
#include <TopoDS_Face.hxx>                                                      
#include <TopExp_Explorer.hxx>                                                  
#include <Poly_Triangulation.hxx>

#include <StlAPI_Writer.hxx>


extern "C" {

	DLLEXPORT int makeBall(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int makeCone(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int makeCuboid(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int makeCylinder(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);

	DLLEXPORT int makeDifference(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int makeIntersection(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int makeUnion(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);

	DLLEXPORT int makeSurfaceMesh(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int getSurfaceMeshCoordinates(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int getSurfaceMeshElements(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int getSurfaceMeshElementOffsets(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);

	DLLEXPORT int fileOperation(WolframLibraryData libData, MLINK mlp);

}


static int returnZeroLengthArray( WolframLibraryData libData, mint type, MArgument res)
{
	mint dims[1] = {0};
	MTensor resTen;
	int err = libData->MTensor_new( type, 1, dims, &resTen);
	MArgument_setMTensor(res, resTen);
	return err;
}

static int returnRes( MLINK mlp, const char* str1, const char* str2, int res)
{
	if ( str1 != NULL)
		MLReleaseString(mlp, str1);
	if ( str2 != NULL)
		MLReleaseString(mlp, str2);
	return res;
}


DLLEXPORT int makeBall(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res)
{
	mint id = MArgument_getInteger(Args[0]);

	MTensor tenPts = MArgument_getMTensor(Args[1]);
	int type = libData->MTensor_getType(tenPts);
	int rank = libData->MTensor_getRank(tenPts);
	const mint* dims = libData->MTensor_getDimensions(tenPts);

	Standard_Real radius = (Standard_Real) MArgument_getReal(Args[2]);

	TopoDS_Shape *instance = get_ocShapeInstance( id);

	if (instance == NULL || type != MType_Real || rank != 1 || dims[0] != 3) {
		libData->MTensor_disown(tenPts);
		MArgument_setInteger(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	}

	double* rawPts = libData->MTensor_getRealData(tenPts);
    gp_Pnt origin = gp_Pnt(
		(Standard_Real) rawPts[0],
		(Standard_Real) rawPts[1],
		(Standard_Real) rawPts[2]
	);
	libData->MTensor_disown(tenPts);

    TopoDS_Shape shape = BRepPrimAPI_MakeSphere(origin, radius).Shape();

	*instance = shape;

	MArgument_setInteger(res, 0);
	return 0;
}

DLLEXPORT int makeCone(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res)
{
	mint id = MArgument_getInteger(Args[0]);

	MTensor p1 = MArgument_getMTensor(Args[1]);
	int type1 = libData->MTensor_getType(p1);
	int rank1 = libData->MTensor_getRank(p1);
	const mint* dims1 = libData->MTensor_getDimensions(p1);

	MTensor p2 = MArgument_getMTensor(Args[2]);
	int type2 = libData->MTensor_getType(p2);
	int rank2 = libData->MTensor_getRank(p2);
	const mint* dims2 = libData->MTensor_getDimensions(p2);

	Standard_Real r = (Standard_Real) MArgument_getReal(Args[3]);
	Standard_Real h = (Standard_Real) MArgument_getReal(Args[4]);

	TopoDS_Shape *instance = get_ocShapeInstance( id);

	if (instance == NULL || 
			type1 != MType_Real || rank1 != 1 || dims1[0] != 3 ||
			type2 != MType_Real || rank2 != 1 || dims2[0] != 3
		) {
		libData->MTensor_disown(p1);
		libData->MTensor_disown(p2);
		MArgument_setInteger(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	}

	double* rawPts1 = libData->MTensor_getRealData(p1);
    gp_Pnt gp1 = gp_Pnt(
		(Standard_Real) rawPts1[0],
		(Standard_Real) rawPts1[1],
		(Standard_Real) rawPts1[2]
	);
	libData->MTensor_disown(p1);

	double* rawPts2 = libData->MTensor_getRealData(p2);
    gp_Dir gp2 = gp_Dir(
		(Standard_Real) rawPts2[0],
		(Standard_Real) rawPts2[1],
		(Standard_Real) rawPts2[2]
	);
	libData->MTensor_disown(p2);

	gp_Ax2 base = gp_Ax2(gp1, gp2);
    TopoDS_Shape shape = BRepPrimAPI_MakeCone(base, r, 0, h).Shape();

	*instance = shape;

	MArgument_setInteger(res, 0);
	return 0;
}



DLLEXPORT int makeCuboid(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res)
{
	mint id = MArgument_getInteger(Args[0]);

	MTensor p1 = MArgument_getMTensor(Args[1]);
	int type1 = libData->MTensor_getType(p1);
	int rank1 = libData->MTensor_getRank(p1);
	const mint* dims1 = libData->MTensor_getDimensions(p1);

	MTensor p2 = MArgument_getMTensor(Args[2]);
	int type2 = libData->MTensor_getType(p2);
	int rank2 = libData->MTensor_getRank(p2);
	const mint* dims2 = libData->MTensor_getDimensions(p2);

	TopoDS_Shape *instance = get_ocShapeInstance( id);

	if (instance == NULL || 
			type1 != MType_Real || rank1 != 1 || dims1[0] != 3 ||
			type2 != MType_Real || rank2 != 1 || dims2[0] != 3
		) {
		libData->MTensor_disown(p1);
		libData->MTensor_disown(p2);
		MArgument_setInteger(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	}

	double* rawPts1 = libData->MTensor_getRealData(p1);
    gp_Pnt gp1 = gp_Pnt(
		(Standard_Real) rawPts1[0],
		(Standard_Real) rawPts1[1],
		(Standard_Real) rawPts1[2]
	);
	libData->MTensor_disown(p1);

	double* rawPts2 = libData->MTensor_getRealData(p2);
    gp_Pnt gp2 = gp_Pnt(
		(Standard_Real) rawPts2[0],
		(Standard_Real) rawPts2[1],
		(Standard_Real) rawPts2[2]
	);
	libData->MTensor_disown(p2);

    TopoDS_Shape shape = BRepPrimAPI_MakeBox(gp1, gp2).Shape();

	*instance = shape;

	MArgument_setInteger(res, 0);
	return 0;
}

DLLEXPORT int makeCylinder(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res)
{
	mint id = MArgument_getInteger(Args[0]);

	MTensor p1 = MArgument_getMTensor(Args[1]);
	int type1 = libData->MTensor_getType(p1);
	int rank1 = libData->MTensor_getRank(p1);
	const mint* dims1 = libData->MTensor_getDimensions(p1);

	MTensor p2 = MArgument_getMTensor(Args[2]);
	int type2 = libData->MTensor_getType(p2);
	int rank2 = libData->MTensor_getRank(p2);
	const mint* dims2 = libData->MTensor_getDimensions(p2);

	Standard_Real r = (Standard_Real) MArgument_getReal(Args[3]);
	Standard_Real h = (Standard_Real) MArgument_getReal(Args[4]);

	TopoDS_Shape *instance = get_ocShapeInstance( id);

	if (instance == NULL || 
			type1 != MType_Real || rank1 != 1 || dims1[0] != 3 ||
			type2 != MType_Real || rank2 != 1 || dims2[0] != 3
		) {
		libData->MTensor_disown(p1);
		libData->MTensor_disown(p2);
		MArgument_setInteger(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	}

	double* rawPts1 = libData->MTensor_getRealData(p1);
    gp_Pnt gp1 = gp_Pnt(
		(Standard_Real) rawPts1[0],
		(Standard_Real) rawPts1[1],
		(Standard_Real) rawPts1[2]
	);
	libData->MTensor_disown(p1);

	double* rawPts2 = libData->MTensor_getRealData(p2);
    gp_Dir gp2 = gp_Dir(
		(Standard_Real) rawPts2[0],
		(Standard_Real) rawPts2[1],
		(Standard_Real) rawPts2[2]
	);
	libData->MTensor_disown(p2);

	gp_Ax2 base = gp_Ax2(gp1, gp2);
    TopoDS_Shape shape = BRepPrimAPI_MakeCylinder(base, r, h).Shape();

	*instance = shape;

	MArgument_setInteger(res, 0);
	return 0;
}



DLLEXPORT int makeDifference(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res)
{
	mint id  = MArgument_getInteger(Args[0]);
	mint id1 = MArgument_getInteger(Args[1]);
	mint id2 = MArgument_getInteger(Args[2]);

	TopoDS_Shape *instance  = get_ocShapeInstance( id);
	TopoDS_Shape *instance1 = get_ocShapeInstance( id1);
	TopoDS_Shape *instance2 = get_ocShapeInstance( id2);

	if (instance == NULL || instance1 == NULL || instance2 == NULL) {
		MArgument_setInteger(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	}

    TopoDS_Shape shape = BRepAlgoAPI_Cut(*instance1, *instance2).Shape();

	*instance = shape;

	MArgument_setInteger(res, 0);
	return 0;
}

DLLEXPORT int makeIntersection(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res)
{
	mint id  = MArgument_getInteger(Args[0]);
	mint id1 = MArgument_getInteger(Args[1]);
	mint id2 = MArgument_getInteger(Args[2]);

	TopoDS_Shape *instance  = get_ocShapeInstance( id);
	TopoDS_Shape *instance1 = get_ocShapeInstance( id1);
	TopoDS_Shape *instance2 = get_ocShapeInstance( id2);

	if (instance == NULL || instance1 == NULL || instance2 == NULL) {
		MArgument_setInteger(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	}

    TopoDS_Shape shape = BRepAlgoAPI_Common(*instance1, *instance2).Shape();

	*instance = shape;

	MArgument_setInteger(res, 0);
	return 0;
}

DLLEXPORT int makeUnion(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res)
{
	mint id  = MArgument_getInteger(Args[0]);
	mint id1 = MArgument_getInteger(Args[1]);
	mint id2 = MArgument_getInteger(Args[2]);

	TopoDS_Shape *instance  = get_ocShapeInstance( id);
	TopoDS_Shape *instance1 = get_ocShapeInstance( id1);
	TopoDS_Shape *instance2 = get_ocShapeInstance( id2);

	if (instance == NULL || instance1 == NULL || instance2 == NULL) {
		MArgument_setInteger(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	}

    TopoDS_Shape shape = BRepAlgoAPI_Fuse(*instance1, *instance2).Shape();

	*instance = shape;

	MArgument_setInteger(res, 0);
	return 0;
}

DLLEXPORT int makeSurfaceMesh(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res)
{
	mint id = MArgument_getInteger(Args[0]);

	MTensor tenPts1 = MArgument_getMTensor(Args[1]);
	int type1 = libData->MTensor_getType(tenPts1);
	int rank1 = libData->MTensor_getRank(tenPts1);
	const mint* dims1 = libData->MTensor_getDimensions(tenPts1);

	MTensor tenPts2 = MArgument_getMTensor(Args[2]);
	int type2 = libData->MTensor_getType(tenPts2);
	int rank2 = libData->MTensor_getRank(tenPts2);
	const mint* dims2 = libData->MTensor_getDimensions(tenPts2);

	TopoDS_Shape *instance = get_ocShapeInstance( id);

	if (instance == NULL ||
			type1 != MType_Real || rank1 != 1 || dims1[0] != 5 ||
			type2 != MType_Integer || rank2 != 1 || dims2[0] != 6
		) {
		libData->MTensor_disown(tenPts1);
		libData->MTensor_disown(tenPts2);
		MArgument_setInteger(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	}


	IMeshTools_Parameters meshParams;

	double* rawPts1 = libData->MTensor_getRealData(tenPts1);
	if (rawPts1[0] != 0.) meshParams.Angle = (Standard_Real) rawPts1[0];
	if (rawPts1[1] != 0.) meshParams.Deflection = (Standard_Real) rawPts1[1];
	if (rawPts1[2] != 0.) meshParams.AngleInterior = (Standard_Real) rawPts1[2];
	if (rawPts1[3] != 0.) meshParams.DeflectionInterior = (Standard_Real) rawPts1[3];
	if (rawPts1[4] != 0.) {
			meshParams.MinSize = (Standard_Real) rawPts1[4];
	} else {
			meshParams.MinSize = Precision::Confusion();
	}
	libData->MTensor_disown(tenPts1);


	mint* rawPts2 = libData->MTensor_getIntegerData(tenPts2);
	if (rawPts2[0]) {
		meshParams.InParallel = Standard_True;
	} else {
		meshParams.InParallel = Standard_False;
	}

	if (rawPts2[1]) {
		meshParams.Relative = Standard_True;
	} else {
		meshParams.Relative = Standard_False;
	}

	if (rawPts2[2]) {
		meshParams.InternalVerticesMode = Standard_True;
	} else {
		meshParams.InternalVerticesMode = Standard_False;
	}

	if (rawPts2[3]) {
		meshParams.ControlSurfaceDeflection = Standard_True;
	} else {
		meshParams.ControlSurfaceDeflection = Standard_False;
	}

	if (rawPts2[4]) {
		meshParams.CleanModel = Standard_True;
	} else {
		meshParams.CleanModel = Standard_False;
	}

	if (rawPts2[5]) {
		meshParams.AdjustMinSize = Standard_True;
	} else {
		meshParams.AdjustMinSize = Standard_False;
	}
	libData->MTensor_disown(tenPts2);


	BRepMesh_IncrementalMesh Mesh( *instance, 0.01);
	Mesh.Perform();
	const Standard_Integer ok = !Mesh.GetStatusFlags();

	MArgument_setInteger(res, (mint) ok);
	return 0;
}

DLLEXPORT int getSurfaceMeshCoordinates(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res)
{
	MTensor tenPts;
	mint dims[2];
	mint id;
	mint numberOfNodes = 0;
	mint nodeOffset = 0;

	double* rawPts;

	id = MArgument_getInteger(Args[0]);
	TopoDS_Shape *instance = get_ocShapeInstance( id);
	if (instance == NULL) {
		return LIBRARY_FUNCTION_ERROR;
	}

	// calculate total number of the nodes and triangles                          
	for (	TopExp_Explorer anExpSF (*instance, TopAbs_FACE);
			anExpSF.More(); anExpSF.Next()) {

		TopLoc_Location aLoc;
		Handle(Poly_Triangulation) aTriangulation =
			BRep_Tool::Triangulation (TopoDS::Face (anExpSF.Current()), aLoc);

		if ( !aTriangulation.IsNull()) {
			numberOfNodes += aTriangulation->NbNodes ();
		} 
	}

	dims[0] = numberOfNodes;
	dims[1] = 3;// Maybe should use mesh_dim

	if ( dims[0] == 0) {
		return returnZeroLengthArray( libData, MType_Real, res);
	}

	int err = libData->MTensor_new( MType_Real, 2, dims, &tenPts);
	if (err) return err;
	rawPts = libData->MTensor_getRealData( tenPts);

	int pos = 0;
	for (	TopExp_Explorer anExpSF (*instance, TopAbs_FACE);
			anExpSF.More(); anExpSF.Next()) {

		const TopoDS_Shape& aFace = anExpSF.Current();
		TopLoc_Location aLoc;
		Handle(Poly_Triangulation) aTriangulation =
			BRep_Tool::Triangulation (TopoDS::Face (aFace), aLoc);

		const TColgp_Array1OfPnt& aNodes = aTriangulation->Nodes();

		// copy nodes
		gp_Trsf aTrsf = aLoc.Transformation();
		for (	Standard_Integer aNodeIter = aNodes.Lower();
			aNodeIter <= aNodes.Upper(); ++aNodeIter) {

			gp_Pnt aPnt = aNodes (aNodeIter);
			aPnt.Transform (aTrsf);
			pos = dims[1] * (aNodeIter + nodeOffset - 1);
			rawPts[pos    ] = (double) aPnt.X();
			rawPts[pos + 1] = (double) aPnt.Y();
			rawPts[pos + 2] = (double) aPnt.Z();
		}

		nodeOffset += aNodes.Size();
	}

	MArgument_setMTensor(res, tenPts);
	return 0;
}


DLLEXPORT int getSurfaceMeshElements(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res)
{
	MTensor tenEle;
	mint dims[2];
	mint id;
	mint numberOfTriangles = 0;
	mint triangleOffset = 0;
	mint nodeOffset = 0;

	id = MArgument_getInteger(Args[0]);
	TopoDS_Shape *instance = get_ocShapeInstance( id);
	if (instance == NULL) {
		return LIBRARY_FUNCTION_ERROR;
	}

	// calculate total number of triangles                          
	for (TopExp_Explorer anExpSF (*instance, TopAbs_FACE);
		anExpSF.More(); anExpSF.Next()) {

		TopLoc_Location aLoc;
		Handle(Poly_Triangulation) aTriangulation =
			BRep_Tool::Triangulation (TopoDS::Face (anExpSF.Current()), aLoc);
		if ( !aTriangulation.IsNull()) {
			numberOfTriangles += aTriangulation->NbTriangles ();
		}
	}

	dims[0] = numberOfTriangles;
	/* ooc creates linear surface elements */
	dims[1] = 3;

	if ( dims[0] == 0) {
		return returnZeroLengthArray( libData, MType_Integer, res);
	}

	int err = libData->MTensor_new( MType_Integer, 2, dims, &tenEle);
	if (err) return err;
	mint *rawEle = libData->MTensor_getIntegerData( tenEle);

	int pos = 0;
	for (TopExp_Explorer anExpSF (*instance, TopAbs_FACE);
		anExpSF.More(); anExpSF.Next()) {

		const TopoDS_Shape& aFace = anExpSF.Current();
		TopLoc_Location aLoc;
		Handle(Poly_Triangulation) aTriangulation =
			BRep_Tool::Triangulation (TopoDS::Face (aFace), aLoc);

		if (aTriangulation.IsNull()) continue;

		const TColgp_Array1OfPnt& aNodes = aTriangulation->Nodes();
		const Poly_Array1OfTriangle& aTriangles = aTriangulation->Triangles();

		// copy triangles
		const TopAbs_Orientation anOrientation = anExpSF.Current().Orientation();
		for (Standard_Integer aTriIter = aTriangles.Lower();
			aTriIter <= aTriangles.Upper(); ++aTriIter) {

			Poly_Triangle aTri = aTriangles (aTriIter);

			Standard_Integer anId[3];
			aTri.Get (anId[0], anId[1], anId[2]);
			if (anOrientation == TopAbs_REVERSED) {
				// Swap 1, 2.
				Standard_Integer aTmpIdx = anId[1];
				anId[1] = anId[2];
				anId[2] = aTmpIdx;
			}

			// Update nodes according to the offset.
			anId[0] += nodeOffset;
			anId[1] += nodeOffset;
			anId[2] += nodeOffset;
		
			pos = dims[1] * (aTriIter + triangleOffset - 1);
			rawEle[pos    ] = (mint) anId[0];
			rawEle[pos + 1] = (mint) anId[1];
			rawEle[pos + 2] = (mint) anId[2];
		}

		nodeOffset += aNodes.Size();
		triangleOffset += aTriangles.Size();
	}

	MArgument_setMTensor(res, tenEle);
	return 0;
}

DLLEXPORT int getSurfaceMeshElementOffsets(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res)
{
	MTensor tenOffsets;
	mint dims[1];
	mint id;
	mint numberOfOffsets = 0;

	id = MArgument_getInteger(Args[0]);
	TopoDS_Shape *instance = get_ocShapeInstance( id);
	if (instance == NULL) {
		return LIBRARY_FUNCTION_ERROR;
	}

	// calculate total number of triangles                          
	for (TopExp_Explorer anExpSF (*instance, TopAbs_FACE);
		anExpSF.More(); anExpSF.Next()) {

		TopLoc_Location aLoc;
		Handle(Poly_Triangulation) aTriangulation =
			BRep_Tool::Triangulation (TopoDS::Face (anExpSF.Current()), aLoc);
		if ( !aTriangulation.IsNull()) {
			numberOfOffsets += 1;
		}
	}

	dims[0] = numberOfOffsets;

	if ( dims[0] == 0) {
		return returnZeroLengthArray( libData, MType_Integer, res);
	}

	int err = libData->MTensor_new( MType_Integer, 1, dims, &tenOffsets);
	if (err) return err;
	mint *rawOffsets = libData->MTensor_getIntegerData( tenOffsets);

	int pos = 0;
	for (TopExp_Explorer anExpSF (*instance, TopAbs_FACE);
		anExpSF.More(); anExpSF.Next()) {

		const TopoDS_Shape& aFace = anExpSF.Current();
		TopLoc_Location aLoc;
		Handle(Poly_Triangulation) aTriangulation =
			BRep_Tool::Triangulation (TopoDS::Face (aFace), aLoc);

		if (aTriangulation.IsNull()) continue;

		const Poly_Array1OfTriangle& aTriangles = aTriangulation->Triangles();

		rawOffsets[ pos++] = aTriangles.Size();
	}

	MArgument_setMTensor(res, tenOffsets);
	return 0;
}


DLLEXPORT int fileOperation(WolframLibraryData libData, MLINK mlp)
{
	int res = LIBRARY_FUNCTION_ERROR;
	int id;

	int len;

	const char *fName = NULL;
	const char *fType = NULL;

	/* MaxBoundaryCellMeasure */
	double mbcm;

	if ( !MLTestHead( mlp, "List", &len))
		return returnRes(mlp, fName, fType, LIBRARY_FUNCTION_ERROR);

	if ( len != 4)
		return returnRes(mlp, fName, fType, LIBRARY_FUNCTION_ERROR);

	if ( !MLGetInteger( mlp, &id))
		return returnRes(mlp, fName, fType, LIBRARY_FUNCTION_ERROR);

	if ( !MLGetString(mlp, &fName))
		return returnRes(mlp, fName, fType, LIBRARY_FUNCTION_ERROR);

	if ( !MLGetString(mlp, &fType))
		return returnRes(mlp, fName, fType, LIBRARY_FUNCTION_ERROR);

	if ( !MLGetReal( mlp, &mbcm))
		return returnRes(mlp, fName, fType, LIBRARY_FUNCTION_ERROR);

	if ( !MLNewPacket(mlp) )
		return returnRes(mlp, fName, fType, LIBRARY_FUNCTION_ERROR);

	const char* resStr = "True";

	TopoDS_Shape* instance = get_ocShapeInstance(id);
	if ((*instance).IsNull()) {
		resStr = "False";
	}
	else if ( strcmp( fType, "STL") == 0) {
		StlAPI_Writer stl_writer;
		BRepMesh_IncrementalMesh Mesh( *instance, mbcm);
		Mesh.Perform();
		const Standard_Integer success = Mesh.GetStatusFlags();
		if (!success) {
			resStr = "False";
			goto done;
		}
		if ( !stl_writer.Write(*instance, (char*)fName)) {
			resStr = "False";
		}
	}
/*
	else if ( strcmp( fType, "load_poly") == 0) {
		if ( !instance->load_poly( (char*)fName)) {
			resStr = "False";
		}
	}
*/

done:
	if ( MLPutSymbol( mlp, resStr)) {
		res = 0;
	}

	return returnRes(mlp, fName, fType, res);
}



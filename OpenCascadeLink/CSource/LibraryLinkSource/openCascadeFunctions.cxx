

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

#include <BRepMesh_IncrementalMesh.hxx>
#include <StlAPI_Writer.hxx>


extern "C" {

	DLLEXPORT int makeBall(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int makeCone(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int makeCuboid(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int makeCylinder(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);

	DLLEXPORT int makeDifference(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int makeIntersection(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int makeUnion(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);

	DLLEXPORT int fileOperation(WolframLibraryData libData, MLINK mlp);

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


static int returnRes( MLINK mlp, const char* str1, const char* str2, int res)
{
	if ( str1 != NULL)
		MLReleaseString(mlp, str1);
	if ( str2 != NULL)
		MLReleaseString(mlp, str2);
	return res;
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
	if ( MLPutSymbol( mlp, resStr)) {
		res = 0;
	}

	return returnRes(mlp, fName, fType, res);
}



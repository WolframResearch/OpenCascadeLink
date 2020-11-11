

#include "mathlink.h"
#include "WolframLibrary.h"
#include "openCascadeWolframDLL.h"

#include <gp_Ax2.hxx>
#include <gp_Vec.hxx>
#include <gp_Pnt.hxx>
#include <Standard_Integer.hxx>
#include <Standard_Real.hxx>
#include <NCollection_Array1.hxx>
#include <NCollection_Array2.hxx>

#include <TopoDS_Shape.hxx>                                                     
#include <BRepPrimAPI_MakeBox.hxx>
#include <BRepPrimAPI_MakeCone.hxx>
#include <BRepPrimAPI_MakeCylinder.hxx>
#include <BRepPrimAPI_MakeSphere.hxx>                                           
#include <BRepPrimAPI_MakePrism.hxx>
#include <BRepPrimAPI_MakeRevol.hxx>
#include <BRepPrimAPI_MakeTorus.hxx>

#include <BRepAlgoAPI_Cut.hxx>
#include <BRepAlgoAPI_Common.hxx>
#include <BRepAlgoAPI_Fuse.hxx>
#include <BRepAlgoAPI_Defeaturing.hxx>

#include <BRepFilletAPI_MakeFillet.hxx>
#include <BRepFilletAPI_MakeChamfer.hxx>

#include <BRepOffsetAPI_MakeThickSolid.hxx>

#include <BRepBuilderAPI_MakePolygon.hxx>
#include <Geom_BSplineSurface.hxx>	
#include <BRepBuilderAPI_MakeFace.hxx>
#include <BRepBuilderAPI_Sewing.hxx>
#include <BRepBuilderAPI_GTransform.hxx>
#include <BRepBuilderAPI_MakeSolid.hxx>

#include <IMeshData_Status.hxx>
#include <IMeshTools_Parameters.hxx>
#include <BRepMesh_IncrementalMesh.hxx>
#include <BRepTools.hxx>

#include <BRep_Tool.hxx>                                                        
#include <TopoDS.hxx>                                                           
#include <TopoDS_Face.hxx>                                                      
#include <TopExp_Explorer.hxx>                                                  
#include <Poly_Triangulation.hxx>

#include <StlAPI_Writer.hxx>
#include <StlAPI_Reader.hxx>

#include <STEPControl_Reader.hxx>
#include <STEPControl_Writer.hxx>


extern "C" {

	DLLEXPORT int makeBall(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int makeCone(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int makeCuboid(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int makeCylinder(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int makePrism(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int makeTorus(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);

	DLLEXPORT int makeSewing(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int makeRotationalSweep(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int makeLinearSweep(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int makeGeometicTransformation(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);

	DLLEXPORT int makePolygon(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int makeBSplineSurface(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int makeLine(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);

	DLLEXPORT int makeDifference(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int makeIntersection(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int makeUnion(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int makeDefeaturing(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);

	DLLEXPORT int makeFillet(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int makeChamfer(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int makeShelling(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);

	DLLEXPORT int makeSurfaceMesh(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int getSurfaceMeshCoordinates(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int getSurfaceMeshElements(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int getSurfaceMeshElementOffsets(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);

	DLLEXPORT int getShapeType(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);

	DLLEXPORT int getShapeNumberOfSolids(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int getShapeNumberOfFaces(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int getShapeNumberOfEdges(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int getShapeNumberOfVertices(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);

	DLLEXPORT int getShapeSolids(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int getShapeFaces(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int getShapeEdges(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
	DLLEXPORT int getShapeVertices(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);

	DLLEXPORT int fileOperation(WolframLibraryData libData, MLINK mlp);

}

#define ERROR 1

static int returnZeroLengthArray( WolframLibraryData libData, mint type, mint rank, MArgument res)
{
	mint* dims = new mint[rank];
	MTensor resTen;

	for (int i = 0; i < rank; i++) dims[i] = 0;

	int err = libData->MTensor_new( type, rank, dims, &resTen);
	MArgument_setMTensor(res, resTen);
	delete[] dims;
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


DLLEXPORT int makePrism(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res)
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
			type1 != MType_Real || rank1 != 2 || dims1[0] != 3 || dims1[1] != 3 ||
			type2 != MType_Real || rank2 != 2 || dims2[0] != 2 || dims2[1] != 3
		) {
		libData->MTensor_disown(p1);
		libData->MTensor_disown(p2);
		MArgument_setInteger(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	}

	double* rawPts1 = libData->MTensor_getRealData(p1);
    gp_Pnt b1 = gp_Pnt(
		(Standard_Real) rawPts1[0],
		(Standard_Real) rawPts1[1],
		(Standard_Real) rawPts1[2]
	);
    gp_Pnt b2 = gp_Pnt(
		(Standard_Real) rawPts1[3],
		(Standard_Real) rawPts1[4],
		(Standard_Real) rawPts1[5]
	);
    gp_Pnt b3 = gp_Pnt(
		(Standard_Real) rawPts1[6],
		(Standard_Real) rawPts1[7],
		(Standard_Real) rawPts1[8]
	);
	libData->MTensor_disown(p1);

	TopoDS_Wire wire;
	wire = BRepBuilderAPI_MakePolygon(b1, b2, b3, Standard_True).Wire();
	TopoDS_Face base = BRepBuilderAPI_MakeFace(wire, Standard_True); 

	double* rawPts2 = libData->MTensor_getRealData(p2);
    gp_Pnt gp1 = gp_Pnt(
		(Standard_Real) rawPts2[0],
		(Standard_Real) rawPts2[1],
		(Standard_Real) rawPts2[2]
	);
    gp_Pnt gp2 = gp_Pnt(
		(Standard_Real) rawPts2[3],
		(Standard_Real) rawPts2[4],
		(Standard_Real) rawPts2[5]
	);
	libData->MTensor_disown(p2);

	gp_Vec vec = gp_Vec(gp1, gp2);

    TopoDS_Shape shape = BRepPrimAPI_MakePrism(base, vec,
		Standard_True, Standard_True).Shape();

	*instance = shape;

	MArgument_setInteger(res, 0);
	return 0;
}


DLLEXPORT int makeTorus(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res)
{
	mint id = MArgument_getInteger(Args[0]);

	MTensor p1 = MArgument_getMTensor(Args[1]);
	int type1 = libData->MTensor_getType(p1);
	int rank1 = libData->MTensor_getRank(p1);
	const mint* dims1 = libData->MTensor_getDimensions(p1);

	double r1 = MArgument_getReal(Args[2]);
	double r2 = MArgument_getReal(Args[3]);

	double a1 = MArgument_getReal(Args[4]);
	double a2 = MArgument_getReal(Args[5]);
	double angle = MArgument_getReal(Args[6]);

	TopoDS_Shape *instance = get_ocShapeInstance( id);

	if (instance == NULL || type1 != MType_Real || rank1 != 2 ||
		dims1[0] != 2 || dims1[1] != 3)
	{
		libData->MTensor_disown(p1);
		MArgument_setInteger(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	}

	double* rawPts1 = libData->MTensor_getRealData(p1);
    gp_Pnt gp1 = gp_Pnt(
		(Standard_Real) rawPts1[0],
		(Standard_Real) rawPts1[1],
		(Standard_Real) rawPts1[2]
	);
    gp_Dir gpD = gp_Dir(
		(Standard_Real) rawPts1[3],
		(Standard_Real) rawPts1[4],
		(Standard_Real) rawPts1[5]
	);
	libData->MTensor_disown(p1);

	gp_Ax2 axis(gp1, gpD);

    TopoDS_Shape shape = BRepPrimAPI_MakeTorus(axis, r1, r2, a1, a2, angle).Shape();

	*instance = shape;

	MArgument_setInteger(res, 0);
	return 0;
}




DLLEXPORT int makeSewing(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res)
{
	mint id = MArgument_getInteger(Args[0]);

	MTensor p1 = MArgument_getMTensor(Args[1]);
	int type1 = libData->MTensor_getType(p1);
	int rank1 = libData->MTensor_getRank(p1);
	const mint* dims1 = libData->MTensor_getDimensions(p1);

	TopoDS_Shape *instance = get_ocShapeInstance( id);

	if (instance == NULL || type1 != MType_Integer ||
			 rank1 != 1 || dims1[0] < 0) {
		libData->MTensor_disown(p1);
		MArgument_setInteger(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	}

	mint * rawP1 = libData->MTensor_getIntegerData(p1);

	/* add tolerance options */
	BRepBuilderAPI_Sewing sew;
	TopoDS_Shape *anID;
	for (int i = 0; i < dims1[0]; i++) {
		anID = get_ocShapeInstance( rawP1[ i]);
		if (anID->IsNull()) {
			libData->MTensor_disown(p1);
			MArgument_setInteger(res, 0);
			return LIBRARY_FUNCTION_ERROR;
		}

		for (TopExp_Explorer faces (*anID, TopAbs_FACE);
				faces.More(); faces.Next()) {
			sew.Add(TopoDS::Face (faces.Current()));
		}
	}
	libData->MTensor_disown(p1);

	sew.Perform();

	TopoDS_Shape sewedshape  = sew.SewedShape();

	BRepBuilderAPI_MakeSolid shape;
	for (TopExp_Explorer anExpSF (sewedshape, TopAbs_SHELL);
			anExpSF.More(); anExpSF.Next()) {
		shape.Add(TopoDS::Shell (anExpSF.Current()));
	}

	*instance = shape;

	MArgument_setInteger(res, 0);
	return 0;
}


DLLEXPORT int makeRotationalSweep(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res)
{
	mint id = MArgument_getInteger(Args[0]);
	mint id1 = MArgument_getInteger(Args[1]);

	MTensor p1 = MArgument_getMTensor(Args[2]);
	int type1 = libData->MTensor_getType(p1);
	int rank1 = libData->MTensor_getRank(p1);
	const mint* dims1 = libData->MTensor_getDimensions(p1);

	double angle = MArgument_getReal(Args[3]);

	TopoDS_Shape *instance = get_ocShapeInstance( id);
	TopoDS_Shape *anID = get_ocShapeInstance( id1);

	if (instance == NULL || anID == NULL || anID->IsNull() ||
			type1 != MType_Real || rank1 != 2 || dims1[0] != 2 || dims1[1] != 3
		) {
		libData->MTensor_disown(p1);
		MArgument_setInteger(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	}

	double* rawPts1 = libData->MTensor_getRealData(p1);
    gp_Pnt gp1 = gp_Pnt(
		(Standard_Real) rawPts1[0],
		(Standard_Real) rawPts1[1],
		(Standard_Real) rawPts1[2]
	);
    gp_Dir gpD = gp_Dir(
		(Standard_Real) rawPts1[3],
		(Standard_Real) rawPts1[4],
		(Standard_Real) rawPts1[5]
	);
	libData->MTensor_disown(p1);

	/* shape must not contain solids or compund solids */
	TopExp_Explorer exS(*anID, TopAbs_SOLID);
	TopExp_Explorer exC(*anID, TopAbs_COMPSOLID);
	if (exS.More() || exC.More()) {
		MArgument_setInteger(res, -1);
		return 0;
	}

	gp_Ax1 axis(gp1, gpD);
	TopoDS_Shape shape = BRepPrimAPI_MakeRevol(*anID, axis, angle).Shape();

	*instance = shape;

	MArgument_setInteger(res, 0);
	return 0;
}


DLLEXPORT int makeLinearSweep(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res)
{
	mint id = MArgument_getInteger(Args[0]);
	mint id1 = MArgument_getInteger(Args[1]);

	MTensor p1 = MArgument_getMTensor(Args[2]);
	int type1 = libData->MTensor_getType(p1);
	int rank1 = libData->MTensor_getRank(p1);
	const mint* dims1 = libData->MTensor_getDimensions(p1);

	TopoDS_Shape *instance = get_ocShapeInstance( id);
	TopoDS_Shape *anID = get_ocShapeInstance( id1);

	if (instance == NULL || anID == NULL || anID->IsNull() ||
			type1 != MType_Real || rank1 != 2 || dims1[0] != 2 || dims1[1] != 3
		) {
		libData->MTensor_disown(p1);
		MArgument_setInteger(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	}

	double* rawPts1 = libData->MTensor_getRealData(p1);
    gp_Pnt gp1 = gp_Pnt(
		(Standard_Real) rawPts1[0],
		(Standard_Real) rawPts1[1],
		(Standard_Real) rawPts1[2]
	);
    gp_Pnt gp2 = gp_Pnt(
		(Standard_Real) rawPts1[3],
		(Standard_Real) rawPts1[4],
		(Standard_Real) rawPts1[5]
	);
	libData->MTensor_disown(p1);

	/* according to the documentation linear sweeps of solids should work
	 * in the case of a finite sweep (given by a vector), however, I do not
	 * see how this can work 
	 * https://www.opencascade.com/doc/occt-7.4.0/refman/html/class_b_rep_prim_a_p_i___make_prism.html */
	/* shape must not contain solids or compund solids */
	TopExp_Explorer exS(*anID, TopAbs_SOLID);
	TopExp_Explorer exC(*anID, TopAbs_COMPSOLID);
	if (exS.More() || exC.More()) {
		MArgument_setInteger(res, -1);
		return 0;
	}

	gp_Vec vec = gp_Vec(gp1, gp2);
	TopoDS_Shape shape = BRepPrimAPI_MakePrism(*anID, vec).Shape();

	*instance = shape;

	MArgument_setInteger(res, 0);
	return 0;
}

DLLEXPORT int makeGeometicTransformation(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res)
{
	mint id = MArgument_getInteger(Args[0]);
	mint id1 = MArgument_getInteger(Args[1]);

	MTensor p1 = MArgument_getMTensor(Args[2]);
	int type1 = libData->MTensor_getType(p1);
	int rank1 = libData->MTensor_getRank(p1);
	const mint* dims1 = libData->MTensor_getDimensions(p1);

	TopoDS_Shape *instance = get_ocShapeInstance( id);
	TopoDS_Shape *anID = get_ocShapeInstance( id1);

	if (instance == NULL || anID == NULL || anID->IsNull() ||
			type1 != MType_Real || rank1 != 2 ||
			dims1[0] != 3 || dims1[1] != 4)
	{
		libData->MTensor_disown(p1);
		MArgument_setInteger(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	}

	double* rawPts1 = libData->MTensor_getRealData(p1);

	gp_Trsf trsf;
	trsf.SetValues 	(
		(Standard_Real)	rawPts1[0],
		(Standard_Real)	rawPts1[1],
		(Standard_Real)	rawPts1[2],
		(Standard_Real)	rawPts1[3],

		(Standard_Real)	rawPts1[4],
		(Standard_Real)	rawPts1[5],
		(Standard_Real)	rawPts1[6],
		(Standard_Real)	rawPts1[7],

		(Standard_Real)	rawPts1[8],
		(Standard_Real)	rawPts1[9],
		(Standard_Real)	rawPts1[10],
		(Standard_Real)	rawPts1[11] 
	);
	libData->MTensor_disown(p1);

	gp_GTrsf gtrsf(trsf);

	TopoDS_Shape shape = BRepBuilderAPI_GTransform(*anID, gtrsf, Standard_True).Shape();

	*instance = shape;

	MArgument_setInteger(res, 0);
	return 0;
}




DLLEXPORT int makePolygon(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res)
{
	mint id = MArgument_getInteger(Args[0]);

	MTensor p1 = MArgument_getMTensor(Args[1]);
	int type1 = libData->MTensor_getType(p1);
	int rank1 = libData->MTensor_getRank(p1);
	const mint* dims1 = libData->MTensor_getDimensions(p1);

	TopoDS_Shape *instance = get_ocShapeInstance( id);

	if (instance == NULL || type1 != MType_Real ||
		rank1 != 2 || dims1[0] < 3 || dims1[1] != 3) {
		libData->MTensor_disown(p1);
		MArgument_setInteger(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	}

	double* rawPts1 = libData->MTensor_getRealData(p1);
	BRepBuilderAPI_MakePolygon polygon;

	for (int i = 0; i < (dims1[0] * dims1[1]); i = i + 3) {
 	   polygon.Add( gp_Pnt(
			(Standard_Real) rawPts1[i    ],
			(Standard_Real) rawPts1[i + 1],
			(Standard_Real) rawPts1[i + 2]
		));
	}
	polygon.Close();
	libData->MTensor_disown(p1);

	if (!polygon.IsDone()) {
		/* this leaves *instance undefined */
		MArgument_setInteger(res, ERROR);
		return 0;
	}

	BRepBuilderAPI_MakeFace face;
	face = polygon.Wire();
	if (!face.IsDone()) {
		/* this leaves *instance undefined */
		MArgument_setInteger(res, ERROR);
		return 0;
	}

	TopoDS_Shape shape  = face.Shape();

	*instance = shape;

	MArgument_setInteger(res, 0);
	return 0;
}


DLLEXPORT int makeLine(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res)
{
	mint id = MArgument_getInteger(Args[0]);

	MTensor p1 = MArgument_getMTensor(Args[1]);
	int type1 = libData->MTensor_getType(p1);
	int rank1 = libData->MTensor_getRank(p1);
	const mint* dims1 = libData->MTensor_getDimensions(p1);

	TopoDS_Shape *instance = get_ocShapeInstance( id);

	if (instance == NULL || type1 != MType_Real ||
		rank1 != 2 || dims1[0] < 3 || dims1[1] != 3) {
		libData->MTensor_disown(p1);
		MArgument_setInteger(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	}

	double* rawPts1 = libData->MTensor_getRealData(p1);
	BRepBuilderAPI_MakePolygon polygon;

	for (int i = 0; i < (dims1[0] * dims1[1]); i = i + 3) {
 	   polygon.Add( gp_Pnt(
			(Standard_Real) rawPts1[i    ],
			(Standard_Real) rawPts1[i + 1],
			(Standard_Real) rawPts1[i + 2]
		));
	}
	libData->MTensor_disown(p1);

	if (!polygon.IsDone()) {
		/* this leaves *instance undefined */
		MArgument_setInteger(res, ERROR);
		return 0;
	}

	TopoDS_Shape shape  = polygon.Shape();

	*instance = shape;

	MArgument_setInteger(res, 0);
	return 0;
}


/*
 *Geom_BSplineSurface::Geom_BSplineSurface 	(
    	const TColgp_Array2OfPnt &  	Poles,
		const TColStd_Array2OfReal &  	Weights,
		const TColStd_Array1OfReal &  	UKnots,
		const TColStd_Array1OfReal &  	VKnots,
		const TColStd_Array1OfInteger &  	UMults,
		const TColStd_Array1OfInteger &  	VMults,
		const Standard_Integer  	UDegree,
		const Standard_Integer  	VDegree,
		const Standard_Boolean  	UPeriodic = Standard_False,
		const Standard_Boolean  	VPeriodic = Standard_False 
	) 	
 */

DLLEXPORT int makeBSplineSurface(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res)
{
	mint error = 0;
	mint pos;
	mint * mintData;
	mreal * realData;

	mint id = MArgument_getInteger(Args[0]);

	TopoDS_Shape *instance = get_ocShapeInstance( id);
	if (instance == NULL) {
		MArgument_setInteger(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	} 

	MTensor poles = MArgument_getMTensor(Args[1]);
	int type1 = libData->MTensor_getType(poles);
	int rank1 = libData->MTensor_getRank(poles);
	const mint* dims1 = libData->MTensor_getDimensions(poles);
	if (type1 != MType_Real || rank1 != 3) {
		libData->MTensor_disown(poles);
		MArgument_setInteger(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	} 
	TColgp_Array2OfPnt Poles(1, dims1[0], 1, dims1[1]);

	realData = libData->MTensor_getRealData(poles);
	pos = 0;
	for (int i = 1; i <= dims1[0]; i++) {
		for (int j = 1; j <= dims1[1]; j++) {
			Poles.SetValue(i, j, gp_Pnt(
				(Standard_Real) realData[pos],
				(Standard_Real) realData[pos + 1],
				(Standard_Real) realData[pos + 2]
			));
			pos += 3;
		}
	}

	MTensor weights = MArgument_getMTensor(Args[2]);
	int type2 = libData->MTensor_getType(weights);
	int rank2 = libData->MTensor_getRank(weights);
	const mint* dims2 = libData->MTensor_getDimensions(weights);
	if (type2 != MType_Real || rank2 != 2) {
		libData->MTensor_disown(poles);
		libData->MTensor_disown(weights);
		MArgument_setInteger(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	} 
	TColStd_Array2OfReal Weights(1, dims2[0], 1, dims2[1]);
	realData = libData->MTensor_getRealData(weights);
	pos = 0;
	for (int i = 1; i <= dims2[0]; i++) {
		for (int j = 1; j <= dims2[1]; j++) {
			Weights.SetValue(i, j, (Standard_Real) realData[pos]);
			pos += 1;
		}
	}

	MTensor uknots = MArgument_getMTensor(Args[3]);
	int type3 = libData->MTensor_getType(uknots);
	int rank3 = libData->MTensor_getRank(uknots);
	const mint* dims3 = libData->MTensor_getDimensions(uknots);
	if (type3 != MType_Real || rank3 != 1) {
		libData->MTensor_disown(poles);
		libData->MTensor_disown(weights);
		libData->MTensor_disown(uknots);
		MArgument_setInteger(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	}
	TColStd_Array1OfReal UKnots(1, dims3[0]);
	realData = libData->MTensor_getRealData(uknots);
	for (int i = 0; i < dims3[0]; i++) {
		UKnots.SetValue(i + 1, (Standard_Real) realData[i]);
	}

	MTensor vknots = MArgument_getMTensor(Args[4]);
	int type4 = libData->MTensor_getType(vknots);
	int rank4 = libData->MTensor_getRank(vknots);
	const mint* dims4 = libData->MTensor_getDimensions(vknots);
	if (type4 != MType_Real || rank4 != 1) {
		libData->MTensor_disown(poles);
		libData->MTensor_disown(weights);
		libData->MTensor_disown(uknots);
		libData->MTensor_disown(vknots);
		MArgument_setInteger(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	}
	TColStd_Array1OfReal VKnots(1, dims4[0]);
	realData = libData->MTensor_getRealData(vknots);
	for (int i = 0; i < dims4[0]; i++) {
		VKnots.SetValue(i + 1, (Standard_Real) realData[i]);
	}

	MTensor umults = MArgument_getMTensor(Args[5]);
	int type5 = libData->MTensor_getType(umults);
	int rank5 = libData->MTensor_getRank(umults);
	const mint* dims5 = libData->MTensor_getDimensions(umults);
	if (type5 != MType_Integer || rank5 != 1) {
		libData->MTensor_disown(poles);
		libData->MTensor_disown(weights);
		libData->MTensor_disown(uknots);
		libData->MTensor_disown(vknots);
		libData->MTensor_disown(umults);
		MArgument_setInteger(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	} 
	TColStd_Array1OfInteger UMults(1, dims5[0]);
	mintData = libData->MTensor_getIntegerData(umults);
	for (int i = 0; i < dims5[0]; i++) {
		UMults.SetValue(i + 1, (Standard_Integer) mintData[i]);
	}

	MTensor vmults = MArgument_getMTensor(Args[6]);
	int type6 = libData->MTensor_getType(vmults);
	int rank6 = libData->MTensor_getRank(vmults);
	const mint* dims6 = libData->MTensor_getDimensions(vmults);
	if (type6 != MType_Integer || rank6 != 1) {
		libData->MTensor_disown(poles);
		libData->MTensor_disown(weights);
		libData->MTensor_disown(uknots);
		libData->MTensor_disown(vknots);
		libData->MTensor_disown(umults);
		libData->MTensor_disown(vmults);
		MArgument_setInteger(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	} 
	TColStd_Array1OfInteger VMults(1, dims6[0]);
	mintData = libData->MTensor_getIntegerData(vmults);
	for (int i = 0; i < dims6[0]; i++) {
		VMults.SetValue(i + 1, (Standard_Integer) mintData[i]);
	}

	const Standard_Integer UDegree = (Standard_Integer) MArgument_getInteger(Args[7]);
	const Standard_Integer VDegree = (Standard_Integer) MArgument_getInteger(Args[8]);

	const Standard_Boolean UPeriodic = (Standard_Boolean) MArgument_getInteger(Args[9]); 
	const Standard_Boolean VPeriodic = (Standard_Boolean) MArgument_getInteger(Args[10]); 

	Handle(Geom_Surface) surface = new Geom_BSplineSurface(
    	Poles,
		Weights,
		UKnots, VKnots,
	 	UMults, VMults,
		UDegree, VDegree,
		UPeriodic, VPeriodic 
	); 

//TopoDS_Shape shape= BRepBuilderAPI_MakeShell(Handle_Geom_BSplineSurface(Surf)).Shape();
//GeomAPI_PointsToBSplineSurface

	Standard_Real tol = Precision::Confusion();
	BRepBuilderAPI_MakeFace face(surface, tol);
	if (!face.IsDone()) {
		/* this leaves *instance undefined */
		MArgument_setInteger(res, ERROR);
		return 0;
	}

	TopoDS_Shape shape  = face.Shape();

	*instance = shape;

	libData->MTensor_disown(poles);
	libData->MTensor_disown(weights);
	libData->MTensor_disown(uknots);
	libData->MTensor_disown(vknots);
	libData->MTensor_disown(umults);
	libData->MTensor_disown(vmults);

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

	if (instance == NULL || instance1 == NULL || instance2 == NULL ||
		instance1->IsNull() || instance2->IsNull())
	{
		MArgument_setInteger(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	}

    BRepAlgoAPI_Cut booleanOP(*instance1, *instance2);

	if (!booleanOP.IsDone() || booleanOP.HasErrors()) {
		MArgument_setInteger(res, ERROR);
		instance = NULL;
	}

	TopoDS_Shape shape = booleanOP.Shape();
	*instance = shape;

	if (shape.IsNull()) {
		MArgument_setInteger(res, ERROR);
		return 0;
	}

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

	if (instance == NULL || instance1 == NULL || instance2 == NULL ||
		instance1->IsNull() || instance2->IsNull())
	{
		MArgument_setInteger(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	}

    BRepAlgoAPI_Common booleanOP(*instance1, *instance2);

	if (!booleanOP.IsDone() || booleanOP.HasErrors()) {
		MArgument_setInteger(res, ERROR);
		instance = NULL;
	}

	TopoDS_Shape shape = booleanOP.Shape();
	*instance = shape;

	if (shape.IsNull()) {
		MArgument_setInteger(res, ERROR);
		return 0;
	}

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

	if (instance == NULL || instance1 == NULL || instance2 == NULL ||
		instance1->IsNull() || instance2->IsNull())
	{
		MArgument_setInteger(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	}

    BRepAlgoAPI_Fuse booleanOP(*instance1, *instance2);

	if (!booleanOP.IsDone() || booleanOP.HasErrors()) {
		MArgument_setInteger(res, ERROR);
		instance = NULL;
	}

	TopoDS_Shape shape = booleanOP.Shape();
	*instance = shape;

	if (shape.IsNull()) {
		MArgument_setInteger(res, ERROR);
		return 0;
	}

	MArgument_setInteger(res, 0);
	return 0;
}


DLLEXPORT int makeDefeaturing(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res)
{

	Standard_Real tol = Precision::Confusion();

	mint id  = MArgument_getInteger(Args[0]);
	mint id1 = MArgument_getInteger(Args[1]);

	/* these are assumed to be sorted */
	MTensor p = MArgument_getMTensor(Args[2]);
	int type = libData->MTensor_getType(p);
	int rank = libData->MTensor_getRank(p);
	const mint* dims = libData->MTensor_getDimensions(p);

	TopoDS_Shape *instance  = get_ocShapeInstance( id);
	TopoDS_Shape *instance1 = get_ocShapeInstance( id1);

	if (instance == NULL || instance1 == NULL || instance1->IsNull() ||
			type != MType_Integer || rank != 1 || dims[0] < 1) {
		libData->MTensor_disown(p);
		MArgument_setInteger(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	}

	mint* indices = libData->MTensor_getIntegerData(p);

	TopTools_ListOfShape lof;
	TopExp_Explorer explore(*instance1, TopAbs_FACE);
	mint i = 0, iter = 0;
    while (explore.More() && (i < dims[0])) {
		if ( indices[i] == iter) {
			TopoDS_Face face = TopoDS::Face(explore.Current());
			lof.Append(face);		
			i++;
		};
		iter++;
		explore.Next();
	}

	BRepAlgoAPI_Defeaturing defeaturing;
	defeaturing.SetShape(*instance1);
	defeaturing.AddFacesToRemove(lof);
	//defeaturing.SetRunParallel();
	//defeaturing.SetToFillHistory();
	defeaturing.Build();
	if (!defeaturing.IsDone()) {
		*instance = *instance1;
		MArgument_setInteger(res, ERROR);
		return 0;
	}

	*instance = defeaturing.Shape();
	MArgument_setInteger(res, 0);
	return 0;
}


DLLEXPORT int makeFillet(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res)
{
	mint id  = MArgument_getInteger(Args[0]);
	mint id1 = MArgument_getInteger(Args[1]);
	double radius = MArgument_getReal(Args[2]);

	/* these are assumed to be sorted */
	MTensor p = MArgument_getMTensor(Args[3]);
	int type = libData->MTensor_getType(p);
	int rank = libData->MTensor_getRank(p);
	const mint* dims = libData->MTensor_getDimensions(p);

	TopoDS_Shape *instance  = get_ocShapeInstance( id);
	TopoDS_Shape *instance1 = get_ocShapeInstance( id1);

	if (instance == NULL || instance1 == NULL || instance1->IsNull() ||
			type != MType_Integer || rank != 1 || dims[0] < 1) {
		libData->MTensor_disown(p);
		MArgument_setInteger(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	}

	mint* indices = libData->MTensor_getIntegerData(p);

	BRepFilletAPI_MakeFillet filleted(*instance1);

	TopExp_Explorer explore(*instance1, TopAbs_EDGE);
	mint i = 0, iter = 0;
    while (explore.More() && (i < dims[0])) {
		if ( indices[i] == iter) {
			filleted.Add(radius, TopoDS::Edge(explore.Current()));
			i++;
		};
		iter++;
		explore.Next();
	}

	filleted.Build();
	if (!filleted.IsDone()) {
		*instance = *instance1;
		MArgument_setInteger(res, ERROR);
		return 0;
	}

	*instance = filleted.Shape();

	MArgument_setInteger(res, 0);
	return 0;
}


DLLEXPORT int makeChamfer(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res)
{
	mint id  = MArgument_getInteger(Args[0]);
	mint id1 = MArgument_getInteger(Args[1]);
	double radius = MArgument_getReal(Args[2]);

	/* these are assumed to be sorted */
	MTensor p = MArgument_getMTensor(Args[3]);
	int type = libData->MTensor_getType(p);
	int rank = libData->MTensor_getRank(p);
	const mint* dims = libData->MTensor_getDimensions(p);

	TopoDS_Shape *instance  = get_ocShapeInstance( id);
	TopoDS_Shape *instance1 = get_ocShapeInstance( id1);

	if (instance == NULL || instance1 == NULL || instance1->IsNull() ||
			type != MType_Integer || rank != 1 || dims[0] < 1) {
		libData->MTensor_disown(p);
		MArgument_setInteger(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	}

	mint* indices = libData->MTensor_getIntegerData(p);

	BRepFilletAPI_MakeChamfer chamfered(*instance1);

	TopExp_Explorer explore(*instance1, TopAbs_EDGE);
	mint i = 0, iter = 0;
    while (explore.More() && (i < dims[0])) {
		if ( indices[i] == iter) {
			chamfered.Add(radius, TopoDS::Edge(explore.Current()));
			i++;
		};
		iter++;
		explore.Next();
	}

	chamfered.Build();
	if (!chamfered.IsDone()) {
		*instance = *instance1;
		MArgument_setInteger(res, ERROR);
		return 0;
	}

	*instance = chamfered.Shape();
	MArgument_setInteger(res, 0);
	return 0;
}


DLLEXPORT int makeShelling(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res)
{

	Standard_Real tol = Precision::Confusion();

	mint id  = MArgument_getInteger(Args[0]);
	mint id1 = MArgument_getInteger(Args[1]);
	double thickness = MArgument_getReal(Args[2]);

	/* these are assumed to be sorted */
	MTensor p = MArgument_getMTensor(Args[3]);
	int type = libData->MTensor_getType(p);
	int rank = libData->MTensor_getRank(p);
	const mint* dims = libData->MTensor_getDimensions(p);

	TopoDS_Shape *instance  = get_ocShapeInstance( id);
	TopoDS_Shape *instance1 = get_ocShapeInstance( id1);

	if (instance == NULL || instance1 == NULL || instance1->IsNull() ||
			type != MType_Integer || rank != 1 || dims[0] < 1) {
		libData->MTensor_disown(p);
		MArgument_setInteger(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	}

	mint* indices = libData->MTensor_getIntegerData(p);

	TopTools_ListOfShape lof;
	TopExp_Explorer explore(*instance1, TopAbs_FACE);
	mint i = 0, iter = 0;
    while (explore.More() && (i < dims[0])) {
		if ( indices[i] == iter) {
			TopoDS_Face face = TopoDS::Face(explore.Current());
			lof.Append(face);		
			i++;
		};
		iter++;
		explore.Next();
	}

	BRepOffsetAPI_MakeThickSolid shell;
	shell.MakeThickSolidByJoin(*instance1, lof, thickness, tol);
	if (!shell.IsDone()) {
		*instance = *instance1;
		MArgument_setInteger(res, ERROR);
		return 0;
	}

	*instance = shell.Shape();
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

	/* IncrementalMesh can only deal with shapes that have FACE or EDGE.
	 * If a FACE is present then we also have an EDGE so testing for that
	 * should be enough.*/
	TopExp_Explorer ex(*instance, TopAbs_EDGE);
	if (!ex.More()) {
		libData->MTensor_disown(tenPts1);
		libData->MTensor_disown(tenPts2);
		MArgument_setInteger(res, -1);
		return 0;
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

	/* possibly allow switching this off via an option */
	BRepTools::Clean( *instance);

	BRepMesh_IncrementalMesh Mesh( *instance, meshParams);
	Mesh.Perform();
	const Standard_Integer ok = !Mesh.GetStatusFlags();
	/* TODO: message */

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
	if (instance == NULL || instance->IsNull()) {
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
		return returnZeroLengthArray( libData, MType_Real, 2, res);
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

		if (aTriangulation.IsNull()) continue;

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
	if (instance == NULL || instance->IsNull()) {
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
		return returnZeroLengthArray( libData, MType_Integer, 2, res);
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
	if (instance == NULL || instance->IsNull()) {
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
		return returnZeroLengthArray( libData, MType_Integer, 1, res);
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


DLLEXPORT int getShapeType(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res)
{
	mint id  = MArgument_getInteger(Args[0]);
	mint type = 0;

	TopoDS_Shape *instance  = get_ocShapeInstance( id);

	if (instance == NULL || instance->IsNull()) {
		MArgument_setInteger(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	}

	type = (*instance).ShapeType();

	MArgument_setInteger(res, type);
	return 0;
}


/* the getShapeNumberOf_XYZ could probably be unified */
DLLEXPORT int getShapeNumberOfSolids(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res)
{
	mint id  = MArgument_getInteger(Args[0]);
	mint count = 0;

	TopoDS_Shape *instance  = get_ocShapeInstance( id);

	if (instance == NULL || instance->IsNull()) {
		MArgument_setInteger(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	}

	TopExp_Explorer explore(*instance, TopAbs_SOLID);
    while (explore.More()) {
		count++;
		explore.Next();
	}

	MArgument_setInteger(res, count);
	return 0;
}

/* the getShapeNumberOf_XYZ could probably be unified */
DLLEXPORT int getShapeNumberOfFaces(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res)
{
	mint id  = MArgument_getInteger(Args[0]);
	mint count = 0;

	TopoDS_Shape *instance  = get_ocShapeInstance( id);

	if (instance == NULL || instance->IsNull()) {
		MArgument_setInteger(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	}

	TopExp_Explorer explore(*instance, TopAbs_FACE);
    while (explore.More()) {
		count++;
		explore.Next();
	}

	MArgument_setInteger(res, count);
	return 0;
}

DLLEXPORT int getShapeNumberOfEdges(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res)
{
	mint id  = MArgument_getInteger(Args[0]);
	mint count = 0;

	TopoDS_Shape *instance  = get_ocShapeInstance( id);

	if (instance == NULL || instance->IsNull()) {
		MArgument_setInteger(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	}

	TopExp_Explorer explore(*instance, TopAbs_EDGE);
    while (explore.More()) {
		count++;
		explore.Next();
	}

	MArgument_setInteger(res, count);
	return 0;
}

DLLEXPORT int getShapeNumberOfVertices(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res)
{
	mint id  = MArgument_getInteger(Args[0]);
	mint count = 0;

	TopoDS_Shape *instance  = get_ocShapeInstance( id);

	if (instance == NULL || instance->IsNull()) {
		MArgument_setInteger(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	}

	TopExp_Explorer explore(*instance, TopAbs_VERTEX);
    while (explore.More()) {
		count++;
		explore.Next();
	}

	MArgument_setInteger(res, count);
	return 0;
}


DLLEXPORT int getShapeSolids(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res)
{

	MTensor resTen = MArgument_getMTensor(Args[0]);
	int type = libData->MTensor_getType(resTen);
	int rank = libData->MTensor_getRank(resTen);
	const mint* dims = libData->MTensor_getDimensions(resTen);

	mint id = MArgument_getInteger(Args[1]);
	TopoDS_Shape *instance = get_ocShapeInstance( id);

	/* these are assumed to be sorted */
	MTensor p = MArgument_getMTensor(Args[2]);
	int ptype = libData->MTensor_getType(p);
	int prank = libData->MTensor_getRank(p);
	const mint* pdims = libData->MTensor_getDimensions(p);

	if (instance == NULL || instance->IsNull() ||
		type != MType_Integer || rank != 1 ||
		ptype != MType_Integer || prank != 1)
	{
		libData->MTensor_disown(resTen);
		libData->MTensor_disown(p);
		MArgument_setMTensor(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	}

	mint* solidIDs = libData->MTensor_getIntegerData( p);

	mint* ids = libData->MTensor_getIntegerData( resTen);

	TopExp_Explorer explore(*instance, TopAbs_SOLID);
	int currentSolid = 0;
	for (int i = 0; explore.More(); i++, explore.Next()) {
		if (i > solidIDs[currentSolid]) break;
		if (i < solidIDs[currentSolid]) continue;
		TopoDS_Shape *asolidinstance  = get_ocShapeInstance( ids[currentSolid]);
    	TopoDS_Solid solid = TopoDS::Solid(explore.Current());
		*asolidinstance = solid;
		currentSolid++;
	}

	MArgument_setInteger(res, 0);
	return 0;
}


DLLEXPORT int getShapeFaces(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res)
{

	MTensor resTen = MArgument_getMTensor(Args[0]);
	int type = libData->MTensor_getType(resTen);
	int rank = libData->MTensor_getRank(resTen);
	const mint* dims = libData->MTensor_getDimensions(resTen);

	mint id = MArgument_getInteger(Args[1]);
	TopoDS_Shape *instance = get_ocShapeInstance( id);

	/* these are assumed to be sorted */
	MTensor p = MArgument_getMTensor(Args[2]);
	int ptype = libData->MTensor_getType(p);
	int prank = libData->MTensor_getRank(p);
	const mint* pdims = libData->MTensor_getDimensions(p);

	if (instance == NULL || instance->IsNull() ||
		type != MType_Integer || rank != 1 ||
		ptype != MType_Integer || prank != 1)
	{
		libData->MTensor_disown(resTen);
		libData->MTensor_disown(p);
		MArgument_setMTensor(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	}

	mint* faceIDs = libData->MTensor_getIntegerData( p);

	mint* ids = libData->MTensor_getIntegerData( resTen);

	TopExp_Explorer explore(*instance, TopAbs_FACE);
	int currentFace = 0;
	for (int i = 0; explore.More(); i++, explore.Next()) {
		if (i > faceIDs[currentFace]) break;
		if (i < faceIDs[currentFace]) continue;
		TopoDS_Shape *afaceinstance  = get_ocShapeInstance( ids[currentFace]);
    	TopoDS_Face face = TopoDS::Face(explore.Current());
		*afaceinstance = face;
		currentFace++;
	}

	MArgument_setInteger(res, 0);
	return 0;
}

DLLEXPORT int getShapeEdges(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res)
{

	MTensor resTen = MArgument_getMTensor(Args[0]);
	int type = libData->MTensor_getType(resTen);
	int rank = libData->MTensor_getRank(resTen);
	const mint* dims = libData->MTensor_getDimensions(resTen);

	mint id = MArgument_getInteger(Args[1]);
	TopoDS_Shape *instance = get_ocShapeInstance( id);

	/* these are assumed to be sorted */
	MTensor p = MArgument_getMTensor(Args[2]);
	int ptype = libData->MTensor_getType(p);
	int prank = libData->MTensor_getRank(p);
	const mint* pdims = libData->MTensor_getDimensions(p);

	if (instance == NULL || instance->IsNull() ||
		type != MType_Integer || rank != 1 ||
		ptype != MType_Integer || prank != 1)
	{
		libData->MTensor_disown(resTen);
		libData->MTensor_disown(p);
		MArgument_setMTensor(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	}

	mint* edgeIDs = libData->MTensor_getIntegerData( p);

	mint* ids = libData->MTensor_getIntegerData( resTen);

	TopExp_Explorer explore(*instance, TopAbs_EDGE);
	int currentEdge = 0;
	for (int i = 0; explore.More(); i++, explore.Next()) {
		if (i > edgeIDs[currentEdge]) break;
		if (i < edgeIDs[currentEdge]) continue;
		TopoDS_Shape *aedgeinstance  = get_ocShapeInstance( ids[currentEdge]);
    	TopoDS_Edge edge = TopoDS::Edge(explore.Current());
		*aedgeinstance = edge;
		currentEdge++;
	}

	MArgument_setInteger(res, 0);
	return 0;
}


DLLEXPORT int getShapeVertices(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res)
{

	MTensor resTen = MArgument_getMTensor(Args[0]);
	int type = libData->MTensor_getType(resTen);
	int rank = libData->MTensor_getRank(resTen);
	const mint* dims = libData->MTensor_getDimensions(resTen);

	mint id = MArgument_getInteger(Args[1]);
	TopoDS_Shape *instance = get_ocShapeInstance( id);

	/* these are assumed to be sorted */
	MTensor p = MArgument_getMTensor(Args[2]);
	int ptype = libData->MTensor_getType(p);
	int prank = libData->MTensor_getRank(p);
	const mint* pdims = libData->MTensor_getDimensions(p);

	if (instance == NULL || instance->IsNull() ||
		type != MType_Integer || rank != 1 ||
		ptype != MType_Integer || prank != 1)
	{
		libData->MTensor_disown(resTen);
		libData->MTensor_disown(p);
		MArgument_setMTensor(res, 0);
		return LIBRARY_FUNCTION_ERROR;
	}

	mint* vertexIDs = libData->MTensor_getIntegerData( p);

	mint* ids = libData->MTensor_getIntegerData( resTen);

	TopExp_Explorer explore(*instance, TopAbs_VERTEX);
	int currentVertex = 0;
    for( int i = 0; explore.More(); i++, explore.Next()) {
		if (i > vertexIDs[currentVertex]) break;
		if (i < vertexIDs[currentVertex]) continue;
		TopoDS_Shape *avertexinstance  = get_ocShapeInstance( ids[currentVertex]);
    	TopoDS_Vertex vertex = TopoDS::Vertex(explore.Current());
		*avertexinstance = vertex;
		currentVertex++;
	}

	MArgument_setInteger(res, 0);
	return 0;
}



DLLEXPORT int fileOperation(WolframLibraryData libData, MLINK mlp)
{
	int res = LIBRARY_FUNCTION_ERROR;
	int id;

	int len;

	const char *fName = NULL;
	const char *opType = NULL;

	if ( !MLTestHead( mlp, "List", &len))
		return returnRes(mlp, fName, opType, LIBRARY_FUNCTION_ERROR);

	if ( len != 3)
		return returnRes(mlp, fName, opType, LIBRARY_FUNCTION_ERROR);

	if ( !MLGetInteger( mlp, &id))
		return returnRes(mlp, fName, opType, LIBRARY_FUNCTION_ERROR);

	if ( !MLGetString(mlp, &fName))
		return returnRes(mlp, fName, opType, LIBRARY_FUNCTION_ERROR);

	if ( !MLGetString(mlp, &opType))
		return returnRes(mlp, fName, opType, LIBRARY_FUNCTION_ERROR);

	if ( !MLNewPacket(mlp) )
		return returnRes(mlp, fName, opType, LIBRARY_FUNCTION_ERROR);

	const char* resStr = "True";

	TopoDS_Shape* instance = get_ocShapeInstance(id);

	if ( strcmp( opType, "save_stl") == 0) {
		StlAPI_Writer stl_writer;
		/* there needs to be a mesh in the instance for this to work */
		/* TODO: check? */
		/* ascii is default but can do binary: StlAPI_Writer::ASCIIMode */
		if ( !stl_writer.Write(*instance, (char*)fName)) {
			resStr = "False";
		}
	}
	else if ( strcmp( opType, "save_step") == 0) {
		STEPControl_Writer step_writer;
		step_writer.Transfer(*instance, STEPControl_ManifoldSolidBrep);
		if ( !step_writer.Write((char*)fName)) {
			resStr = "False";
		}
	}
	else if ( strcmp( opType, "save_brep") == 0) {
		if ( !BRepTools::Write(*instance, (char*)fName)) {
			resStr = "False";
		}
	}
	else if ( strcmp( opType, "load_stl") == 0) {
		/* TODO: replace with RWStl::ReadFile() */
		/* https://www.opencascade.com/comment/21450#comment-21450 */
		StlAPI_Reader stl_reader;
		if ( !stl_reader.Read(*instance, (char*)fName)) {
			resStr = "False";
		}
	}
	else if ( strcmp( opType, "load_step") == 0) {
		STEPControl_Reader reader; 
		IFSelect_ReturnStatus status = reader.ReadFile( (char*)fName);
		if( status != IFSelect_RetDone) {
			resStr = "False";
			goto done;
		}

		//reader.PrintCheckLoad(Standard_False, IFSelect_ItemsByEntity); 
		reader.TransferRoots();
		//reader.PrintCheckTransfer (Standard_False, IFSelect_CountByItem);

		TopoDS_Shape shape = reader.OneShape();
		*instance = shape;
	}
	else if ( strcmp( opType, "load_brep") == 0) {
		BRep_Builder builder;
		TopoDS_Shape shape;
		/* TODO: how to check validity? */
		BRepTools::Read(shape, (char*)fName, builder); 
		*instance = shape;
	}
	else {
		resStr = "False";
	}

done:
	if ( MLPutSymbol( mlp, resStr)) {
		res = 0;
	}

	return returnRes(mlp, fName, opType, res);
}



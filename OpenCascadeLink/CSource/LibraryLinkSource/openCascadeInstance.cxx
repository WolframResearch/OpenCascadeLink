/*************************************************************************

        Copyright 1986 through 2010 by Wolfram Research Inc.
        All rights reserved

*************************************************************************/


#include <TopoDS_Shape.hxx>

#include "mathlink.h"
#include "WolframLibrary.h"

#include "openCascadeWolframDLL.h"

#include <unordered_map>

EXTERN_C DLLEXPORT mint WolframLibrary_getVersion( ) ;
EXTERN_C DLLEXPORT mint WolframLibrary_initialize( WolframLibraryData libData);
EXTERN_C DLLEXPORT void WolframLibrary_uninitialize( WolframLibraryData libData); 
EXTERN_C DLLEXPORT int delete_ocShapeInstance(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
EXTERN_C DLLEXPORT int ocShapeInstanceList(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res);
EXTERN_C DLLEXPORT void manage_ocShapeInstance(WolframLibraryData libData, mbool mode, mint id);

DLLEXPORT mint WolframLibrary_getVersion( ) {
	return WolframLibraryVersion;
}

DLLEXPORT mint WolframLibrary_initialize( WolframLibraryData libData) 
{
	mint b = (*libData->registerLibraryExpressionManager)("OpenCascadeShapeManager", manage_ocShapeInstance);
	return b;
}

DLLEXPORT void WolframLibrary_uninitialize( WolframLibraryData libData) 
{
	(void) (*libData->unregisterLibraryExpressionManager)("OpenCascadeShapeManager");
}

static std::unordered_map< mint, TopoDS_Shape *> ocShapeMap;

TopoDS_Shape* get_ocShapeInstance( mint num)
{
	return ocShapeMap[num];
}

TopoDS_Shape* set_ocShapeInstance( mint num, TopoDS_Shape* instance)
{
	return ocShapeMap[num] = instance;
}


DLLEXPORT int delete_ocShapeInstance(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res)
{
	mint id = MArgument_getInteger(Args[0]);
	if ( ocShapeMap[id] == NULL) {
		return LIBRARY_FUNCTION_ERROR;
	}
	return (*libData->releaseManagedLibraryExpression)("OpenCascadeShapeManager", id);
}

DLLEXPORT void manage_ocShapeInstance(WolframLibraryData libData, mbool mode, mint id)
{
	if (mode == 0) {
		TopoDS_Shape *instance = new TopoDS_Shape();
		ocShapeMap[id] = instance;
	} else if (ocShapeMap[id] != NULL) {
		if (!(*ocShapeMap[id]).IsNull()) {
			(*ocShapeMap[id]).Nullify();
		}
		delete ocShapeMap[id];
		ocShapeMap.erase(id);
	}
}

DLLEXPORT int ocShapeInstanceList(WolframLibraryData libData, mint Argc, MArgument *Args, MArgument res)
{
	mint i, num = ocShapeMap.size();
	mint dims[1];
	MTensor resTen;

	dims[0] = num;
	int err = libData->MTensor_new( MType_Integer, 1, dims, &resTen);
	if (err)
		return err;
	mint* elems = libData->MTensor_getIntegerData( resTen);

	std::unordered_map<mint, TopoDS_Shape *>::const_iterator iter = ocShapeMap.begin();
	std::unordered_map<mint, TopoDS_Shape *>::const_iterator end = ocShapeMap.end();
	
	for (i = 0; i < num; i++) {
		elems[i] = iter->first;
		if ( iter != end) {
			iter++;
		}
	}
	MArgument_setMTensor(res, resTen);
	return err;
}


mint call_id = 0;
mint call_nargs = 0;

DLLEXPORT mbool manage_ocShapeCallback(WolframLibraryData libData, mint id, MTensor argtypes)
{
	const mint *dims;

	if (call_id) {
		(*libData->releaseLibraryCallbackFunction)(call_id);
		call_id = 0;
	}
	call_id = id;
	dims = (*libData->MTensor_getDimensions)(argtypes);
	call_nargs = dims[0] - 1;
	return True;
}


EXTERN_C DLLEXPORT int ocUnsuitableCallback( WolframLibraryData libData, mint Argc, MArgument *Args, MArgument Res)
{
	int err = 0;

	if (Argc != call_nargs) return LIBRARY_FUNCTION_ERROR;
	err = (*libData->callLibraryCallbackFunction)(call_id, call_nargs, Args, Args[2]);
	if (err) return err;

	return 0;
}


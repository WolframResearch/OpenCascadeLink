

(* Load the compiler diver package and set the project directory: *)
Needs["CCompilerDriver`"];

BuildOpenCascadeLink[assoc_?AssociationQ] :=
Module[
	{projectDir, buildDir, ocProjectDir, sourceDir, includeDir, targetDir,
	prebuiltLibDir, targetLibDir, systemTargetLibDir, outputName, files,
	libDirName, libDir, libs, occtLink},

	projectDir = assoc["BaseDirectory"];
	buildDir = assoc["BuildDirectory"];

	ocProjectDir = FileNameJoin[{projectDir, "OpenCascadeLink"}];

	(* Set up the directories for source and include files. *)
	sourceDir = 
	  FileNameJoin[{ocProjectDir, "CSource", "LibraryLinkSource"}];
	includeDir = 
	  FileNameJoin[{ocProjectDir, "CSource", "OpenCascadeSource", "include"}];


	(* set up of target build dir *)
	targetDir = FileNameJoin[{buildDir, "OpenCascadeLink"}];
	If[ !DirectoryQ[targetDir], CreateDirectory[targetDir]; ];


	(* Copy the shiped prebuilt OpenCascade libraries into their final place *)
	prebuiltLibDir = FileNameJoin[{projectDir, "PrebuiltLibraries", $SystemID}];
	targetLibDir = FileNameJoin[{targetDir, "LibraryResources"}];
	systemTargetLibDir = FileNameJoin[{targetLibDir, $SystemID}];
	If[ !DirectoryQ[targetLibDir],
		CreateDirectory[targetLibDir];
		CopyDirectory[prebuiltLibDir, systemTargetLibDir];
	];


	(* documentation needs to be done in a separate process *)


	(* set up the output *)
	outputName = "openCascadeWolframDLL";
	files = {"openCascadeFunctions.cxx", "openCascadeInstance.cxx"};
	files = Map[FileNameJoin[{sourceDir, #}] &, files];


	(* set up the library files in the order needed *)
	libDirName = If[$OperatingSystem === "Windows", "import", "lib"];
	libDir = FileNameJoin[{prebuiltLibDir, libDirName}];
	libs = {"TKernel", "TKMath", "TKG2d", "TKG3d", "TKGeomBase", "TKBRep",
	    "TKGeomAlgo", "TKTopAlgo", "TKPrim", "TKBO", "TKShHealing", 
	   "TKBool", "TKHLR", "TKFillet", "TKOffset", "TKFeat", "TKMesh", 
	   "TKXMesh", "TKService", "TKV3d", "TKOpenGl", "TKMeshVS", "TKCDF", 
	   "TKLCAF", "TKCAF", "TKBinL", "TKXmlL", "TKBin", "TKXml", "TKStdL", 
	   "TKStd", "TKTObj", "TKBinTObj", "TKXmlTObj", "TKVCAF", "TKXSBase", 
	   "TKSTEPBase", "TKSTEPAttr", "TKSTEP209", "TKSTEP", "TKIGES", 
	   "TKXCAF", "TKXDEIGES", "TKXDESTEP", "TKSTL", "TKVRML", "TKXmlXCAF",
	    "TKBinXCAF", "TKRWMesh"};


	(* set up system specific compiler options *)
	coptions = Switch[$SystemID,
	  "Linux-x86-64" | "Linux-ARM", "",
	  "MacOSX-x86-64", "-std=c++0x",
	  "Windows-x86-64", "/EHsc",
	  _, $Failed
	  ];


	(* compile the link *)
	occtLink = CreateLibrary[files, outputName
	   , "TargetDirectory" -> systemTargetLibDir 
	   , "CleanIntermediate" -> True
	   , "IncludeDirectories" -> {includeDir}
	   , "LibraryDirectories" -> {libDir}
	   , "Libraries" -> libs
	   (*, "Debug" -> True *)
	   , "CompileOptions" -> coptions
	   (*, "ShellOutputFunction" -> Print *)
	   (*, "ShellCommandFunction" -> Print *)
	   ]

]

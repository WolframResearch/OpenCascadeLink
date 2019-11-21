
(* load the BuildOpenCascadeLink command *)
Get[ FileNameJoin[{DirectoryName[$InputFileName], "BuildOpenCascadeLink.wl"}]];

Print[$InputFileName];
Print[FileNames[All, FileNameDrop[in, -2]]];
Print[FileNames[All, FileNameDrop[in, -3]]];

Print[AntProperty["files_directory"]];

(* where are the sources and where should we build to? *)
setup = Association[{
    "BaseDirectory" -> AntProperty["files_directory"], 
    "BuildDirectory" -> FileNameJoin[{AntProperty["output_directory"], "build"}]
    }];

(* Do the build *)
BuildOpenCascadeLink[setup]


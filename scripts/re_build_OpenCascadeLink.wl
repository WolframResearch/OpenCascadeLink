
(* load the BuildOpenCascadeLink command *)
Get[ FileNameJoin[{DirectoryName[$InputFileName], "BuildOpenCascadeLink.wl"}]];

(* where are the sources and where should we build to? *)
setup = Association[{
    "BaseDirectory" -> FileNameDrop[ $InputFileName, -2], 
    "BuildDirectory" -> AntProperty["files_directory"]
    }];

(* Do the build *)
BuildOpenCascadeLink[setup]


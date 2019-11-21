
(* load the BuildOpenCascadeLink command *)
Get[ FileNameJoin[{$InputFileName, "scripts", "BuildOpenCascadeLink.wl"}]];

(* where are the sources and where should we build to? *)
setup = Association[{
    "BaseDirectory" -> AntProperty["files_directory"], 
    "BuildDirectory" -> FileNameJoin[{AntProperty["output_directory"], "build"}]
    }];

(* Do the build *)
BuildOpenCascadeLink[setup]


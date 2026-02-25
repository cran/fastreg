## flowchart TD
##     identify_paths("Identify register path(s)<br>with list_sas_files(path)")
##     path[/"path<br>[Character vector]"/]
##     output_dir[/"output_dir<br>[Character scalar]"/]
##     chunk_size[/"chunk_size<br>[Integer scalar]"/]
##     convert_register("convert_register()")
##     output[/"Parquet file(s)<br>written to output_dir"/]
## 
##     %% Edges
##     identify_paths -.-> path --> convert_register
##     output_dir & chunk_size --> convert_register
##     convert_register --> output
## 
##     %% Style
##     style identify_paths fill:#FFFFFF, color:#000000, stroke-dasharray: 5 5

## flowchart TD
##     copy_pipeline("use_targets_template()")
##     edit["Edit _targets.R as needed"]
##     run_pipeline("targets::tar_make()")
##     output[/"Parquet file(s)<br>written to directory<br>specified in _targets.R"/]
## 
##     %% Edges
##     copy_pipeline --> edit --> run_pipeline --> output
## 
##     %% Style
##     style edit fill:#FFFFFF, color:#000000, stroke-dasharray: 5 5

## flowchart TD
##     path[/"path<br>[Character scalar]"/]
##     read_register("read_register()")
##     output[/"Output<br>[DuckDB table]"/]
## 
##     %% Edges
##     path --> read_register --> output
## 

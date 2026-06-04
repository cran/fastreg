## flowchart TD
##     opts_project_dir("options()")
##     list_sas_files("list_sas_files()")
##     path[/"path<br>[Character scalar]"/]
##     output_dir[/"output_dir<br>[Character scalar]"/]
##     chunk_size[/"chunk_size<br>[Integer scalar]"/]
##     convert("convert()")
##     output[/"Parquet file(s)<br>written to output_dir"/]
## 
##     %% Edges
##     opts_project_dir --> list_sas_files -->|Select one path| path --> convert
##     output_dir & chunk_size --> convert
##     convert --> output

## flowchart TD
##     copy_pipeline("use_template()")
##     edit["Edit _targets.R as needed"]
##     run_pipeline("targets::tar_make()")
##     output[/"Parquet file(s)<br>written to directory<br>specified in _targets.R"/]
## 
##     %% Edges
##     copy_pipeline --> edit --> run_pipeline --> output
## 
##     %% Style
##     style edit fill:#FFFFFF, color:#000000, stroke-dasharray: 5 5

## flowchart LR
##     path[/"name<br>[Character scalar]"/]
##     read_register("read_register()")
##     output[/"Output<br>[DuckDB table]"/]
## 
##     %% Edges
##     path --> read_register --> output

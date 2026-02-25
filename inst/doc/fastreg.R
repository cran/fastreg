## ----setup--------------------------------------------------------------------
#| include: false
show_tree <- function(dir) {
  withr::with_dir(fs::path_dir(dir), {
    fs::dir_tree(fs::path_file(dir))
  })
}


## ----prepare------------------------------------------------------------------
#| code-fold: true
#| code-summary: "Show setup code"
library(fastreg)

sas_dir <- fs::path_temp("sas-dir")
fs::dir_create(sas_dir)

bef_list <- simulate_register(
  "bef",
  c("", "1999", "1999_1", "2020"),
  n = 1000
)

lmdb_list <- simulate_register(
  "lmdb",
  c("2020", "2021"),
  n = 1000
)

save_as_sas(
  c(bef_list, lmdb_list),
  sas_dir
)


## ----setup-tree---------------------------------------------------------------
#| echo: false
show_tree(sas_dir)


## ----convert-file-------------------------------------------------------------
sas_file <- fs::path(sas_dir, "bef2020.sas7bdat")
output_file_dir <- fs::path_temp("output-file-dir")

convert_file(
  path = sas_file,
  output_dir = output_file_dir
)


## ----output-tree-file---------------------------------------------------------
#| echo: false
show_tree(output_file_dir)


## ----locate-------------------------------------------------------------------
bef_sas_files <- list_sas_files(sas_dir) |>
  stringr::str_subset("bef")
bef_sas_files


## ----convert-register---------------------------------------------------------
output_register_dir <- fs::path_temp("output-register-dir")

convert_register(
  path = bef_sas_files,
  output_dir = output_register_dir
)


## ----output-tree--------------------------------------------------------------
#| echo: false
show_tree(output_register_dir)


## ----use-targets--------------------------------------------------------------
pipeline_dir <- fs::path_temp("pipeline-dir")
fs::dir_create(pipeline_dir)

use_targets_template(path = pipeline_dir)


## ----config-------------------------------------------------------------------
config <- list(
  input_dir = fs::path_temp("sas-dir"),
  output_dir = fs::path(pipeline_dir, "parquet-registers")
)


## ----tar-make-----------------------------------------------------------------
#| eval: false
# targets::tar_make()


## ----edit-and-run-pipeline----------------------------------------------------
#| echo: false
#| eval: !expr rlang::is_installed("targets")
template_content <- readLines(fs::path(pipeline_dir, "_targets.R"))
modified_content <- template_content |>
  stringr::str_replace("/path/to/register/sas/files/directory", config$input_dir) |>
  stringr::str_replace("/path/to/output/directory", config$output_dir)

withr::with_dir(pipeline_dir, {
  writeLines(modified_content, "_targets.R")
  targets::tar_make(callr_function = NULL, reporter = "silent")
})


## ----output-pipeline----------------------------------------------------------
#| eval: !expr rlang::is_installed("targets")
#| echo: false
show_tree(config$output_dir)


## ----read-register------------------------------------------------------------
register <- read_register(output_register_dir)
register


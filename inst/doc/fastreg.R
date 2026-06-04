## ----setup--------------------------------------------------------------------
#| include: false
show_tree <- function(dir) {
  withr::with_dir(fs::path_dir(dir), {
    fs::dir_tree(fs::path_file(dir))
  })
}


## ----options------------------------------------------------------------------
options(
  # With a fake project ID and the temporary directory.
  # Uses `E` rather than `E:` because Windows has issues with a colon in the
  # path when using a temporary location.
  fastreg.project_rawdata_dir = fs::path_temp("E/rawdata/701020/"),
  fastreg.project_workdata_dir = fs::path_temp("E/workdata/701020/parquet-registers/")
)


## ----options-project-profile--------------------------------------------------
#| filename: "Console"
#| eval: false
# usethis::edit_r_profile("project")


## ----options-user-profile-----------------------------------------------------
#| filename: "Console"
#| eval: false
# usethis::edit_r_profile("user")


## ----prepare------------------------------------------------------------------
rawdata_dir <- getOption("fastreg.project_rawdata_dir")
workdata_dir <- getOption("fastreg.project_workdata_dir")

registers_tbl <- fastreg::simulate_registers_with_paths(
  c("bef", "lmdb"),
  c("", "1999", "1999_1", "2020", "2021"),
  n = 1000,
  output_dir = rawdata_dir
)

sas_paths <- registers_tbl |>
  purrr::pwalk(fastreg::write_to_sas) |>
  dplyr::pull(output_path)


## ----setup-tree---------------------------------------------------------------
#| echo: false
# Show how files look relative to "E" to mimic DST
rawdata_dir |>
  # Get to the `E` directory.
  fs::path_dir() |>
  fs::path_dir() |>
  show_tree()


## ----convert-file-------------------------------------------------------------
fastreg::convert(
  path = sas_paths[1],
  output_dir = workdata_dir
)


## ----output-tree-file---------------------------------------------------------
#| echo: false
workdata_dir |>
  # Get to the `E` directory.
  fs::path_dir() |>
  fs::path_dir() |>
  fs::path_dir() |>
  show_tree()


## ----use-targets--------------------------------------------------------------
pipeline_dir <- fs::path(workdata_dir, "conversion_pipeline")
fs::dir_create(pipeline_dir)

fastreg::use_template(path = pipeline_dir)


## ----config-------------------------------------------------------------------
config <- list(
  sas_paths = fastreg::list_sas_files(rawdata_dir),
  output_dir = workdata_dir
)


## ----tar-make-----------------------------------------------------------------
#| eval: false
# targets::tar_make()


## -----------------------------------------------------------------------------
#| label: "manual-conversion"
#| include: false
fastreg::list_sas_files(rawdata_dir) |>
  purrr::walk(\(path) {
    fastreg::convert(path, workdata_dir)
  })


## ----list-files---------------------------------------------------------------
#| filename: "Console"
# For individual files
fastreg::list_parquet_files()
# For datasets (registers with all years).
fastreg::list_parquet_datasets()


## ----read-file----------------------------------------------------------------
bef <- fastreg::read_register("bef")
bef


## ----read-partition-----------------------------------------------------------
fastreg::list_parquet_datasets()[1] |>
  fastreg::read_parquet_dataset()

# Or a single file
fastreg::list_parquet_files()[1] |>
  fastreg::read_parquet_file()


## ----filter-file--------------------------------------------------------------
bef |>
  dplyr::filter(koen == 2) |>
  dplyr::compute()


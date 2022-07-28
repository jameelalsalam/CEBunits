## code to prepare `DATASET` dataset goes here

# Default gwp list
# TODO: put in /data or no?
default_ghg_gwp_list <- readr::read_csv("data-raw/_Lists/ghg-gwp-list.csv",
                                        show_col_types = FALSE)

usethis::use_data(default_ghg_gwp_list, overwrite = TRUE)

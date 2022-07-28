# gwp-convert.R


MMTCO2e_equiv_units <- c("MMTCO2e", "MMT CO2e",
                         "Mt CO2e",  "MtCO2e",
                         "Tg CO2e", "TgCO2e")

kt_equiv_units <- c("kt",
                    "kilotonne", "kilotonnes",
                    "Gigagram", "Gigagrams", "Gg")

# TODO: combine 2 gwp_convert functions into 1.
# TODO: should it really error unrecognized units?

#' Convert GHG emissions values to MMTCO2e
#'
#' @param x tibble with columns as specified in details
#' @param to_unit unit to convert to. Choices are "MMTCO2e" or "kt".
#' @param gwp length 1 character vector, of form "GWP_100_AR4", SAR, TAR, or AR5.
#' @param ghg_gwp_list GWP data to use for converting to CO2e.
#'
#' Input tibble must have columns:
#' 1) Gas in 'gas'
#' 2) Unit in 'unit'
#' 3) Value in 'value'
#'
#' Values already in MMTCO2e are ignored. Errors for unrecognized units.
#' Extra columns carried in result.
#'
#' @return tibble with same specification as `x`
#' @export
gwp_convert_to_MMTCO2e <- function(x,
                                   to_unit = "MMTCO2e",
                                   gwp = "GWP_100_AR4",
                                   ghg_gwp_list = default_ghg_gwp_list,
                                   strict = TRUE) {

  stopifnot(is.data.frame(x))
  stopifnot(all(c("gas", "unit", "value") %in% names(x)))
  if(strict) stopifnot(all(x$unit %in% c(MMTCO2e_equiv_units, kt_equiv_units)))

  gwp_factor <- tibble(
    ghg = x$gas
  ) %>%
    left_join(ghg_gwp_list, by = "ghg") %>%
    pull(!!sym(gwp))

  conv_factor <- case_when(
    x$unit %in% MMTCO2e_equiv_units ~ 1,

    x$unit %in% kt_equiv_units &
      x$gas %in% c("CO2", "CH4", "N2O", "SF6", "NF3", "HFC-23") ~
      gwp_factor * 10^-3,

    TRUE ~ NA_real_
  )

  new_unit <- case_when(
    x$unit %in% MMTCO2e_equiv_units ~ MMTCO2e_equiv_units[[1]],
    x$gas %in% c("CO2", "CH4", "N2O", "SF6", "NF3", "HFC-23") ~ MMTCO2e_equiv_units[[1]],
    x$gas %in% c("HFCs", "PFCs", "Mix", "Total") &
      x$unit %in% kt_equiv_units ~ kt_equiv_units[[1]],
    TRUE ~ NA_character_
  )

  res_data <- tibble(
    gas = x$gas,
    unit = new_unit,
    value = x$value * conv_factor
  )

  # Carry extra columns in x in the result
  x %>%
    mutate(res_data)
}


#' Convert GHG emissions values in MMTCO2e to kt
#'
#' @param x tibble with columns as specified in details
#' @param to_unit unit to convert to. Choices are "MMTCO2e" or "kt".
#' @param gwp length 1 character vector, of form "GWP_100_AR4", SAR, TAR, or AR5.
#' @param to_gwp GWP set to use for converting native values to CO2e.
#'
#' Input tibble must have columns:
#' 1) Gas in 'gas'
#' 2) Unit in 'unit'
#' 3) Value in 'value'
#'
#' Values already in kt and in gas groups are ignored. Errors for unrecognized units.
#' Extra columns carried in result.
#'
#' @return tibble with same specification as `x`
#' @export
gwp_convert_to_kt <- function(x,
                              to_unit = "kt",
                              gwp = "GWP_100_AR4",
                              ghg_gwp_list = default_ghg_gwp_list) {

  stopifnot(is.data.frame(x))
  stopifnot(all(c("gas", "unit", "value") %in% names(x)))
  stopifnot(all(x$unit %in% c(MMTCO2e_equiv_units, kt_equiv_units)))

  gwp_factor <- tibble(
    ghg = x$gas
  ) %>%
    left_join(ghg_gwp_list, by = "ghg") %>%
    pull(!!sym(gwp))

  conv_factor <- case_when(
    x$unit %in% kt_equiv_units ~ 1,

    x$unit %in% MMTCO2e_equiv_units &
      x$gas %in% c("CO2", "CH4", "N2O", "SF6", "NF3") ~
      10^3 / gwp_factor,

    x$unit %in% MMTCO2e_equiv_units &
      x$gas %in% c("HFCs", "PFCs") ~
      1,

    TRUE ~ NA_real_
  )

  new_unit <- case_when(
    x$unit %in% kt_equiv_units ~ kt_equiv_units[[1]],
    x$gas %in% c("CO2", "CH4", "N2O", "SF6", "NF3") ~ kt_equiv_units[[1]],
    x$gas %in% c("HFCs","HFC-23", "PFCs", "Mix", "Total") &
      x$unit %in% MMTCO2e_equiv_units ~ MMTCO2e_equiv_units[[1]],
    TRUE ~ NA_character_
  )

  res_data <- tibble(
    gas = x$gas,
    unit = new_unit,
    value = x$value * conv_factor
  )

  # Carry extra columns in x in the result
  x %>%
    mutate(res_data)
}

#' Aggregate individual gas GHGs to gas groups (HFCs, PFCs)
#'
#' @param gas character vector
#'
#' @export
ghg_to_gasgroup <- function(ghg, ghg_gwp_list = default_ghg_gwp_list) {

  ghg_to_gasgroup_xwalk <- select(ghg_gwp_list, ghg, gas_group)

  res <- tibble(
    ghg = ghg
  ) %>%
    left_join(ghg_to_gasgroup_xwalk, by = "ghg") %>%
    mutate(res = if_else(is.na(gas_group), ghg, gas_group))

  nonmatch <- res %>% filter(is.na(gas_group))

  if(nrow(nonmatch) > 0) {
    nonmatch_distinct <- distinct(nonmatch, ghg)
    unmatched_ghgs <- paste0(nonmatch_distinct$ghg, collapse = ", ")
    rlang::warn(c("Some gases could not be matched to gas groups.",
                  i = glue("Unmatched rows: {nrow(nonmatch)}"),
                  i = glue("Unmatched gases: {unmatched_ghgs}")))
  }

  res$res
}

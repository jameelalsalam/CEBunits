# rewrite-unit-names.R

#' Translate extension names into units package names (incl. custom extensions)
#'
#' @param x character vector of names to translate
#'
rewrite_unit_names <- function(x) {

  # commonly used alternative names and abbreviations re-written in proper units form
  rewrite_abbreviations <- c(
    'dollars' = 'dollar',
    'cents' = 'cent',

    'quads' = 'quadrillion Btu',
    'BkWh' = 'billion kwh',
    'Mt CO2/yr' = 'million tonnes/year', # weight, or forcing?
    'metric tons' = 'tonnes',
    'short tons' = 'tons'
  )

  bound_regex <- function(x) paste0("\\b\\Q", x, "\\E\\b")
  bound_regex_map <- function(x) {
    set_names(x, nm = bound_regex(names(x)))
  }

  str_replace_all(x, bound_regex_map(rewrite_abbreviations))
}

# custom-units.R

#' Code to create needed conversions for user-defined units and map unit names to achieve consistency between all model results
#'
#' To introduce a new base unit or conversion constant, use the command units::install_unit
#' Note that units cannot end or start in numbers, and cannot contain spaces or special characters
#' Instead of creating conversions for each unit, create a conversion constant (or use an existing constant below)
#'
#' @import units
#'
install_extra_units <- function() {

  # Conversion constants
  units::install_unit("dozen", "12 1", "Dozen")
  units::install_unit("hundred", "1e2 1", "Hundred")
  units::install_unit("thousand", "1e3 1", "Thousand")
  units::install_unit("million", "1e6 1", "Million")
  units::install_unit("billion", "1e9 1", "Billion")
  units::install_unit("trillion", "1e12 1", "Trillion")
  units::install_unit("quadrillion", "1e15 1", "Quadrillion")

  # Energy
  units::install_unit(c("kwh", "kWh"), "kilowatthour")

}

remove_extra_units <- function() {

  # Conversion constants
  units::remove_unit("dozen", "Dozen")
  units::remove_unit("hundred", "Hundred")
  units::remove_unit("thousand", "Thousand")
  units::remove_unit("million", "Million")
  units::remove_unit("billion", "Billion")
  units::remove_unit("trillion", "Trillion")
  units::remove_unit("quadrillion", "Quadrillion")

  # Energy
  units::remove_unit(c("kwh", "kWh"))

}

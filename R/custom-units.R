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

  # Emissions
  units::remove_unit("kt") # in default units database, kt is a symbol for knots. After removal, kt is recognized as kilotonnes ('k' prefix with symbol 't' for metric tonnes)

  units::install_unit("CO2e")
  units::install_unit("tCO2e", "t CO2e")
  units::install_unit("MMTCO2e", "1e6 tCO2e")
  units::install_unit("gCO2e", "g CO2e")
  #units::install_unit("MMT", "1e6 tonnes")
  #units::install_unit("MT", "tonnes")

  # under this approach, any of the following can be understood by the system:
  # c("MMTCO2e", "TgCO2e", "MtCO2e", "million tonnes CO2e")


  # Energy
  units::install_unit(c("kwh", "kWh"), "kilowatthour")
  units::install_unit("MMBtu", "1e6 Btu")
  units::install_unit("MMbbl", "1e6 barrels")
  units::install_unit("MMcf", "1e6 ft^3", "MMscf")

  # Economic
  units::install_unit("dollar")
  units::install_unit("cent", def = ".01 dollar")
}

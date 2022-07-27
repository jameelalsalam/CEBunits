
library(units)
devtools::unload("CEBunits")

test_that("custom units error in base units DB", {

  # Energy
  expect_error(set_units(1, "quadrillion Btu"))
  expect_error(set_units(1, "billion kwh"))

  # Emissions
  expect_error(set_units(1, "MMTCO2e"))

  # in normal units DB, kt is knots
  expect_error(set_units(set_units(1000, "tonnes"), "kt"), regexp = "cannot convert")

})

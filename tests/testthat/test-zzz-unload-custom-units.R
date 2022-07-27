
# must occur after all package test files

library(units)
devtools::unload("CEBunits")

test_that("custom units error after unload", {

  # Energy
  expect_error(set_units(1, "quadrillion Btu"))
  expect_error(set_units(1, "billion kwh"))

  # Emissions
  expect_error(set_units(1, "MMTCO2e"))

  # Agriculture
  expect_error(set_units(1, "hundredweight"))

  # in normal units DB, kt is knots
  expect_error(set_units(set_units(1000, "tonnes"), "kt"), regexp = "cannot convert")
})


test_that("base units package units do not error after loading base DB", {
  expect_silent(set_units(1, "watthour"))
  expect_silent(set_units(1, "Btu"))
  expect_silent(set_units(1, "kilowatthour"))
})


library(units)
devtools::unload("CEBunits")

test_that("custom units error after unload", {
  expect_error(set_units(1, "quadrillion Btu"))
  expect_error(set_units(1, "kWh")) # uppercase
  expect_error(set_units(1, "kwh")) # lowercase
  expect_error(set_units(1, "billion kwh"))
})

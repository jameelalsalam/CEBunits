library(units)

test_that("extra units do not error", {

  # Energy
  expect_silent(set_units(1, "quadrillion Btu"))
  expect_silent(set_units(1, "kWh")) # uppercase
  expect_silent(set_units(1, "kwh")) # lowercase
  expect_silent(set_units(1, "billion kwh"))
  expect_silent(set_units(1, "MMBtu"))

  # base prefixes working in tandem with custom unit
  expect_equal(set_units(1, "Mcf") %>% set_units("scf"), set_units(10^3, "scf")) # non-standard use of 'M' to mean thousand here
  expect_equal(set_units(1, "Tcf") %>% set_units("scf"), set_units(10^12, "scf"))

  # Emissions
  expect_silent(set_units(1, "MMTCO2e"))
  em1 <- set_units(1, "MMTCO2e")

  # equivalent alternatives:
  # c("MMTCO2e", "TgCO2e", "MtCO2e", "million tonnes CO2e")
  expect_equal(set_units(1, "TgCO2e") %>% set_units("MMTCO2e"), em1)
  expect_equal(set_units(1, "MtCO2e") %>% set_units("MMTCO2e"), em1)
  expect_equal(set_units(1, "million tonnes CO2e") %>% set_units("MMTCO2e"), em1)


})

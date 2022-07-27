library(units)

test_that("base units package units do not error", {
  expect_silent(set_units(1, "watthour"))
  expect_silent(set_units(1, "Btu"))
  expect_silent(set_units(1, "kilowatthour"))

})


test_that("extra units do not error", {

  # Energy
  expect_silent(set_units(1, "quadrillion Btu"))
  expect_silent(set_units(1, "kWh")) # uppercase
  expect_silent(set_units(1, "kwh")) # lowercase
  expect_silent(set_units(1, "billion kwh"))
  expect_silent(set_units(1, "MMBtu"))

  # Emissions
  expect_silent(set_units(1, "MMTCO2e"))
  em1 <- set_units(1, "MMTCO2e")

  # equivalent alternatives:
  # c("MMTCO2e", "TgCO2e", "MtCO2e", "million tonnes CO2e")
  expect_equal(set_units(1, "TgCO2e") %>% set_units("MMTCO2e"), em1)
  expect_equal(set_units(1, "MtCO2e") %>% set_units("MMTCO2e"), em1)
  expect_equal(set_units(1, "million tonnes CO2e") %>% set_units("MMTCO2e"), em1)


})

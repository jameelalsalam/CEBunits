
library(units)

test_that("unit 'kt' is recognized as kilotonnes, not knots", {
  expect_equal(
    set_units(set_units(1, "kt"), "kilotonnes"),
    set_units(1, "kilotonnes"))
})

test_that("Emissions units", {
  expect_silent(set_units(1, "MMTCO2e"))
  em1 <- set_units(1, "MMTCO2e")

  # equivalent alternatives:
  # c("MMTCO2e", "TgCO2e", "MtCO2e", "million tonnes CO2e")
  expect_equal(set_units(1, "TgCO2e") %>% set_units("MMTCO2e"), em1)
  expect_equal(set_units(1, "MtCO2e") %>% set_units("MMTCO2e"), em1)
  expect_equal(set_units(1, "million tonnes CO2e") %>% set_units("MMTCO2e"), em1)
})

test_that("MMTCO2e unit treated correctly, expressed different ways", {

  m <- set_units(1, "MMTCO2e")

  # deparses nicely
  expect_equal(units::deparse_unit(m), "MMTCO2e")

  # can be expressed many ways:
  conv2mmtco2e <- function(x) as.numeric(set_units(x, "MMTCO2e"))

  expect_equal(conv2mmtco2e(set_units(1, "MMTCO2e")), 1)
  expect_equal(conv2mmtco2e(set_units(1, "MMT CO2e")), 1)
  expect_equal(conv2mmtco2e(set_units(1, "TgCO2e")), 1)
  expect_equal(conv2mmtco2e(set_units(1, "MtCO2e")), 1)
  expect_equal(conv2mmtco2e(set_units(10^6, "tCO2e")), 1)
  expect_equal(conv2mmtco2e(set_units(10^6, "t*CO2e")), 1)
  expect_equal(conv2mmtco2e(set_units(10^6, "t CO2e")), 1)

  expect_equal(
    set_units(set_units(1, "MMT"), "tonnes"),
    set_units(10^6, "tonnes")
  )
})

# test_that("handle_units parses/deparses as expected", {
#
#   df <- tibble::tibble(
#     unit = c("kt", "kilotonnes", "thousand tonnes", "MMTCO2e", "MMT CO2e", "TgCO2e"),
#     value = c(1, 2, 3, 4, 5, 6)
#   )
#
#   # TODO: do we want "thousand tonnes" to simplify also?
#
#   flat_handled_df <- handle_units(df) %>% flatten_units()
#
#   expect_equal(flat_handled_df$unit[1:2], rep("kt", 2))
#   expect_equal(flat_handled_df$unit[4:6], rep("MMTCO2e", 3))
# })

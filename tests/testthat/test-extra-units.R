library(units)

test_that("base units package units do not error", {
  expect_silent(set_units(1, "watthour"))
  expect_silent(set_units(1, "Btu"))
})


test_that("extra units do not error", {
  expect_silent(set_units(1, "quadrillion Btu"))
})


x <- tibble::tibble(
  gas = c("CO2", "CH4", "N2O", "SF6"),
  unit = "kt",
  value = 1,
  datasrc = rep("GHGI", 4)
)

# to MMTCO2e
resx <- gwp_convert_to_MMTCO2e(x, to_unit = "MMTCO2e", gwp = "GWP_100_AR4")

# round-trip to kt:
x2 <- gwp_convert_to_kt(resx, to_unit = "kt", gwp = "GWP_100_AR4")

test_that("basic gwp conversion kt->MMTCO2e", {

  expect_equal(resx$value, c(.001, .025, .298, 22.8))
  expect_equal(resx$unit, rep("MMTCO2e", 4))
  expect_equal(resx$gas, x$gas)
})

test_that("basic gwp conversion MMTCO2e->kt round-trips", {

  expect_equal(x2$value, x$value)
  expect_equal(x2$unit, rep("kt", 4))
  expect_equal(resx$gas, x$gas)
})

test_that("gwp conversion carries extra columns carried", {
  expect_equal(names(x), names(resx))
  expect_equal(names(x), names(x2))
})

test_that("gwp_convert functions pass on extra columns and order", {
  gwpx <- tibble::tibble(
    gas = c("CO2", "CH4", "CH4", "N2O"),
    unit = c("kt", "kt", "kt", "MMTCO2e"),
    meta = c("a", "b", "c", "d"),
    value = c(1, 1, 1, 1),
    datasrc = c("pub1", "pub1", "pub2", "pub3")
  )

  resgwpx <- gwp_convert_to_MMTCO2e(gwpx, to_unit = "MMTCO2e", gwp = "GWP_100_AR4")

  expect_equal(names(resgwpx),
               c("gas", "unit", "meta", "value", "datasrc"))
  expect_equal(resgwpx$datasrc, c("pub1", "pub1", "pub2", "pub3"))
})

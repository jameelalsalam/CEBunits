

suppressPackageStartupMessages(library(tidyverse))

rnd_values <- function(data) {
  mutate(data, value = round(value, digits = 2))
}


test_that("basic unit conversion", {
  x <- tibble::tibble(
    unit = c("inch", "inch", "cm", "kg"),
    value = c(1, 2, 3, 4)
  )

  y <- convert_units(x, from_unit = "inch", to_unit = "cm")

  # inch and cm both converted into cm:
  expect_equal(y$unit[1:3], c("cm", "cm", "cm"))

  # kg should be left as-is, because it is not among from_unit:
  expect_equal(y$unit[[4]], "kg")

  expect_equal(rnd_values(y)$value, c(2.54, 5.08, 3, 4))
})


test_that("convert_units can work in a tidyverse pipeline w/ mutate", {

  x <- tibble::tibble(
    unit = c("inch", "inch", "cm", "kg"),
    value = c(1, 2, 3, 4)
  )

  y1 <- convert_units(x, from_unit = "inch", to_unit = "cm")

  y2 <- x %>%
    mutate(convert_units(tibble(unit, value), from_unit = "inch", to_unit = "cm"))
  expect_equal(y1, y2)

  y3 <- x %>%
    mutate(convert_units(tibble(unit=unit, value=value), from_unit = "inch", to_unit = "cm"))
  expect_equal(y1, y3)
})

test_that("convert_units passes on extra columns and order", {
  dfx <- tibble::tibble(
    unit = c("inch", "inch", "cm", "kg"),
    meta = c("a", "b", "c", "d"),
    value = c(1, 2, 3, 4),
    datasrc = c("ruler", "ruler", "tape", "scale")
  )

  dfxres <- convert_units(dfx, from = "inch", to = "cm")

  expect_equal(names(dfxres),
               c("unit", "meta", "value", "datasrc"))
  expect_equal(dfxres$datasrc, c("ruler", "ruler", "tape", "scale"))
})


test_that("proper convert_units case information", {
  x <- tibble::tibble(
    unit = c("inch", "inch", "cm", "kg"),
    value = c(1, 2, 3, 4)
  )

  expect_equal(
    "full rowwise spec",
    conv_units_case(x, to_unit = c("cm", "cm", "cm", NA)))

  expect_equal(
    "test all input x for conversion to_unit length 1",
    conv_units_case(x, to_unit = "cm"))

  # convert set of from_unit to to_unit length 1:
  expect_equal(
    "convert set of from_unit to to_unit length 1",
    conv_units_case(x, from_unit = "inch", to_unit = "cm"))

  expect_equal(
    "convert set of from_unit to to_unit length 1",
    conv_units_case(x, from_unit = c("cm", "inch"), to_unit = c("cm")))

  # crosswalk
  expect_equal(
    "crosswalk table",
    conv_units_case(x, from_unit = c("cm", "inch"), to_unit = c("cm", "cm")))

  # errors:
  expect_error(conv_units_case(x, from_unit = c("inch", "kg"), to_unit = c("cm", "inch", "pound")))

  expect_error(conv_units_case(x, to_unit = c("cm", "inch")))

})

test_that("different conv_units_case cases work", {
  x <- tibble::tibble(
    unit = c("inch", "inch", "cm", "kg"),
    value = c(1, 2, 3, 4)
  )

  y1 <- convert_units(x, from_unit = "inch", to_unit = "cm")

  # "full rowwise spec":
  z1 <- convert_units(x, to_unit = c("cm", "cm", "cm", NA))
  expect_equal(y1, z1)

  # "test all input x for conversion to_unit length 1":
  z2 <- convert_units(x, to_unit = "cm")
  expect_equal(y1, z2)

  # "convert set of from_unit to to_unit length 1":
  z3 <- convert_units(x, from_unit = "inch", to_unit = "cm")
  expect_equal(y1, z3)
  z4 <- convert_units(x, from_unit = c("cm", "inch"), to_unit = "cm")
  expect_equal(y1, z4)

  # "crosswalk table"
  z5 <- convert_units(x, from_unit = c("cm", "inch"), to_unit = c("cm", "cm"))
  expect_equal(y1, z5)
})

# Different ways of applying the function:

# I don't think that case_when treats df as vector (yet?)
# y3 <- x %>%
#   mutate(
#     case_when(
#       unit == "inch" ~ convert_unit(tibble(unit, value), to_unit = "cm"),
#       TRUE ~ tibble(unit, value)
#       )
#   )

# if_else doesn't yet treat df as a vector:
# y4 <- x %>%
#   mutate(
#     if_else(unit == "inch",
#             convert_unit(tibble(unit=unit, value=value), to_unit = "cm"),
#             tibble(unit=unit, value=value))
#   )
#
# a <- convert_unit(tibble(unit = x$unit, value = x$value), to_unit = "cm")
# b <- tibble(unit = x$unit, value = x$value)
#
# if_else(c(TRUE, FALSE, TRUE, FALSE), a, b)

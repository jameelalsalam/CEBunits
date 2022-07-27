.onLoad <- function(libname, pkgname) {
  packageStartupMessage('CEBunits package startup\n', domain = NULL, appendLF = TRUE)

  # load standard units DB, then custom units
  units::load_units_xml()
  install_extra_units()
}

.onUnload <- function(libpath) {
  units::load_units_xml()
}

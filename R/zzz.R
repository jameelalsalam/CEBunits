.onLoad <- function(libname, pkgname) {
  packageStartupMessage('CEBunits package startup\n', domain = NULL, appendLF = TRUE)

  # install custom units
  install_extra_units()
  # TODO: maybe onunload to ensure only called once per session?
}

.onUnload <- function(libpath) {
  remove_extra_units()
}

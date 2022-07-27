.onLoad <- function(libname, pkgname){
  packageStartupMessage('CEBunits package startup\n', domain = NULL, appendLF = TRUE)
  if(!exists("extra_units_installed")) install_extra_units()
  # TODO: maybe onunload to ensure only called once per session?
}

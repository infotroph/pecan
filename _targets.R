library("targets")
library("tarchetypes")

future::plan(future.callr::callr)


## helpers for processing package metadata

get_pkgname_from_src_dir <- function(pkg_src_dir) {
	pkg_description <- desc::desc(pkg_src_dir)
	unname(pkg_description$get("Package"))
}

get_installed_path <- function(src_dir) {
	pkg_name <- get_pkgname_from_src_dir(src_dir)
	find.package(pkg_name, quiet = TRUE)
}

# TODO: currently ignores Suggests
# adding `dependencies = TRUE` to local_package_deps call
# would need to resolve all dependency cycles first
# (targets stops early when it detects cycles)
list_pecan_deps <- function(path) {
	deps <- remotes::local_package_deps(path)
	deps[grepl("^PEcAn", deps)]
}

list_dep_targets <- function(path) {
	names <- list_pecan_deps(path)
	if (length(names) == 0 || identical(names, "")) {
		return(list())
	}
	rlang::syms(paste("inst", names, sep = "_"))
}


## Target-building wrappers

# All these functions accept `...`, but ignore it
# This allows us to pass dependencies as arguments, so that targets knows they
# need to be installed upstream of the target being processed

install_pkg <- function(path, ...) {
	devtools::install(path, upgrade = FALSE)
	get_installed_path(path)
}

install_if_missing <- function(path, ...) {
	existing <- get_installed_path(path)
	if (length(existing) == 0) {
		existing <- install_pkg(path)
	}
	existing
}

check_dir <- function(path, ...) {
	callr::rscript(
		script = "scripts/check_with_errors.R",
		cmdargs = path,
		env = c("REBUILD_DOCS" = "true", "RUN_TESTS" = "false"))
}

test_dir <- function(path, ...) {
	devtools::test(path, stop_on_failure = TRUE, stop_on_warning = FALSE)
}

build_docs <- function(path, ...) {
	devtools::document(path)
}


## Packages to build

# Candidates: everything that lives in base, models, or modules and is an
# R package (i.e. has a DESCRIPTION file)
pkgdirs <- list.dirs(
	path = c("base", "models", "modules"),
	recursive = FALSE)
pkgdirs <- pkgdirs[file.exists(file.path(pkgdirs, "DESCRIPTION"))]

# ...Well, except these ones, which need further development
# before they'll pass even basic checks
ignored_pkgdirs <- c("models/cable", "modules/data.mining")

pkgs <- tibble::tibble(pkg_dir = pkgdirs[!(pkgdirs %in% ignored_pkgdirs)])
pkgs <- dplyr::mutate(pkgs,
	pkg_name = purrr::map_chr(pkg_dir, get_pkgname_from_src_dir),
	pkg_target = rlang::syms(pkg_name),
	dep_target = rlang::syms(paste("dep", pkg_name, sep = "_")),
	doc_target = rlang::syms(paste("doc", pkg_name, sep = "_")),
	deps = purrr::map(pkg_dir, ~list_dep_targets(.))
)


list(
	tar_eval(
		values = pkgs,
		tar_target(pkg_target, pkg_dir, format = "file")),
	tar_map(
		values = pkgs,
		names = "pkg_name",
		tar_target("dep",
			install_if_missing(pkg_dir, deps),
			cue = tar_cue(depend = FALSE)),
		tar_target("doc", build_docs(pkg_target, dep_target)),
		tar_target("inst",
			install_pkg(pkg_target, doc_target, dep_target),
			format = "file"),
		tar_target("chk", check_dir(pkg_target, dep_target)),
		tar_target("test", test_dir(pkg_target, dep_target)))

)

#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
	args <- c("document", "install")
}

workers <- 7

nm_sym <- data.frame(
	name = c("document", "install", "test", "check"),
	symbol = c("doc_", "inst_", "test_", "chk_"))
arg_patterns <- nm_sym$symbol[nm_sym$name %in% args]
verbatim_args <- args[!(args %in% nm_sym$name)]

targets::tar_make_future(
	names = c(
		starts_with(!!arg_patterns),
		one_of(!!verbatim_args)),
	workers = workers)

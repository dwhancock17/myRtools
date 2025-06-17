
#| eval: false
#| code-fold: true

#' Manage Package Installation and Loading
#'
#' Automatically checks for missing packages, installs them if needed, and loads all requested packages.
#' Provides detailed feedback on the installation and loading process.
#'
#' @param packages Character vector of package names to install and load
#' @param quiet Logical, if TRUE suppresses installation messages (default: FALSE)
#' @return Invisible list containing installation and loading status details
#' @export
#' @examples
#' \dontrun{
#' # Basic usage
#' manage_packages(c("dplyr", "ggplot2"))
#' 
#' # Quiet mode
#' manage_packages(c("gt", "gtsummary"), quiet = TRUE)
#' 
#' # Capture status for programmatic use
#' status <- manage_packages(c("tidyverse", "data.table"))
#' if(status$success_rate < 1) {
#'   warning("Some packages failed to load")
#' }
#' }
manage_packages <- function(packages, quiet = FALSE) {
  # Initialize status tracking
  already_installed <- character(0)
  newly_installed <- character(0)
  failed_installs <- character(0)
  load_failures <- character(0)
  
  for(pkg in packages) {
    # Check if package is already installed
    if(pkg %in% utils::installed.packages()[,"Package"]) {
      already_installed <- c(already_installed, pkg)
    } else {
      # Try to install the package
      if(!quiet) cat("Installing package:", pkg, "...\n")
      
      tryCatch({
        utils::install.packages(pkg, repos = "https://cran.rstudio.com/", quiet = quiet)
        newly_installed <- c(newly_installed, pkg)
      }, error = function(e) {
        failed_installs <<- c(failed_installs, pkg)
        if(!quiet) cat("Failed to install:", pkg, "\n")
      })
    }
  }
  
  # Now try to load all packages
  for(pkg in packages) {
    if(!pkg %in% failed_installs) {
      tryCatch({
        suppressPackageStartupMessages(
          library(pkg, character.only = TRUE, quietly = quiet)
        )
      }, error = function(e) {
        load_failures <<- c(load_failures, pkg)
      })
    }
  }
  
  # Generate status report
  total_packages <- length(packages)
  successful_loads <- total_packages - length(failed_installs) - length(load_failures)
  
  if(!quiet) {
    cat("\n=== PACKAGE MANAGEMENT SUMMARY ===\n")
    cat("Total packages requested:", total_packages, "\n")
    
    if(length(already_installed) > 0) {
      cat("Already installed:", paste(already_installed, collapse = ", "), "\n")
    }
    
    if(length(newly_installed) > 0) {
      cat("Newly installed:", paste(newly_installed, collapse = ", "), "\n")
    }
    
    if(length(failed_installs) > 0) {
      cat("Failed to install:", paste(failed_installs, collapse = ", "), "\n")
    }
    
    if(length(load_failures) > 0) {
      cat("Failed to load:", paste(load_failures, collapse = ", "), "\n")
    }
    
    cat("Successfully loaded:", successful_loads, "out of", total_packages, "packages\n")
    
    if(successful_loads == total_packages) {
      cat("All packages ready for use!\n")
    } else {
      cat("! Some packages may not be available\n")
    }
    cat("=======================================\n\n")
  }
  
  # Return status invisibly for programmatic use
  invisible(list(
    total = total_packages,
    already_installed = already_installed,
    newly_installed = newly_installed,
    failed_installs = failed_installs,
    load_failures = load_failures,
    success_rate = successful_loads / total_packages
  ))
}

#' Quick Data Summary
#'
#' Provides a quick overview of a data frame including dimensions and structure
#'
#' @param data A data frame to summarize
#' @param show_str Logical, whether to show str() output (default: TRUE)
#' @return Invisible NULL, prints summary to console
#' @export
#' @examples
#' \dontrun{
#' quick_summary(mtcars)
#' quick_summary(iris, show_str = FALSE)
#' }
quick_summary <- function(data, show_str = TRUE) {
  cat("=== DATA SUMMARY ===\n")
  cat("Rows:", nrow(data), "| Columns:", ncol(data), "\n")
  cat("Missing values:", sum(is.na(data)), "\n")
  
  if(show_str) {
    cat("\nStructure:\n")
    utils::str(data)
  }
  
  cat("====================\n")
  invisible(NULL)
}

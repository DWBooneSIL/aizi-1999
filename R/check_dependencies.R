# Install any R packages this pipeline needs that aren't already installed.
# Run by hand before the first build: source("R/check_dependencies.R")
# build.R never sources this file. Every step that introduces a new package
# adds its name to required_packages below.

required_packages <- c(
  "tidyverse"
)

missing_packages <- setdiff(required_packages, rownames(installed.packages()))

if (length(missing_packages) > 0) {
  install.packages(missing_packages)
} else {
  message("All required packages are already installed.")
}

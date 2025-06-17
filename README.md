```markdown
# myRtools

Personal R utility functions for streamlined data analysis workflows.

## Installation

You can install myRtools from GitHub:

```r
# Install devtools if you haven't already
install.packages("devtools")

# Install myRtools
devtools::install_github("dwhancock17/myRtools")
```

## Usage

### Package Management

Easily install and load multiple packages:

```r
library(myRtools)

# Install and load packages
manage_packages(c("dplyr", "ggplot2", "gt"))

# Quiet mode
manage_packages(c("tidyverse", "data.table"), quiet = TRUE)
```

### Quick Data Summary

Get a fast overview of your data:

```r
# Quick summary
quick_summary(mtcars)

# Without structure details
quick_summary(iris, show_str = FALSE)
```

## Functions

- `manage_packages()`: Automatically install missing packages and load all requested packages
- `quick_summary()`: Provide quick overview of data frame dimensions and structure

## License

MIT License
```
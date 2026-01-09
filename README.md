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

### Descriptive Tables with Odds Ratios

Create a combined descriptive and univariate odds ratio table:

```r
vars <- c("age_cat", "gender", "race", "time_to_scene", "business_hours")

make_desc_or_table(
  data = data,          # ~10M rows
  outcome = DV,
  predictors = IVs,
  or_sample_n = 1e6,          # ORs on 1M rows
  seed = 202402
)

```

### Saving gtsummary Tables

Save a gtsummary table produced by make_desc_or_table() (or any other gtsummary workflow) to common manuscript-ready formats with a single function call.

Supported formats include HTML, Word (.docx), and PDF.

```r
# Create the table
vars <- c("age_cat", "gender", "race", "time_to_scene", "business_hours")

table1 <- make_desc_or_table(
  data = dat_filter,
  outcome = refusal,
  predictors = vars
)

# View in RStudio
table1

# Save for manuscripts or reports
save_gtsummary(table1, "Table1.html")
save_gtsummary(table1, "Table1.docx")
```

### Sensitivity check of stability of ORs in random subsamples

This function is not for tables — it’s for diagnostics and reassurance.

What it does

Draws two independent random subsamples

Fits univariate ORs in each

Returns tidy results so you can:

eyeball consistency

save as a supplement

reassure reviewers (or yourself)

```r
# Sample two independent random samples and compare 
or_compare <- compare_uv_or_subsamples(
  data = dat_filter,
  outcome = refusal,
  predictors = vars,
  sample_n = 500000,
  seed = 123
)

or_compare
```


## Functions

- `manage_packages()`: Automatically install missing packages and load all requested packages
- `quick_summary()`: Provide quick overview of data frame dimensions and structure
- `make_desc_or_table()`: Create a combined descriptive and univariate odds ratio table
- `save_gtsummary()`: Save gtsummary tables as HTML, .docx, or PDF
- `compare_uv_or_subsample()`: Compare univariate independent random subsamples for stability

## License

MIT License
```
```
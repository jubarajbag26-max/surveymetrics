# surveymetrics: Quantitative Survey Cleaning & Parametric Inference in R

[![R-CMD-check](https://github.com/jubarajbag26-max/surveymetrics/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/jubarajbag26-max/surveymetrics/actions/workflows/R-CMD-check.yaml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

`surveymetrics` is a lightweight, zero-dependency R package built for quantitative social science teams and academic researchers. It streamlines the end-to-end pipeline from messy **Google Forms CSV exports** to publication-ready **parametric confidence intervals**, **Welch's two-sample cohort t-tests**, and **standardized behavioral/burnout indices**.

## Installation

Install the package directly from GitHub:

```r
# install.packages("remotes")
remotes::install_github("jubarajbag26-max/surveymetrics")
```

## Core Workflow Example

```r
library(surveymetrics)

# 1. Clean raw Google Forms survey export
raw_survey <- read.csv("campus_smartphone_survey.csv", check.names = FALSE)
clean_df <- clean_google_forms(
  df = raw_survey,
  numeric_cols = c("daily_screen_time_hours", "focus_duration_mins", "burnout_q1", "burnout_q2")
)

# 2. Compute 95% Parametric Confidence Intervals for Screen Time
ci_summary <- calc_ci(clean_df$daily_screen_time_hours, conf_level = 0.95)
print(ci_summary)

# 3. Compare Focus Duration across Screen-Time Cohorts (Welch's t-test + Cohen's d)
clean_df$screen_cohort <- ifelse(clean_df$daily_screen_time_hours >= 6, "High_Screen", "Low_Screen")
ttest_results <- run_cohort_ttest(clean_df, outcome_col = "focus_duration_mins", group_col = "screen_cohort")
print(ttest_results)

# 4. Calculate Standardized 0-100 Burnout Index
scored_df <- compute_burnout_index(clean_df, item_cols = c("burnout_q1", "burnout_q2"))
table(scored_df$burnout_tier)
```

## Maintainer
Maintained by **Jubaraj Bag** ([@jubarajbag26-max](https://github.com/jubarajbag26-max)).

## License
MIT License. See [LICENSE](LICENSE) for details.

#' Calculate Parametric Confidence Intervals
#'
#' Computes sample mean, standard deviation, standard error, and two-sided
#' t-distribution confidence intervals for a numeric survey vector.
#'
#' @param x A numeric vector of observations (e.g., daily screen time in hours).
#' @param conf_level Confidence level between 0 and 1 (default is 0.95).
#' @return A named data.frame containing n, mean, sd, se, ci_lower, and ci_upper.
#' @export
calc_ci <- function(x, conf_level = 0.95) {
  if (!is.numeric(x)) {
    stop("Input 'x' must be a numeric vector.")
  }
  if (conf_level <= 0 || conf_level >= 1) {
    stop("'conf_level' must be strictly between 0 and 1.")
  }

  x_clean <- x[!is.na(x)]
  n <- length(x_clean)
  if (n < 2) {
    stop("At least 2 non-missing observations are required to compute a confidence interval.")
  }

  sample_mean <- mean(x_clean)
  sample_sd <- stats::sd(x_clean)
  sample_se <- sample_sd / sqrt(n)
  alpha <- 1 - conf_level
  t_crit <- stats::qt(1 - alpha / 2, df = n - 1)
  margin_error <- t_crit * sample_se

  data.frame(
    n = n,
    mean = round(sample_mean, 4),
    sd = round(sample_sd, 4),
    se = round(sample_se, 4),
    ci_lower = round(sample_mean - margin_error, 4),
    ci_upper = round(sample_mean + margin_error, 4),
    conf_level = conf_level
  )
}

#' Execute Two-Sample Cohort T-Test with Effect Size
#'
#' Runs Welch's two-sample t-test comparing a continuous outcome across a binary
#' grouping variable and calculates Cohen's d effect size.
#'
#' @param df A cleaned data.frame.
#' @param outcome_col Name of the continuous numeric column (e.g., "focus_minutes").
#' @param group_col Name of the binary grouping column (e.g., "high_screen_time").
#' @return A tidy data.frame with group means, t-statistic, df, p-value, and Cohen's d.
#' @export
run_cohort_ttest <- function(df, outcome_col, group_col) {
  if (!all(c(outcome_col, group_col) %in% names(df))) {
    stop("Both 'outcome_col' and 'group_col' must exist in 'df'.")
  }

  sub_df <- df[!is.na(df[[outcome_col]]) & !is.na(df[[group_col]]), ]
  groups <- unique(sub_df[[group_col]])

  if (length(groups) != 2) {
    stop("Grouping column must contain exactly 2 distinct cohorts for a two-sample t-test.")
  }

  g1 <- sub_df[[outcome_col]][sub_df[[group_col]] == groups[1]]
  g2 <- sub_df[[outcome_col]][sub_df[[group_col]] == groups[2]]

  test_res <- stats::t.test(g1, g2, var.equal = FALSE)

  n1 <- length(g1)
  n2 <- length(g2)
  s_pool <- sqrt(((n1 - 1) * stats::sd(g1)^2 + (n2 - 1) * stats::sd(g2)^2) / (n1 + n2 - 2))
  cohens_d <- (mean(g1) - mean(g2)) / s_pool

  data.frame(
    group_1 = as.character(groups[1]),
    group_2 = as.character(groups[2]),
    mean_1 = round(mean(g1), 4),
    mean_2 = round(mean(g2), 4),
    t_stat = round(unname(test_res$statistic), 4),
    df = round(unname(test_res$parameter), 2),
    p_value = signif(test_res$p.value, 4),
    cohens_d = round(cohens_d, 4),
    significant_05 = test_res$p.value < 0.05
  )
}

#' Compute Standardized Composite Burnout Index
#'
#' Aggregates multiple Likert-scale survey items (e.g., 1 to 5 fatigue, stress,
#' and focus depletion items) into a normalized 0-100 composite index and categorizes
#' respondents into severity tiers.
#'
#' @param df A data.frame containing Likert-scale survey items.
#' @param item_cols Character vector of Likert column names.
#' @param min_scale Minimum value of the Likert scale (default 1).
#' @param max_scale Maximum value of the Likert scale (default 5).
#' @return The input data.frame with `burnout_score_100` and `burnout_tier` appended.
#' @export
compute_burnout_index <- function(df, item_cols, min_scale = 1, max_scale = 5) {
  if (!all(item_cols %in% names(df))) {
    stop("All specified 'item_cols' must exist in the data.frame.")
  }

  item_matrix <- as.matrix(df[, item_cols, drop = FALSE])
  if (!is.numeric(item_matrix)) {
    stop("All burnout Likert items must be numeric.")
  }

  raw_mean <- rowMeans(item_matrix, na.rm = TRUE)
  norm_score <- ((raw_mean - min_scale) / (max_scale - min_scale)) * 100
  norm_score <- pmax(0, pmin(100, norm_score))

  df$burnout_score_100 <- round(norm_score, 2)
  df$burnout_tier <- ifelse(
    is.na(norm_score), NA_character_,
    ifelse(norm_score < 35, "Low",
      ifelse(norm_score < 70, "Moderate", "High")
    )
  )

  return(df)
}

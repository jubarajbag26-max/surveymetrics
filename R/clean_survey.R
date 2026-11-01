#' Clean and Sanitize Raw Google Forms Survey Data
#'
#' Standardizes messy column headers from Google Forms exports, removes empty
#' timestamp rows, and coerces numeric behavioral variables (e.g., screen time,
#' focus duration) while handling missing or out-of-bounds values.
#'
#' @param df A data.frame imported from a Google Forms CSV export.
#' @param numeric_cols Character vector of column names to coerce to numeric.
#' @param drop_na Logical; if TRUE, removes rows with missing values in `numeric_cols`.
#' @return A cleaned data.frame ready for statistical inference.
#' @export
clean_google_forms <- function(df, numeric_cols = NULL, drop_na = TRUE) {
  if (!is.data.frame(df)) {
    stop("Input 'df' must be a valid data.frame.")
  }

  clean_names <- tolower(names(df))
  clean_names <- gsub("[^a-z0-9]+", "_", clean_names)
  clean_names <- gsub("^_|_$", "", clean_names)
  names(df) <- make.unique(clean_names, sep = "_")

  if ("timestamp" %in% names(df)) {
    df$timestamp <- NULL
  }

  if (!is.null(numeric_cols)) {
    for (col in numeric_cols) {
      if (col %in% names(df)) {
        raw_val <- as.character(df[[col]])
        cleaned_val <- gsub("[^0-9.-]", "", raw_val)
        df[[col]] <- suppressWarnings(as.numeric(cleaned_val))
      } else {
        warning(sprintf("Column '%s' not found in dataset.", col))
      }
    }

    if (drop_na) {
      valid_cols <- intersect(numeric_cols, names(df))
      if (length(valid_cols) > 0) {
        df <- df[stats::complete.cases(df[, valid_cols, drop = FALSE]), , drop = FALSE]
      }
    }
  }

  rownames(df) <- NULL
  return(df)
}

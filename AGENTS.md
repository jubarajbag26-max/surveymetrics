# Codex & AI Agent Maintenance Guidelines for `surveymetrics`

This repository (`jubarajbag26-max/surveymetrics`) uses OpenAI Codex for automated pull request reviews, unit test generation, and R CMD check diagnostics.

## Environment & Build Commands
- **Check Package Integrity:** `R CMD build . && R CMD check surveymetrics_*.tar.gz --no-manual`
- **Run Unit Tests:** `Rscript -e "testthat::test_local()"`

## Coding Standards for Agents
1. **Zero Heavy Dependencies:** Keep core functions inside `R/` reliant strictly on base R (`stats`, `utils`) so social science students and researchers can install the package on restricted lab machines without compilation errors.
2. **Input Validation:** Every exported function must validate column existence, data types, and sample size constraints (`n >= 2` for parametric tests) with descriptive `stop()` messages.
3. **Test Coverage:** Any new statistical utility or data-cleaning heuristic must include corresponding unit tests in `tests/testthat/test-surveymetrics.R` covering edge cases (`NA` strings, malformed CSV inputs, and zero-variance vectors).

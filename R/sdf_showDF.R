sdf_showDF <- function (x, ...) {
  sdf <- spark_dataframe(x)
  sc <- spark_jobj(sdf)
  .local <- function (x, numRows = 20, truncate = TRUE) {
    s <- invoke(sc, "showString", ensure_scalar_integer(numRows), truncate)
    cat(s)
  }
  .local(x, ...)
}

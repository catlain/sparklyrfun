ft_maxabsscaler <- function (x, input.col = NULL, output.col = NULL, ...) {
  ml_backwards_compatibility_api()
  class <- "org.apache.spark.ml.feature.MaxAbsScaler"
  
  # indices <- as.array(indices-1) # sacla array start from 0 !!
  invoke_simple_transformer(x, class, list(setInputCol = ensure_scalar_character(input.col),
                                           setOutputCol = ensure_scalar_character(output.col)))
}
environment(ft_maxabsscaler) <- asNamespace('sparklyr')

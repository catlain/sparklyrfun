ft_normalizer <- function (x, input.col = NULL, output.col = NULL, p = 1.0, ...) {
  ml_backwards_compatibility_api()
  class <- "org.apache.spark.ml.feature.Normalizer"
  
  # indices <- as.array(indices-1) # sacla array start from 0 !!
  invoke_simple_transformer(x, class, list(setInputCol = ensure_scalar_character(input.col),
                                           setOutputCol = ensure_scalar_character(output.col),
                                           setP = ensure_scalar_double(p)))
}
environment(ft_normalizer) <- asNamespace('sparklyr')

ft_standardscaler <- function (x, input.col = NULL, output.col = NULL, with.std = TRUE, with.mean = TRUE, ...) {
  ml_backwards_compatibility_api()
  class <- "org.apache.spark.ml.feature.StandardScaler"
  
  # indices <- as.array(indices-1) # sacla array start from 0 !!
  invoke_simple_transformer(x, class, list(setInputCol = ensure_scalar_character(input.col),
                                           setOutputCol = ensure_scalar_character(output.col),
                                           setWithStd = ensure_scalar_boolean(with.std),
                                           setWithMean = ensure_scalar_boolean(with.mean)))
}
environment(ft_standardscaler) <- asNamespace('sparklyr')

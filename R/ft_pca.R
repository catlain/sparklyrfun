ft_pca <- function (x, input.col = NULL, output.col = NULL, k, ...) {
  ml_backwards_compatibility_api()
  class <- "org.apache.spark.ml.feature.PCA"
  
  invoke_simple_transformer(x, class, list(setInputCol = ensure_scalar_character(input.col),
                                           setOutputCol = ensure_scalar_character(output.col),
                                           setK = ensure_scalar_integer(k),
                                           function(transformer, sdf) invoke(transformer, "fit", sdf)))
}
environment(ft_pca) <- asNamespace('sparklyr')

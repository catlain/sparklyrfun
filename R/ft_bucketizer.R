ft_bucketizer <- function (x, input.col = NULL, output.col = NULL, splits, ...) {
  ml_backwards_compatibility_api()
  class <- "org.apache.spark.ml.feature.Bucketizer"
  
  # indices <- as.array(indices-1) # sacla array start from 0 !!
  invoke_simple_transformer(x, class, list(setInputCol = ensure_scalar_character(input.col),
                                           setOutputCol = ensure_scalar_character(output.col),
                                           setSplits = as.array(splits)))
}
environment(ft_bucketizer) <- asNamespace('sparklyr')

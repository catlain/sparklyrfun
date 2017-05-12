ft_word2Vec <- function (x, input.col = NULL, output.col = NULL, vector.size = 10L, min.count = 0L, num.partitions = 100L, step.size = 0.025, max.iter = 1000, window.size = 1L, ...) {
  ml_backwards_compatibility_api()
  class <- "org.apache.spark.ml.feature.Word2Vec"
  invoke_simple_transformer(x, class, list(setInputCol = ensure_scalar_character(input.col),
                                           setOutputCol = ensure_scalar_character(output.col),
                                           setVectorSize = ensure_scalar_integer(vector.size),
                                           setMinCount = ensure_scalar_integer(min.count),
                                           setWindowSize = ensure_scalar_integer(window.size),
                                           setNumPartitions = ensure_scalar_integer(num.partitions),
                                           setStepSize = ensure_scalar_double(step.size),
                                           setMaxIter = ensure_scalar_integer(max.iter),
                                           function(transformer, sdf) invoke(transformer, "fit", sdf)))
}
environment(ft_word2Vec) <- asNamespace('sparklyr')

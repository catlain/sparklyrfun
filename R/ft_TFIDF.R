ft_TFIDF <- function (x, input.col = NULL, output.col = NULL, num.features = 100L, min.freq = 100L, ...) {
  ml_backwards_compatibility_api()
  HashingTF <- "org.apache.spark.ml.feature.HashingTF"
  IDF <- "org.apache.spark.ml.feature.IDF"
  rawFeatures_col <- paste0("rawFeatures_", round(runif(1)*10000))
  invoke_simple_transformer(x, HashingTF, list(setInputCol = ensure_scalar_character(input.col),
                                               setOutputCol = rawFeatures_col,
                                               setNumFeatures = ensure_scalar_integer(num.features))) %>%
    invoke_simple_transformer(IDF, list(setInputCol = rawFeatures_col,
                                        setOutputCol = ensure_scalar_character(output.col),
                                        setMinDocFreq = ensure_scalar_integer(min.freq),
                                        function(transformer, sdf) invoke(transformer, "fit", sdf)))
}
environment(ft_TFIDF) <- asNamespace('sparklyr')



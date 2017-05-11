ft_TFIDF <- function (x, input.col = NULL, output.col = NULL, num.features = 100L, min.freq = 100L, ...) {
  ml_backwards_compatibility_api()
  HashingTF <- "org.apache.spark.ml.feature.HashingTF"
  IDF <- "org.apache.spark.ml.feature.IDF"

  invoke_simple_transformer(x, HashingTF, list(setInputCol = ensure_scalar_character(input.col),
                                               setOutputCol = "rawFeatures",
                                               setNumFeatures = ensure_scalar_integer(num.features))) %>%
    invoke_simple_transformer(IDF, list(setInputCol = "rawFeatures",
                                        setOutputCol = ensure_scalar_character(output.col),
                                        setMinDocFreq = ensure_scalar_integer(min.freq),
                                        function(transformer, sdf) invoke(transformer, "fit", sdf)))
}

ft_chiSqSelector <- function (x, features.col = "features", label.col = "label", output.col = "selected_features", num.top.features = 50, ...) {
  ml_backwards_compatibility_api()
  class <- "org.apache.spark.ml.feature.ChiSqSelector"
  
  invoke_simple_transformer(x, class, list(setFeaturesCol = ensure_scalar_character(features.col),
                                           setLabelCol = ensure_scalar_character(label.col),
                                           setOutputCol = ensure_scalar_character(output.col),
                                           setNumTopFeatures = ensure_scalar_integer(num.top.features)))
}
environment(ft_chiSqSelector) <- asNamespace('sparklyr')
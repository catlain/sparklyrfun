ml_random_forest <- function (x, response, features, max.bins = 32L, max.depth = 5L, thresholds = c(0.5, 0.5),
                              num.trees = 20L, type = c("auto", "regression", "classification"), 
                              ml.options = ml_options(), ...) 
{
  ml_backwards_compatibility_api()
  df <- spark_dataframe(x)
  sc <- spark_connection(df)
  categorical.transformations <- new.env(parent = emptyenv())
  df <- ml_prepare_response_features_intercept(x = df, response = response, 
                                               features = features, intercept = NULL, envir = environment(), 
                                               categorical.transformations = categorical.transformations, 
                                               ml.options = ml.options)
  max.bins <- ensure_scalar_integer(max.bins)
  max.depth <- ensure_scalar_integer(max.depth)
  num.trees <- ensure_scalar_integer(num.trees)
  
  type <- match.arg(type)
  only.model <- ensure_scalar_boolean(ml.options$only.model)
  envir <- new.env(parent = emptyenv())
  envir$id <- ml.options$id.column
  df <- df %>% sdf_with_unique_id(envir$id) %>% spark_dataframe()
  tdf <- ml_prepare_dataframe(df, features, response, ml.options = ml.options, 
                              envir = envir)
  schema <- sdf_schema(df)
  responseType <- schema[[response]]$type
  envir$model <- if (identical(type, "regression")) 
    "org.apache.spark.ml.regression.RandomForestRegressor"
  else if (identical(type, "classification")) 
    "org.apache.spark.ml.classification.RandomForestClassifier"
  else if (responseType %in% c("DoubleType", "IntegerType")) 
    "org.apache.spark.ml.regression.RandomForestRegressor"
  else "org.apache.spark.ml.classification.RandomForestClassifier"
  rf <- invoke_new(sc, envir$model)
  model <- rf %>% invoke("setFeaturesCol", envir$features) %>% 
    invoke("setLabelCol", envir$response) %>%
    invoke("setMaxBins", max.bins) %>%
    invoke("setMaxDepth", max.depth) %>%
    invoke("setNumTrees", num.trees) %>%
    invoke("setThresholds", as.array(thresholds))
  
  if (is.function(ml.options$model.transform)) 
    model <- ml.options$model.transform(model)
  if (only.model) 
    return(model)
  fit <- model %>% invoke("fit", tdf)
  featureImportances <- fit %>% invoke("featureImportances") %>% 
    invoke("toArray")
  ml_model("random_forest", fit, features = features, response = response, 
           max.bins = max.bins, max.depth = max.depth, num.trees = num.trees, 
           feature.importances = featureImportances, trees = invoke(fit, "trees"), data = df,
           ml.options = ml.options, categorical.transformations = categorical.transformations, 
           model.parameters = as.list(envir))
}
environment(ml_random_forest) <- asNamespace('sparklyr')
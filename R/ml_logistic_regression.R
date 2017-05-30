#1
ml_logistic_regression <- function (x, response, features, intercept = TRUE, weightcol = NULL, standardization = TRUE, threshold = 0.5, alpha = 0,
                                    regparam = 0,iter.max = 100L, ml.options = ml_options(),
                                    ...){
  ml_backwards_compatibility_api()
  df <- spark_dataframe(x)
  sc <- spark_connection(df)
  categorical.transformations <- new.env(parent = emptyenv())
  df <- ml_prepare_response_features_intercept(x = df, response = response,
                                               features = features, intercept = intercept, envir = environment(),
                                               categorical.transformations = categorical.transformations,
                                               ml.options = ml.options)
  alpha <- ensure_scalar_double(alpha)
  iter.max <- ensure_scalar_integer(iter.max)
  intercept <- ensure_scalar_boolean(intercept)
  regparam <- ensure_scalar_double(regparam)
  only.model <- ensure_scalar_boolean(ml.options$only.model)

  weightcol <- if(!is.null(weightcol)) ensure_scalar_character(weightcol)
  threshold <- ifelse(is.list(threshold), lapply(threshold, function(x) ensure_scalar_double(x)), ensure_scalar_double(threshold))
  standardization <- ensure_scalar_boolean(standardization)

  envir <- new.env(parent = emptyenv())
  envir$id <- ml.options$id.column
  df <- df %>% sdf_with_unique_id(envir$id) %>% spark_dataframe()
  tdf <- ml_prepare_dataframe(df, features, response, ml.options = ml.options,
                              envir = envir)
  envir$model <- "org.apache.spark.ml.classification.LogisticRegression"

  lr <- invoke_new(sc, envir$model)
  model <- lr %>%
    invoke("setMaxIter", iter.max) %>%
    invoke("setFeaturesCol",envir$features) %>%
    invoke("setLabelCol", envir$response) %>%
    invoke("setFitIntercept", intercept) %>%
    invoke("setElasticNetParam", alpha) %>%
    invoke("setStandardization", standardization) %>%
    invoke("setRegParam", regparam) 

  if(!is.null(weightcol)){
    model <- lr %>%
      invoke("setWeightCol", weightcol)
  }


  if(is.list(threshold)){
    model <- lr %>%
      invoke("setThresholds", threshold)
  }else if(!is.null(threshold)){
    model <- lr %>%
      invoke("setThreshold", threshold)
  }

  if (only.model)
    return(model)
  fit <- model %>% invoke("fit", tdf)
  coefficients <- fit %>% invoke("coefficients") %>% invoke("toArray")
  names(coefficients) <- features
  hasIntercept <- invoke(fit, "getFitIntercept")
  if (hasIntercept) {
    intercept <- invoke(fit, "intercept")
    coefficients <- c(coefficients, intercept)
    names(coefficients) <- c(features, "(Intercept)")
  }
  summary <- invoke(fit, "summary")
  areaUnderROC <- invoke(summary, "areaUnderROC")
  roc <- sdf_collect(invoke(summary, "roc"))
  coefficients <- intercept_first(coefficients)
  ml_model("logistic_regression", fit, features = features,
           response = response, intercept = intercept, coefficients = coefficients,
           roc = roc, area.under.roc = areaUnderROC, data = df,
           ml.options = ml.options, categorical.transformations = categorical.transformations,
           model.parameters = as.list(envir))
}
environment(ml_logistic_regression) <- asNamespace('sparklyr')

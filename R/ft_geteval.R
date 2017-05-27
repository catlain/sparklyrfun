ft_geteval <- function(fit, df, binary = TRUE) {
  eval <- lapply(df, function(x){
    
    if(binary){
      sdf_predict(fit, x) %>%
        ml_binary_classification_eval("label", "prediction")
    }else{
      sdf_predict(fit, x) %>%
        ml_classification_eval("label", "prediction", "accuracy")
    }
  })
}
environment(ft_geteval) <- asNamespace('sparklyr')
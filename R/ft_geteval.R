ft_geteval <- function(fit, df, binary = TRUE) {
  eval <- lapply(df, function(x){
    
    if(binary){
      sdf_predict(fit, x) %>%
        ml_binary_classification_eval("label", "prediction") %>%
        data.frame("metric" = "auc")
    }else{
      
      auc <- sdf_predict(fit, x) %>%
        ml_binary_classification_eval("label", "prediction") %>%
        data.frame("metric" = "auc")
      
      acc <- sdf_predict(fit, x) %>%
        ml_classification_eval("label", "prediction", "accuracy") %>%
        data.frame("metric" = "auc")
      
      bind_rows(auc, acc)
    }
  }) %>%
    bind_rows()
}
environment(ft_geteval) <- asNamespace('sparklyr')
ft_geteval <- function(fit, df, binary = TRUE, label = "label") {
  eval <- lapply(df, function(x){
    
    if(binary){
      
      # ml_binary_classification_eval need rawPrediction!!
      
      auc <- sdf_predict(fit, x) %>%
        ml_binary_classification_eval(label, "rawPrediction") %>%
        data.frame("auc" = .)
      acc <- sdf_predict(fit, x) %>%
        ml_classification_eval(label, "prediction", "accuracy") %>%
        data.frame("acc" = .)
      bind_cols(auc, acc)
    }else{
      sdf_predict(fit, x) %>%
        ml_classification_eval(label, "prediction") %>%
        data.frame("acc" = .)
    }
  })
  
  lapply(seq_along(eval), function(x){ 
    data.frame("data" = names(eval[x]), eval[[x]])
  }) %>% 
    bind_rows()
}
environment(ft_geteval) <- asNamespace('sparklyr')

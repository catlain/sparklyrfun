ft_word2Vec <- function (x, input.col = NULL, output.col = NULL, vector.size = 10, min.count = 0L, num.partitions = 100,
                         step.size = 0.025, max.iter = 10, max.sentence.length = 1000,
                         window.size = 1L, get.vectors = FALSE, ...) {
  
  ml_backwards_compatibility_api()
  df <- spark_dataframe(x)
  sc <- spark_connection(df)
  class <- "org.apache.spark.ml.feature.Word2Vec"
  
  result <- invoke_new(sc, class) %>%
    invoke("setInputCol", ensure_scalar_character(input.col)) %>%
    invoke("setOutputCol", ensure_scalar_character(output.col)) %>%
    invoke("setVectorSize", ensure_scalar_integer(vector.size)) %>%
    invoke("setMinCount", ensure_scalar_integer(min.count)) %>%
    invoke("setNumPartitions", ensure_scalar_integer(num.partitions)) %>%
    invoke("setStepSize", ensure_scalar_double(step.size)) %>%
    invoke("setMaxIter", ensure_scalar_integer(max.iter)) %>%
    invoke("setMaxSentenceLength", ensure_scalar_integer(max.sentence.length)) %>%
    invoke("fit", df)
  
  if(get.vectors){
    result %>%
      invoke("getVectors") %>%
      sdf_register()
  }else{
    result %>%
      invoke("transform") %>%
      sdf_register()
  }
}
environment(ft_word2Vec) <- asNamespace('sparklyr')
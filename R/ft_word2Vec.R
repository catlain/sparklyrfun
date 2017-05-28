# 1
ft_word2Vec <- function (x, input.col = NULL, output.col = NULL, vector.size = 10, min.count = 0L, num.partitions = 100,
                         step.size = 0.025, max.iter = 10, max.sentence.length = 1000,
                         window.size = 1, get.vectors = FALSE, seed = 100, ...) {
  ml_backwards_compatibility_api()
  df <- spark_dataframe(x)
  df.name <- as.character(x$ops[1]) 
  
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
    invoke("setSeed", ensure_scalar_integer(seed)) %>%
    invoke("fit", df)
  
  if(get.vectors){
    vectors <- result %>%
      invoke("getVectors") %>%
      sdf_register()
    assign(vectors, paste0(df.name, "_vectors"), pos = sys.frame(0))
    print(paste0("================",df.name, "_vectors is created============="))
  }
    result %>%
      invoke("transform", df) %>%
      sdf_register()
}
environment(ft_word2Vec) <- asNamespace('sparklyr')
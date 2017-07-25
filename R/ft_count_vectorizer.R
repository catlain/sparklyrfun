invoke_simple_modeler <- function (x, class, arguments) 
{
  sdf <- spark_dataframe(x)
  sc <- spark_connection(sdf)
  transformer <- invoke_new(sc, class)
  enumerate(arguments, function(key, val) {
    if (is.function(val)) 
      transformer <<- val(transformer, sdf)
    else if (!identical(val, NULL)) 
      transformer <<- invoke(transformer, key, val)
  })
  transformer
}

environment(invoke_simple_modeler) <- asNamespace('sparklyr')


ft_count_vectorizer <- function(x, input.col = NULL, output.col = NULL, min.df = NULL, min.tf = NULL, vocab.size = NULL, get.model = FALSE, model = NULL, ...)
{
  ml_backwards_compatibility_api()
  class <- "org.apache.spark.ml.feature.CountVectorizer"
  sdf <- spark_dataframe(x)
  
  if(!is.null(model)){
    transformed <- invoke(model, "transform", sdf)
    sdf_register(transformed)
  }else{
    vocab.size <- ensure_scalar_integer(vocab.size)
    arguments <- list(
      setInputCol   = ensure_scalar_character(input.col),
      setOutputCol  = ensure_scalar_character(output.col),
      setMinDF      = min.df,
      setMinTF      = min.tf,
      setVocabSize  = vocab.size,
      fit           = sdf
    )
    
    transformer <- invoke_simple_modeler(x, class, arguments)
    
    if(get.model) transformer
    else{
      transformed <- invoke(transformer, "transform", sdf)
      sdf_register(transformed)
    }
  }
}

environment(ft_count_vectorizer) <- asNamespace('sparklyr')
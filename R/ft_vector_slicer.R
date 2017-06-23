ft_vector_slicer <- function (x, input.col = NULL, output.col = NULL, indices = list(1L), ...) {
  ml_backwards_compatibility_api()
  class <- "org.apache.spark.ml.feature.VectorSlicer"
  
  if(is.list(indices)){
    indices <- lapply(indices, function(x) x - 1)  # sacla array start from 0 !!
  }else{
    message(paste("indices need to be a list, but a", class(indices)))
    indices <- list()
  }
  
  invoke_simple_transformer(x, class, list(setInputCol = ensure_scalar_character(input.col),
                                           setOutputCol = ensure_scalar_character(output.col),
                                           setIndices = indices))
}
environment(ft_vector_slicer) <- asNamespace('sparklyr')


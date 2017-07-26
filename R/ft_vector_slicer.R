ft_vector_slicer <- function (x, input.col = NULL, output.col = NULL, indices = c(1), ...) {
  ml_backwards_compatibility_api()
  class <- "org.apache.spark.ml.feature.VectorSlicer"
  # indices need to be array !!!!!
  if(is.list(indices)){
    indices <- as.array(unique(as.integer(indices - 1))) # sacla array start from 0 !!
  }else{
    message(paste("indices need to be a array, but a", class(indices)))
    indices <- array()
  }
  
  invoke_simple_transformer(x, class, list(setInputCol = ensure_scalar_character(input.col),
                                           setOutputCol = ensure_scalar_character(output.col),
                                           setIndices = indices))
}
environment(ft_vector_slicer) <- asNamespace('sparklyr')


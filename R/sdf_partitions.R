sdf_partitions_size <- function(x) {
  sdf <- spark_dataframe(x)
  partitions <- sdf %>%
    invoke("rdd") %>%
    invoke("partitions")
  length(partitions)
}
environment(sdf_partitions_size) <- asNamespace('sparklyr')

sdf_repartition <- function (x, n = NULL, cols = list()){
  num_repartition <- sdf_partitions_size(x)
  sdf <- spark_dataframe(x)
  
  if (is.null(n)){
    num <- ensure_scalar_integer(num_repartition)
  }else{
    num <- ensure_scalar_integer(n)
  }
  
  if(length(cols) > 0){
    #column*
    col <- cols_repartition(x, cols)
    result <- sdf %>% invoke("repartition", num, col)
  }else{
    result <- sdf %>% invoke("repartition", num)
  }
  sdf_register(result)
}


cols_repartition <- function(x, cols = list()){
  sdf <- spark_dataframe(x)
  lapply(cols, function(col){
    invoke(sdf, "col", col)
  })
}
environment(cols_repartition) <- asNamespace('sparklyr')


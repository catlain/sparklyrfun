sdf_partitions_size <- function(x) {
  sdf <- spark_dataframe(x)
  partitions <- sdf %>%
    invoke("rdd") %>%
    invoke("partitions")
  length(partitions)
}
environment(sdf_partitions_size) <- asNamespace('sparklyr')

sdf_repartition <- function (x, n = 100, cols = list()){
  num <- sdf_partitions_size(x)
  sdf <- spark_dataframe(x)
  if(length(cols) > 0){
    #column*
    col <- cols_repartition(x, cols)
    result <- sdf %>% invoke("repartition", ensure_scalar_integer(n), col)
  }else{
    result <- sdf %>% invoke("repartition", ensure_scalar_integer(n))
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


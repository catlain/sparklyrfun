sdf_partitions_size <- function(x) {
  sdf <- spark_dataframe(x)
  partitions <- sdf %>%
    invoke("rdd") %>%
    invoke("partitions")
  length(partitions)
}
environment(sdf_partitions_size) <- asNamespace('sparklyr')

sdf_repartition <- function(x, n = 1) {

  num <- sdf_partitions_size(x)
  sdf <- spark_dataframe(x)
  if(num > n){
    result <- sdf %>%
      invoke("coalesce", ensure_scalar_integer(n))
  }else{
    result <- sdf %>%
      invoke("repartition", ensure_scalar_integer(n))
  }
  sdf_register(result)
}
environment(sdf_repartition) <- asNamespace('sparklyr')

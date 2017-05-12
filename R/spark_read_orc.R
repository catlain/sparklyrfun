spark_read_orc <- function (sc, name, path, options = list(), repartition = 0, memory = TRUE, overwrite = TRUE) {
  if (overwrite)
    spark_remove_table_if_exists(sc, name)
  df <- spark_data_read_generic(sc, list(spark_normalize_path(path)),
                                "orc", options)
  spark_partition_register_df(sc, df, name, repartition, memory)
}
environment(spark_read_orc) <- asNamespace('sparklyr')

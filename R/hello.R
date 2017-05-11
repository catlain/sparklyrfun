# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'


#
# persist <- function(x, storage.level = "MEMORY_AND_DISK") {
#   sdf <- spark_dataframe(x)
#   sc <- spark_connection(sdf)
#   storage.level <- ensure_scalar_character(storage.level)
#   sl <- invoke_static(sc, "org.apache.spark.storage.StorageLevel", storage.level)
#   sdf %>%
#     invoke("persist", sl) %>%
#     sdf_register()
# }

# sdf_load_table1 <- function (sc, name)
# {
#     session <- spark_session(sc)
#     name <- ensure_scalar_character(name)
#     reader <- invoke(session, "read")
#     sdf <- invoke(reader, "table", name)
#     sdf_register(sdf)
# } # can't use  invoke(reader, "load", path)  on database.table



#
#
# spark_sql_query <- function(query) {
# query <- ensure_scalar_character(query)
# test <- sc %>%
#   hive_context() %>%
#   invoke("sql", query) %<>%
#   sdf_register()
# }


# is_spark_v2 <- function(scon) {
#   spark_version(scon) >= "2.0.0"
# }
#
#
# setMethod("dbRemoveTable", c("spark_connection", "character"),
#           function(conn, name) {
#             hive <- hive_context(conn)
#             if (is_spark_v2(conn)) {
#               hive <- invoke(hive, "sqlContext")
#             }
#             invoke(hive, "dropTempTable", name)
#             invisible(TRUE)
#           }
# )


# spark_remove_table_if_exists <- function(sc, name) {
#   if (name %in% src_tbls(sc)) {
#     dbRemoveTable(sc, name)
#   }
# }





# sdf_replace_na <- function(x, fill = 0) {
#   sdf <- spark_dataframe(x)
#   result <- sdf %>%
#     invoke("na") %>%
#     invoke("fill", fill)
#   sdf_register(result)
# }
# environment(sdf_replace_na) <- asNamespace('sparklyr')






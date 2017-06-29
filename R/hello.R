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


# ---- funcitons not use -------

# spark_default_compilation_spec <- function(pkg = sparklyr:::infer_active_package_name()) {
#   list(
#     spark_compilation_spec(
#       spark_version = "2.0.0",
#       scalac_path = find_scalac("2.11"),
#       jar_name = sprintf("%s-2.0-2.11.jar", pkg),
#       jar_path = find_jar()
#     ),
#     spark_compilation_spec(
#       spark_version = "2.1.0",
#       scalac_path = find_scalac("2.11"),
#       jar_name = sprintf("%s-2.1-2.11.jar", pkg),
#       jar_path = find_jar()
#     )
#   )
# }
# environment(spark_default_compilation_spec) <- asNamespace('sparklyr')

# --------- use to compile_package_jars ------------


# ----- compile ---------

# source("R/spark_default_compilation_spec.R")
# setwd("/Users/xuyang/coding/up/sparklyrfun")
# compile_package_jars()
# setwd("/Users/xuyang/coding/up/") # 


# ----- sc --------

# Sys.setenv("SPARK_HOME" = "/usr/local/spark/")
# Sys.setenv("SPARK_HOME_VERSION" = "2.0.0")

# devtools::install_github("catlain/sparklyrfun")
# library(sparklyrfun)
# library(sparklyr)
# library(dplyr)
# sc <- spark_connect(master = "local")

# iris_tbl <- copy_to(sc, iris)
# mutate(iris_tbl, test = vecToSeq(Sepal_Length))
#
# spark_hello <- function(sc) {
#   sparklyr::invoke_static(sc, "scalaUDF.HelloWorld", "getArray", hostapk)
# }

#
# hostapk <- list("dqdqdad", "adqwdqd", "dqdqd")

ft_cf_rank <- function(aidvec_df, pkgvec_df, aidvec_col = "runapp_vec", 
                      pkgvec_col = "aidarrayrun_vec", aid_col = "aid", 
                      pkg_col = "runpkg", target_pkg = "com.cmcm.live", ...) 
  {
  sdf_aid_vec <- spark_dataframe(aidvec_df)
  sdf_pkg_vec <- spark_dataframe(pkgvec_df)
  sc <- spark_connection(sdf_aid_vec)
  sdf <- sparklyr::invoke_static(sc, "Sparklyrfun.MyUdfs", "getRank", sdf_aid_vec, sdf_pkg_vec, aidvec_col, pkgvec_col, aid_col, pkg_col, target_pkg)
  sdf_register(sdf)
}


ft_vector_array <- function(vec_df, input_col, output_col = "output_array", ...) 
  {
  vec_sdf <- spark_dataframe(vec_df)
  sc <- spark_connection(vec_sdf)
  sdf <- sparklyr::invoke_static(sc, "Sparklyrfun.MyUdfs", "vectorToArray", vec_sdf, input_col, output_col)
  sdf_register(sdf)
}


ft_vector_dot <- function(vec_df, input_col, output_col = "output_array", ...) 
{
  vec_sdf <- spark_dataframe(vec_df)
  sc <- spark_connection(vec_sdf)
  sdf <- sparklyr::invoke_static(sc, "Sparklyrfun.MyUdfs", "vectorDotVector", vec_sdf, input_col, output_col)
  sdf_register(sdf)
}


# iris_tbl <- copy_to(sc, iris)
# iris_tbl <- spark_dataframe(iris_tbl) %>%
#   invoke("selectExpr", list("array(1,2,3) as newcol")) %>%
#   sdf_register()
# 
# ft_vectortoarray(sc, iris_tbl, "newcol")
# ft_cfrank(sc, iris_tbl, iris_tbl, "newcol", "newcol", "newcol", "newcol")






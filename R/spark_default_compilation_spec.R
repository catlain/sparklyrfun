scalac_default_locations <- function () {
  if (Sys.info()[["sysname"]] == "Windows") {
    c(path.expand("~/scala"))
  }
  else {
    c("/opt/local/scala", "/usr/local/scala", "/opt/scala")
  }
}
environment(spark_compilation_spec) <- asNamespace('sparklyr')

spark_default_compilation_spec <- function (pkg = infer_active_package_name()){

  list(#spark_compilation_spec(spark_version = "1.5.2", scalac_path = find_scalac("2.10"), jar_name = sprintf("%s-1.5-2.10.jar", pkg)),
       #spark_compilation_spec(spark_version = "1.6.1", scalac_path = find_scalac("2.10"), jar_name = sprintf("%s-1.6-2.10.jar", pkg)),
       spark_compilation_spec(spark_version = "2.0.0", scalac_path = find_scalac("2.11"), jar_name = sprintf("%s-2.0-2.11.jar", pkg)),
       spark_compilation_spec(spark_version = "2.1.0", scalac_path = find_scalac("2.11"), jar_name = sprintf("%s-2.1-2.11.jar", pkg)))
}
environment(spark_default_compilation_spec) <- asNamespace('sparklyr')

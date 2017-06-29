download_scalac <- function() {
  dest_path <- scalac_default_locations()[[2]] #  "/usr/local/scala"

  if (!dir.exists(dest_path)) {
    dir.create(dest_path, recursive = TRUE)
  }

  ext <- if (.Platform$OS.type == "windows") "zip" else "tgz"

  download_urls <- c(
    paste0("http://downloads.lightbend.com/scala/2.11.8/scala-2.11.8.", ext),
    paste0("http://downloads.lightbend.com/scala/2.10.6/scala-2.10.6.", ext)
  )

  lapply(download_urls, function(download_url) {
    dest_file <- file.path(dest_path, basename(download_url))
    download.file(download_url, destfile = dest_file)

    if (ext == "zip")
      unzip(dest_file, exdir = dest_path)
    else
      untar(dest_file, exdir = dest_path)
  })
}
environment(download_scalac) <- asNamespace('sparklyr')

scalac_default_locations <- function() {
  if (Sys.info()[["sysname"]] == "Windows") {
    c(
      path.expand("~/scala")
    )
  } else {
    c(
      "/opt/local/scala",
      "/usr/local/scala",
      "/opt/scala"
    )
  }
}
environment(scalac_default_locations) <- asNamespace('sparklyr')


spark_compile <- function (jar_name, spark_home = NULL, filter = NULL, scalac = NULL, jar = NULL) {
  default_install <- spark_install_find()
  spark_home <- if (is.null(spark_home) && !is.null(default_install))
    spark_install_find()$sparkVersionDir
  else spark_home
  scalac <- scalac %||% path_program("scalac")
  jar <- jar %||% path_program("jar")
  scalac_version <- get_scalac_version(scalac)
  spark_version <- numeric_version(spark_version_from_home(spark_home))
  root <- rprojroot::find_package_root_file()
  java_path <- file.path(root, "inst/java")
  jar_path <- file.path(java_path, jar_name)
  scala_path <- file.path(root, "java") # not "java" !!!
  scala_files <- list.files(scala_path, pattern = "scala$",
                            full.names = TRUE)
  if (is.function(filter))
    scala_files <- filter(scala_files)
  message("==> using scalac ", scalac_version)
  message("==> building against Spark ", spark_version)
  message("==> building '", jar_name, "' ...")
  execute <- function(...) {
    cmd <- paste(...)
    message("==> ", cmd)
    system(cmd)
  }
  dir <- tempfile(sprintf("scalac-%s-", sub("-.*", "", jar_name)))
  ensure_directory(dir)
  owd <- setwd(dir)
  on.exit(setwd(owd), add = TRUE)
  candidates <- c("jars", "lib")
  jars <- NULL
  for (candidate in candidates) {
    jars <- list.files(file.path(spark_home, candidate),
                       full.names = TRUE, pattern = "jar$")
    if (length(jars))
      break
  }
  if (!length(jars))
    stop("failed to discover Spark jars")
  CLASSPATH <- paste(jars, collapse = .Platform$path.sep)
  inst_java_path <- file.path(root, "inst/java")
  ensure_directory(inst_java_path)
  classpath <- Sys.getenv("CLASSPATH")
  Sys.setenv(CLASSPATH = CLASSPATH)
  on.exit(Sys.setenv(CLASSPATH = classpath), add = TRUE)
  scala_files_quoted <- paste(shQuote(scala_files), collapse = " ")
  status <- execute(shQuote(scalac), "-optimise", scala_files_quoted)
  if (status)
    stop("==> failed to compile Scala source files")
  status <- execute(shQuote(jar), "cf", shQuote(jar_path),
                    ".")
  if (status)
    stop("==> failed to build Java Archive")
  if (!file.exists(jar_path))
    stop("==> failed to create ", jar_name)
  message("==> ", basename(jar_path), " successfully created\n")
  TRUE
} #
environment(spark_compile) <- asNamespace('sparklyr')

compile_package_jars <- function (...) { # only need 2.0 2.1
  speclist <- sparklyr:::spark_default_compilation_spec(pkg = "sparklyrfun")
  spec <- list(speclist[[3]], speclist[[4]])
  spec <- spec %||% list(...)
  if (!length(spec))
    spec <- spark_default_compilation_spec()
  if (!is.list(spec[[1]]))
    spec <- list(spec)
  for (el in spec) {
    el <- as.list(el)
    spark_version <- el$spark_version
    spark_home <- el$spark_home
    jar_name <- el$jar_name
    scalac_path <- el$scalac_path
    filter <- el$scala_filter
    if (is.null(spark_home) && !is.null(spark_version)) {
      message("==> downloading Spark ", spark_version)
      spark_install(spark_version, verbose = TRUE)
      spark_home <- spark_home_dir(spark_version)
    }
    spark_compile(jar_name = jar_name, spark_home = spark_home,
                  scalac = scalac_path, filter = filter)
  }
}
environment(compile_package_jars) <- asNamespace('sparklyr')

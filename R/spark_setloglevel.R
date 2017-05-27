spark_setloglevel <- function(sc, loglevel = "ERROR"){
  loglevel <- ensure_scalar_character(loglevel)
  spark_context(sc) %>%
    invoke("setLogLevel", loglevel)
}
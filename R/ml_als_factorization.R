ml_als_factorization <- function (x, rating.column = "rating", user.column = "user", 
                                  item.column = "item", user.blocks = 100L, item.blocks = 100L, rank = 10L, regularization.parameter = 0.1, 
                                  implicit.preferences = FALSE, alpha = 1, nonnegative = FALSE, 
                                  iter.max = 10L, ml.options = ml_options(), ...) 
{
  # user.blocks，item.blocks need more maxResultSize
  
  ml_backwards_compatibility_api()
  df <- spark_dataframe(x)
  sc <- spark_connection(df)
  rating.column <- ensure_scalar_character(rating.column)
  user.column <- ensure_scalar_character(user.column)
  item.column <- ensure_scalar_character(item.column)
  rank <- ensure_scalar_integer(rank)
  regularization.parameter <- ensure_scalar_double(regularization.parameter)
  implicit.preferences <- ensure_scalar_boolean(implicit.preferences, default = FALSE)
  alpha <- ensure_scalar_double(alpha)
  nonnegative <- ensure_scalar_boolean(nonnegative, default = FALSE)
  iter.max <- ensure_scalar_integer(iter.max)
  only.model <- ensure_scalar_boolean(ml.options$only.model, 
                                      default = FALSE)
  envir <- new.env(parent = emptyenv())
  envir$id <- ml.options$id.column
  df <- df %>% sdf_with_unique_id(envir$id) %>% spark_dataframe()
  envir$model <- "org.apache.spark.ml.recommendation.ALS"
  als <- invoke_new(sc, envir$model)
  model <- als %>% invoke("setRatingCol", rating.column) %>% 
    invoke("setUserCol", user.column) %>% 
    invoke("setItemCol", item.column) %>%
    invoke("setRank", rank) %>% 
    invoke("setRegParam", regularization.parameter) %>% 
    invoke("setImplicitPrefs", implicit.preferences) %>% 
    invoke("setAlpha", alpha) %>% 
    invoke("setNumItemBlocks", item.blocks) %>% 
    invoke("setNumUserBlocks", user.blocks) %>% 
    invoke("setNonnegative", nonnegative) %>% invoke("setMaxIter", 
                                                     iter.max)
  if (is.function(ml.options$model.transform)) 
    model <- ml.options$model.transform(model)
  if (only.model) 
    return(model)
  fit <- invoke(model, "fit", df)
  extract_factors <- function(fit, element) {
    factors <- invoke(fit, element)
    id <- sdf_read_column(factors, "id")
    features <- sdf_read_column(factors, "features")
    transposed <- transpose_list(features)
    names(transposed) <- sprintf("V%s", seq_along(transposed))
    df <- cbind(id, as.data.frame(transposed, stringsAsFactors = FALSE))
    result <- df[order(df$id), , drop = FALSE]
    rownames(result) <- NULL
    result
  }
  item.factors <- extract_factors(fit, "itemFactors")
  user.factors <- extract_factors(fit, "userFactors")
  ml_model("als_factorization", fit, item.factors = item.factors, 
           user.factors = user.factors, data = df, ml.options = ml.options, 
           model.parameters = as.list(envir))
}
environment(ml_als_factorization) <- asNamespace('sparklyr')
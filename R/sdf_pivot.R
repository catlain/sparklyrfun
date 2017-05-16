# trim_whitespace <- function(strings) {
#   gsub("^[[:space:]]*|[[:space:]]*$", "", strings)
# }
# environment(trim_whitespace) <- asNamespace('sparklyr')
# sdf_pivot <- function(x, formula, fun.aggregate = "count", col.aggregate) {
#   sdf <- spark_dataframe(x)
# 
#   # parse formulas of form "abc + def ~ ghi + jkl"
#   deparsed <- paste(deparse(formula), collapse = " ")
#   splat <- strsplit(deparsed, "~", fixed = TRUE)[[1]]
#   if (length(splat) != 2)
#     stop("expected a two-sided formula; got '", deparsed, "'")
# 
#   grouped_cols <- trim_whitespace(strsplit(splat[[1]], "[+*]")[[1]])
#   pivot_cols <- trim_whitespace(strsplit(splat[[2]], "[+*]", fixed = TRUE)[[1]])
# 
#   # ensure no duplication of variables on each side
#   intersection <- intersect(grouped_cols, pivot_cols)
#   if (length(intersection))
#     stop("variables on both sides of forumla: ", paste(deparse(intersection), collapse = " "))
# 
#   # ensure variables exist in dataset
#   nm <- as.character(invoke(sdf, "columns"))
#   all_cols <- c(grouped_cols, pivot_cols)
#   missing_cols <- setdiff(all_cols, nm)
#   if (length(missing_cols))
#     stop("missing variables in dataset: ", paste(deparse(missing_cols), collapse = " "))
# 
#   # ensure pivot is length one (for now)
#   if (length(pivot_cols) != 1)
#     stop("pivot column is not length one")
# 
#   # perform aggregation
#   fun.aggregate <- ifelse(is.null(fun.aggregate), "count", fun.aggregate)
#   fun.column <- invoke_static(sc, "org.apache.spark.sql.functions", "expr", paste0(as.character(fun.aggregate), "(", col.aggregate, ")"))
# 
#   # generate pivoted dataset
#   result <- sdf %>%
#     invoke("groupBy", grouped_cols[[1]], as.list(grouped_cols[-1])) %>%
#     invoke("pivot", pivot_cols[[1]]) %>%
#     invoke("agg", fun.column, list())
# 
#   # result <- if (is.function(fun.aggregate)) {
#   #   fun.aggregate(grouped)
#   # } else if (is.character(fun.aggregate)) {
#   #   if (length(fun.aggregate) == 1)
#   #     invoke(grouped, fun.aggregate[[1]])
#   #   else
#   #     invoke(grouped, fun.aggregate[[1]], as.list(fun.aggregate[-1]))
#   # } else if (is.list(fun.aggregate)) {
#   #   invoke(grouped, "agg", list2env(fun.aggregate))
#   # } else {
#   #   stop("unsupported 'fun.aggregate' type '", class(fun.aggregate)[[1]], "'")
#   # }
# 
#   sdf_register(result)
# }
# environment(sdf_pivot) <- asNamespace('sparklyr')

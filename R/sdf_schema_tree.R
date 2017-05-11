sdf_schema_tree <- function (object){
  jobj <- spark_dataframe(object)
  schema <- invoke(jobj, "schema")
  fields <- invoke(schema, "fields")
  obj <- spark_jobj(schema)
  schemaString <- invoke(obj, "treeString")
  cat(schemaString)
}

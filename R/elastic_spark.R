# Title     : Elasticsearch & Spark
# Objective : Load from Elasticsearch and use Spark backend with Hive storage
# Created by: nicksinclair
# Created on: 25/02/2018

library(tidyverse)
library(sparklyr)
library(elastic)
library(shiny)
library(rjson)

spark_client <- 'yarn-client'
Sys.setenv(spark_home = "/usr/lib/spark")
spark_home <- '/usr/lib/spark'
config <- spark_config()
sc <- spark_connect(master = spark_client, config = config, spark_home = spark_home)

elastic_search_host <- '10.20.0.175'
es_index <- 'cloudwatch'
es_type <- 'log'
es <- connect(es_host = elastic_search_host)


es_json <- Search(index = es_index, type = es_type, raw = T, size = 500)
es_list <- jsonlite::fromJSON(es_json, flatten = T, simplifyDataFrame = T, simplifyVector = T, simplifyMatrix = T)
es_df <- as_data_frame(es_list$hits$hits)

# FORMAT COLUMN NAMES CLEANLY
es_df_names <- colnames(es_df) %>%
  gsub(pattern = '\\.|:', replacement = '_') %>%
  gsub(pattern = '^_source_', replacement = 'source_') %>%
  gsub(pattern = '^_', replacement = '') %>%
  gsub(pattern = '^', replacement = 'o_') %>%
  gsub(pattern = '-', replacement = '_')
colnames(es_df) <- es_df_names
#es_df <- as.data.frame(es_df)

# UNNEST LIST COLUMNS WITH FUNCTION
# FIND LIST COLS
es_col_types <- lapply(es_df, is_list)
es_list_cols <- as.list(names(es_col_types[es_col_types == "TRUE"]))

# GET ROWS THAT CONTAIN LIST ELEMENTS FOR EACH COLUMN THAT CONTAINS LIST ITEMS
es_tmp <- as.data.frame(es_df)

# FUNCTION TO SELECT LIST COLUMNS AND UNNEST THEM CLEANLY
func_selective_unnest <- function(tmp_df, column_names) {
  df <- tmp_df
  for (column_name in column_names) {
    print(column_name)

    # GENERATE LOGICAL VECTOR BY TYPE FOR COLUMN BEING OPERATED ON
    t <- mapply(FUN = is.data.frame, df[, paste0(column_name)], SIMPLIFY = F)
    # SELECT ONLY THOSE COLUMNS OF TYPE
    f <- df[t == "TRUE",]
    # UNNEST THEM
    g <- unnest_(f, column_name, .drop = F, .id = column_name)

    # REMOVE ORIGINAL NESTED COLUMN IF NEW COLUMNS WERE CREATED
    if (ncol(g) > ncol(df)) {
       df <- select(df, -starts_with(column_name))
       g <- select(g, -starts_with(column_name))
      # GET NEW COLUMN NAMES AND ADD TO SOURCE DF AS NEW COLS FILLED WITH NAs
      cols_to_add <- setdiff(colnames(g), colnames(df))
      print(cols_to_add)
      df[, cols_to_add] <- NA
      # ADD THE UNNESTED ROWS TO ORIGINAL DF
      df <- rbind(df, g)
    }
  }
  return(df)
}
# UNNEST THE LIST COLUMNS CLEANLY
es_new_df <- func_selective_unnest(es_tmp, es_list_cols)

View(tail(es_new_df, n = 50))



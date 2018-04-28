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
sc <-
  spark_connect(master = spark_client,
                config = config,
                spark_home = spark_home)

elastic_search_host <- '10.20.0.175'
es_index <- 'cloudwatch'
es_type <- 'log'
es <- connect(es_host = elastic_search_host)


es_json <-
  Search(
    index = es_index,
    type = es_type,
    raw = T,
    size = 100
  )
es_list <-
  jsonlite::fromJSON(es_json, flatten = T, simplifyDataFrame = T)
es_df <- as_data_frame(es_list$hits$hits)

# FORMAT COLUMN NAMES CLEANLY
es_df_names <- colnames(es_df) %>%
  gsub(pattern = '\\.|:', replacement = '_') %>%
  gsub(pattern = '^_source_', replacement = 'source_') %>%
  gsub(pattern = '^_', replacement = '') %>%
  gsub(pattern = '^', replacement = 'o_') %>%
  gsub(pattern = '-', replacement = '_')
colnames(es_df) <- es_df_names

es_df <- as.data.frame(es_df)
# UNNEST LIST COLUMNS WITH FUNCTION
# FIND LIST COLS
es_col_types <- lapply(es_df, is_list)
es_list_cols <- as.list(names(es_col_types[es_col_types == "TRUE"]))

# GET ROWS THAT CONTAIN LIST ELEMENTS FOR EACH COLUMN THAT CONTAINS LIST ITEMS
es_tmp <- as.data.frame(es_df)
#c_names <- colnames(tmp)

func_selective_unnest <- function(df, column_names) {
  c_names <- colnames(df)
  for (column_name in column_names) {
    print(column_name)

    # GENERATE LOGICAL VECTOR BY TYPE FOR COLUMN BEING OPERATED ON
    t <-
      mapply(FUN = is.data.frame, df[, paste0(column_name)], SIMPLIFY = F)
    #    print(length(t))
    # SELECT ONLY THOSE COLUMNS OF TYPE
    f <- df[t == "TRUE", ]
    # UNNEST THEM
    g <- unnest_(f, column_name, .drop = F)

    # REMOVE ORIGINAL NESTED COLUMN FROM SOURCE IF NEW COLUMNS WERE CREATED
    if (ncol(g) > ncol(df)) {
      df <- select(df,-starts_with(column_name))
      g <- select(g,-starts_with(column_name))

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




# t <- mapply(FUN = is.data.frame, tmp$o_source_detail_resources, SIMPLIFY = F)
# f <- tmp[t == "TRUE",]
# g <- unnest(f, o_source_detail_resources)
#
# # REMOVE ORIGINAL NESTED COLUMN FROM SOURCE DF
# tmp <- select(tmp, -starts_with("o_source_detail_resources"))
#
# # GET NEW COLUMN NAMES AND ADD TO SOURCE DF AS NEW COLS FILLED WITH NAs
# cols_to_add <- setdiff(colnames(g), c_names)
# tmp[,cols_to_add] <- NA


lapply(es_list_cols, function(x)
{
  unested_rows <- unnest(tmp, x, .drop = T)
  rbind(tmp, unested_rows)
})


es_df$source_detail_requestParameters_instancesSet_items[es_df$source_detail_requestParameters_instancesSet_items != "NULL"]

es_df_new <- data.frame()
for (i in es_list_cols) {
  rbind(es_df_new, unnest(es_df, .id = i, .drop = T))
}


# tmp <- lapply(es_list_cols, function(x) unnest(es_df, x, .drop = T))
# tmp <- es_df %>% unnest(list(es_list_cols), .drop = T) %>%  tbl_df()

# func_unlist <- function(df, x) {
#   tmp_df <- df
#   for (i in x) {
#     print(x)
#     tmp_df[tmp_df[x] == "NULL"] <- NA
#   }
#   unnest(as.data.frame(tmp_df, x, .drop = T))
#   return(tmp_df)
# }
#
# tmp <- func_unlist(es_df, es_list_cols)
#lapply(es_list_cols, function(x) func_unlist(x))



# filter(tmp, is.list(source_detail_resources))


#tmp <- es_df %>% unnest(`_source.resources`, .drop =T) %>%  tbl_df()
#es_df_tbl <- copy_to(sc, es_df)

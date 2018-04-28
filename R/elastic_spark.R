# Title     : Elasticsearch & Spark
# Objective : Load from Elasticsearch and use Spark backend with Hive storage
# Created by: nicksinclair
# Created on: 25/02/2018

library(tidyverse)
library(sparklyr)
library(elastic)
library(shiny)
library(rjson)
library(xts)
library(lubridate)
library(data.table)

spark_client <- 'yarn-client'
Sys.setenv(spark_home = "/usr/lib/spark")
spark_home <- '/usr/lib/spark'
config <- spark_config()
sc <- spark_connect(master = spark_client, config = config, spark_home = spark_home)

elastic_search_host <- '10.20.0.175'
es_index <- 'cloudwatch'
es_type <- 'log'
es <- connect(es_host = elastic_search_host)


es_json <- Search(index = es_index, type = es_type, raw = T, size = 2000)
es_list <- jsonlite::fromJSON(es_json, flatten = T, simplifyDataFrame = T, simplifyVector = T, simplifyMatrix = T)
es_df <- as_data_frame(es_list$hits$hits)
es_df <- es_df[c(- 1, - 2, - 3, - 4, - 5)]


# FORMAT COLUMN NAMES CLEANLY
es_df_names <- colnames(es_df) %>%
    gsub(pattern = '\\.|:', replacement = '_') %>%
    gsub(pattern = '^_source_', replacement = '_') %>%
    gsub(pattern = '^_', replacement = '') %>%
    gsub(pattern = '-', replacement = '_')
colnames(es_df) <- es_df_names


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
            df <- select(df, - starts_with(column_name))
            g <- select(g, - starts_with(column_name))
            # GET NEW COLUMN NAMES AND ADD TO SOURCE DF AS NEW COLS FILLED WITH NAs
            cols_to_add <- setdiff(colnames(g), colnames(df))
            df[, cols_to_add] <- NA
            # ADD THE UNNESTED ROWS TO ORIGINAL DF
            df <- rbind(df, g)
            # APPEND SOURCE COLUMN NAME TO NAMES OF NEW COLS
            cols_renamed <- str_replace_all(cols_to_add, "^", paste0(column_name, "."))
            setnames(df, old = cols_to_add, new = cols_renamed)
        }
    }
    return(df)
}
# UNNEST THE LIST COLUMNS CLEANLY
es_new_df <- tbl_df(func_selective_unnest(es_tmp, es_list_cols))
es_new_df <- es_new_df[, order(names(es_new_df))]

View(tail(es_new_df, n = 50))



# SELECT INDIVIDUAL EVENTS BY EVENT NAME
event_names <- as.list(unique(es_new_df$detail_eventName))
es_dfs <- list()
# CREATE NAMED LIST OF DATAFRAMES BY EVENT NAMES
func_make_event_df <- function(event_name, df){
    tmp_df <- filter(df, detail_eventName == event_name) %>% select_if(~ sum(! is.na(.)) > 0)
    return(tmp_df)
}
es_dfs <- lapply(setNames(event_names, event_names), function(x) func_make_event_df(x, es_new_df))



# WORK THROUGH LIST - ASSIGN TEMP DATA FRAME FOR EACH ELEMENT
df_tmp <- es_dfs[["Decrypt"]]


# FUNCTION TO REMOVE EMPTY COLUMNS IN DATAFRAME
func_remove_null_cols <- function(df){
    df[is.null(df)] <- NA
    df <- df %>% replace(. == "NA", NA)
    df <- df %>% replace(. == "NULL", NA)
    df <- df %>% replace(. == "", NA)
    emptycols <- sapply(df, function (k) all(is.na(k)))
    return(df[! emptycols])
}
df_tmp <- func_remove_null_cols(df_tmp)






#############  WORK WITH VALUES TO FACTORS ############

# SELECT ROWS WITH USER IDENTITY ACCESS KEY ID







############ WORK WITH DATA AS TIME SERIES ############


### CONVERT ISO8601 DATE TIME FORMAT
tmp <- as.POSIXct(gsub("Z$", "", df_tmp$time), "%Y-%m-%dT%H:%M:%S", tz = "GMT")
df_tmp$time <- as.POSIXct(gsub("Z$", "", df_tmp$time), "%Y-%m-%dT%H:%M:%S", tz = "UTC")

# ARRANGE BY  DATE
df_tmp <- df_tmp %>% arrange(time)



# GROUP AND SUMMARISE BY FIELDS
#df_tmp <- df_tmp %>% group_by(time, detail_sourceIPAddress) %>%
df_tmp <- df_tmp %>%
    group_by(time, detail_userIdentity_accessKeyId, detail_sourceIPAddress) %>%
    summarise(count = n())

View(df_tmp)
hist(tmp, breaks = "hours", freq = T, col = "gold")






########################################################################################################
############################################ UTILITY FUNCTIONS #########################################

# INSPECT NULL/NA/EMPTY VALUES FUNCTION

# ASSIGN A LIST OR VECTOR TO 'TMP' VARIABLE
tmp <- df_tmp$detail_userIdentity_accessKeyId

sapply(tmp, function(x)
paste0("variable: \"", x, "\",  length: (", length(x), "), class: [", class(x), "], match: (", grepl("^.+", x), ")")) %>%
    unique() %>%
    View(title = "Valid Type Matches")

gp <- sapply(tmp, function(x) grepl("^.+", x))
ga <- sapply(tmp, function(x) grepl("^$", x))

View(unique(tmp[gp]))
View(unique(tmp[! gp]))

########################################################################################################























#%>% summarise(mean = mean(as.numeric(as.Date(time))), n = n())

# es_dfs[["StartInstances"]] %>%  dplyr::count(detail_requestParameters_instancesSet_items.instanceId, detail_sourceIPAddress)
# tmp <- xts(es_dfs[["StartInstances"]], order.by = as.Date(es_dfs[["StartInstances"]]$time))


#tmp <- func_remove_null_cols(filter(es_new_df, !is.na(detail_userIdentity_accessKeyId)))


# what are the most common issues that cause an error to be logged?

# err_order = function(df){
#   t0 = xtabs(~Issue_Descr, df)
#   m = cbind( names(t0), t0)
#   rownames(m) = NULL
#   colnames(m) = c("Cause", "Count")
#   x = m[,2]
#   x = as.numeric(x)
#   ndx = order(x, decreasing=T)
#   m = m[ndx,]
#   m1 = data.frame(Cause=m[,1], Count=as.numeric(m[,2]),
#                   CountAsProp=100*as.numeric(m[,2])/dim(df)[1])
#   subset(m1, CountAsProp >= 1.)
# }
#
# # calling this function, passing in a data frame, returns something like:
#
#
# Cause       Count    CountAsProp
# 1  'connect to unix://var/ failed'    200        40.0
# 2  'object buffered to temp file'     185        37.0
# 3  'connection refused'                94        18.8





packages <- list("assertthat", "backports", "base64enc", "BH", "bindr", "bindrcpp", "broom", "cli", "colorspace",
                "config", "crayon", "crosstalk", "curl", "data.table", "DBI", "dbplyr", "dichromat", "digest", 
                "dplyr", "elastic", "ggplot2", "glue", "gtable", "hexbin", "hms", "htmltools", "htmlwidgets", 
                "httpuv", "httr", "jsonlite", "labeling", "lazyeval", "magrittr", "mime", "mnormt", "munsell", 
                "openssl", "pillar", "pkgconfig", "plogr", "plotly", "plyr", "psych", "purrr", "R6", "rappdirs", 
                "RColorBrewer", "Rcpp", "readr", "reshape2", "rjson", "rlang", "rprojroot", "rstudioapi", "scales", 
                "shiny", "sourcetools", "sparklyr", "stringi", "stringr", "tibble", "tidyr", "tidyselect", "utf8", 
                "viridisLite", "withr", "xml2", "xtable", "yaml")

lapply(packages, install.packages)


# --> USE CORRECT VERSION <---
spark_install(version = "2.1.0")
spark_install(version = "2.2.1")



packages <- list("shiny", "tidyverse", "elastic", "sparklyr", "rjson", "datapasta")


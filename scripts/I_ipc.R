library(rio)
library(tidyverse)
library(tsibble)
Sys.setlocale("LC_TIME","C")

url = "http://www.gks.ru/free_doc/new_site/prices/potr/I_ipc.xlsx"
# ипц месячный

source("../../kassandr/R/watchdog.R")

I_ipc_xls_convert = function(path_to_source, access_date) {
  data = import(last_version_path)
  
  data <- data[5:16,-1]
  data <- gather(data, year, value)
  data <- select(data, -year)
  cpi_ts <- ts(data, start = c(1991, 1), freq = 12)
  cpi_infl <- as_tsibble(cpi_ts) %>% na.omit() %>% rename(date = index)
  
  data_tsibble = mutate(cpi_infl, access_date = access_date)
  return(data_tsibble)
}

watchdog = import("../raw/watchdog.csv")

last_version_path = get_last_version_path(url, watchdog)
last_access_date = get_last_version_download_date(url, watchdog)

converted_data = I_ipc_xls_convert(last_version_path, last_access_date)
converted_filename = replace_extension(last_version_path, "_converted.csv")


export(converted_data, converted_filename)

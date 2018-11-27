library(rio)
library(tidyverse)
library(tsibble)
Sys.setlocale("LC_TIME","C")

url = "http://www.gks.ru/free_doc/new_site/vvp/kv/tab6b.xls"
# квартальный ввп в ценах 2016 в млрд рублей

source("../../kassandr/R/functions.R")

tab6b_xls_convert = function(path_to_source, access_date) {
  data = import(last_version_path)
  
  data <- t(data[5, ]) %>% na.omit() %>% as.numeric()
  
  data_ts <- ts(data, start = c(2011, 1), freq = 4)
  data_tsibble <- data_ts %>% as_tsibble() %>% rename(date = index)

  data_tsibble = mutate(data_tsibble, access_date = access_date)
  return(data_tsibble)
}

watchdog = import("../raw/watchdog.csv")

last_version_path = get_last_version_path(url, watchdog)
last_access_date = get_last_version_download_date(url, watchdog)

converted_data = tab6b_xls_convert(last_version_path, last_access_date)
converted_filename = replace_extension(last_version_path, "_converted.csv")


export(converted_data, converted_filename)








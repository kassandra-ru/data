library(rio)
library(tidyverse)
library(tsibble)
Sys.setlocale("LC_TIME","C")

url = "http://www.gks.ru/free_doc/new_site/vvp/kv/tab9a.xls"
# Индексы - дефляторы валового внутреннего продукта в процентах к аналогичному периоду прошлого года

source("../../kassandr/R/functions.R")

tab9a_xls_convert = function(path_to_source, access_date) {
  data = import(last_version_path)
  
  data <- t(data[5, ]) %>% na.omit() %>% as.numeric()

  gdp_deflator <- ts(data, start = c(2012, 1), freq = 4)
  gdp_deflator <- as_tsibble(gdp_deflator) %>% rename(date = index)

  data_tsibble = mutate(gdp_deflator, access_date = access_date)
  return(data_tsibble)
}

watchdog = import("../raw/watchdog.csv")

last_version_path = get_last_version_path(url, watchdog)
last_access_date = get_last_version_download_date(url, watchdog)

converted_data = tab9a_xls_convert(last_version_path, last_access_date)
converted_filename = replace_extension(last_version_path, "_converted.csv")


export(converted_data, converted_filename)

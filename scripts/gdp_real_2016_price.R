library(rio)
library(tidyverse)
library(tsibble)
Sys.setlocale("LC_TIME","C")

url = "http://www.gks.ru/free_doc/new_site/vvp/kv/tab6b.xls"

get_last_version_path = function(source_url, watchdog) {
  watchdog_line = get_watchdog_line(source_url, watchdog)
  download_date = watchdog_line$last_download
  file_name = watchdog_line$file
  last_version_path = paste0("../raw/", download_date, "/", file_name)
  return(last_version_path)
}

replace_extension = function(filename, new_ext = "_converted.csv") {
  new_filename = paste0(tools::file_path_sans_ext(filename), new_ext)
  return(new_filename)
}

get_watchdog_line = function(source_url, watchdog) {
  if (!(source_url %in% watchdog$url)) {
    stop("The file ", source_url, " is not guarded by watchdog :)")
  }
  watchdog_line = filter(watchdog, url == source_url)
  return(watchdog_line)  
}


get_last_version_download_date = function(source_url, watchdog) {
  watchdog_line = get_watchdog_line(source_url, watchdog)
  download_date = watchdog_line$last_download
  return(download_date)  
}


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


export(processed_data, converted_filename)








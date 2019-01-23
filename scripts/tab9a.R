library(rio)
library(tidyverse)
library(tsibble)
Sys.setlocale("LC_TIME","C")

url = "http://www.gks.ru/free_doc/new_site/vvp/kv/tab9a.xls"
# Индексы - дефляторы валового внутреннего продукта в процентах к аналогичному периоду прошлого года

library(kassandr)


watchdog = import("../raw/watchdog.csv")

last_version_path = get_last_version_path(url, watchdog)
last_access_date = get_last_version_download_date(url, watchdog)

converted_data = tab9a_xls_convert(last_version_path, last_access_date)
converted_filename = replace_extension(last_version_path, "_converted.csv")


export(converted_data, converted_filename)

library(kassandr)
library(tidyverse)
library(lubridate)

raw_data_folder = "../raw/"

watchdog = rio::import(paste0(raw_data_folder, "watchdog.csv"))
print(watchdog)

new_watchdog = download_watchdog_files(raw_data_folder)
print(new_watchdog)

write_csv(new_watchdog, path = "../raw/watchdog.csv")

  


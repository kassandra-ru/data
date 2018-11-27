library(tidyverse)
library(rio)
library(lubridate)
library(digest)

watchdog = import("../raw/watchdog.csv")


today = as.character(today())
today_folder = paste0("../raw/", today)

new_watchdog = watchdog 

for (file_no in 1:nrow(watchdog)) {

  url = watchdog$url[file_no]
  md5 = watchdog$hash[file_no]
  filename = watchdog$file[file_no]
  
  tempfile = tempfile()
  attempt = try(download.file(url = url, destfile = tempfile))
  new_watchdog$last_access[file_no] = today
  
  if (class(attempt) == "try-error") {
    # ошибка при скачивании: запомним её
    new_watchdog$last_status[file_no] = as.character(attempt)
  } else {

    new_md5 = digest::digest(file = tempfile)
  
    if (md5 != new_md5) {
      if (!dir.exists(today_folder)) {
        dir.create(today_folder)
      }
      file.copy(from = tempfile, to = paste0(today_folder, "/", filename))
      new_watchdog$hash[file_no] = new_md5
      new_watchdog$last_download[file_no] = today
      new_watchdog$last_status[file_no] = "successful download"
    } else {
      new_watchdog$last_status[file_no] = "no changes in md5"
    }
  }
}
new_watchdog  

write_csv(new_watchdog, path = "../raw/watchdog.csv")

  


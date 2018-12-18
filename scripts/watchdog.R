library(kassandr)


raw_data_folder = "../raw/"
new_watchdog = download_watchdog_files(raw_data_folder)

write_csv(new_watchdog, path = "../raw/watchdog.csv")

  


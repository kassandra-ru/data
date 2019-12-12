library(tidyverse)
#path_to_source = "ipc2" 
                             
  data = rio::import("i_ipc.xlsx")
  access_date ="2019-12-11"
  data <- data[5:16,-1]
  data <- tidyr::gather(data, year, value)
  data <- dplyr::select(data, -year)
  cpi_ts <- stats::ts(data, start = c(1991, 1), freq = 12)
  cpi_infl <- tsibble::as_tsibble(cpi_ts) %>% stats::na.omit() %>% dplyr::rename(date = index, cpi = value)
  
  data_tsibble = dplyr::mutate(cpi_infl, access_date = access_date)
  #check_conversion(data_tsibble)
  write_csv(data_tsibble, "temp_cpi.csv")

  access_date = Sys.Date()
  data = rio::import("tab5a.xls")
  
  data_vector <- t(data[5, ]) %>% stats::na.omit() %>% as.numeric()
  data_vector<-data_vector[-17:-16]
  
  data_ts <- stats::ts(data_vector, start = c(2011, 1), freq = 4)
  data_tsibble <- tsibble::as_tsibble(data_ts) %>% dplyr::rename(date = index, gdp_current_price = value)
  
  data_tsibble = dplyr::mutate(data_tsibble, access_date = access_date)
  write_csv(data_tsibble, "temp_gdp.csv")
  


library(rio)
library(tidyverse)
library(tsibble)
Sys.setlocale("LC_TIME","C")

data = import("../raw/2018-09-27/tab6b.xls")

data <- t(data[5, ]) %>% na.omit() %>% as.numeric()

data_ts <- ts(data, start = c(2011, 1), freq = 4)
data_tsibble <- data_ts %>% as_tsibble() %>% rename(date = index)


export(data_tsibble, "../main/gdp_real_2016_price.csv")

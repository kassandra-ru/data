library(rio)
library(tidyverse)
library(tsibble)
Sys.setlocale("LC_TIME","C")

data = import("../raw/2018-09-27/tab9a.xls")

data <- t(data[5, ]) %>% na.omit() %>% as.numeric()
gdp_deflator <- ts(data, start = c(2012, 1), freq = 4)
gdp_deflator <- as_tsibble(gdp_deflator) %>% rename(date = index)


export(gdp_deflator, "../main/gdp_deflator.csv")

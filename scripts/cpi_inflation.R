library(rio)
library(tidyverse)
library(tsibble)
Sys.setlocale("LC_TIME","C")

data = import("../raw/2018-08-30/I_ipc.xlsx")

data <- data[5:16,-1]
data <- gather(data, year, value)
data <- select(data, -year)
cpi_ts <- ts(data, start = c(1991, 1), freq = 12)
cpi_infl <- as_tsibble(cpi_ts) %>% na.omit() %>% rename(date = index)


export(cpi_infl, "../main/cpi_inflation.csv")

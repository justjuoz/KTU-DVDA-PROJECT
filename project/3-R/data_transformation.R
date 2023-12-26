library(readr)
library(tidyverse)
data <- read_csv("../1-data/1-sample_data.csv")
data_additional <- read_csv("../1-data/2-additional_data.csv")
data_additional_features <- read_csv("../1-data/3-additional_features.csv")

appended_data <- rbind(data,data_additional)

joined_data <- inner_join(appended_data, data_additional_features, by = "id")
write_csv(joined_data, "../1-data/train_data.csv")
install.packages("shiny")
library(shiny)

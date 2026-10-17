
library(tidyverse)
library(httr)

print("Starting data update...")
Sys.sleep(4)

url <- paste0(
  "https://ec.europa.eu/eurostat/api/",
  "dissemination/statistics/1.0/data/nama_10_gdp?"
)

params <- list(
  time = "2023",
  unit = "CP_MEUR",
  na_item = "B1GQ",
  format = "JSON"
)

response <- GET(url = url, query = params)

print(status_code(response)) # should be 200
print("Fetched data")
Sys.sleep(4)

data <- content(response) # parses the JSON into a nested list

indices <- data$dimension$geo$category$index

gdp_data <- data.frame(
    geo = names(indices),
    index = as.character(unlist(indices))
  ) %>%
  left_join(
    enframe(unlist(data$value), name = "index", value = "values"),
    by = "index"
  ) %>%
  select(geo, values)

head(gdp_data)

print("Write data")
Sys.sleep(4)

write_csv(gdp_data, "C:/Users/schmo/Github/test-project/gdp_data.csv")

print("Job Done!")
Sys.sleep(4)

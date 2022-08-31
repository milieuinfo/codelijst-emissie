#!/usr/bin/Rscript
library(tidyr)
library(dplyr)
library(jsonlite)
setwd("/home/gehau/git/codelijst-emissie/src/main/R")

df <- read.csv(file = "../resources/be/vlaanderen/omgeving/data/id/conceptscheme/emissie/emissie.csv", sep=",", na.strings=c("","NA"))

df <- df %>%
  rename("@id" = uri,
         "@type" = type)
write.csv(df,"../resources/be/vlaanderen/omgeving/data/id/conceptscheme/emissie/emissie_separate_rows.csv", row.names = FALSE)
context <- jsonlite::read_json("../resources/be/vlaanderen/omgeving/data/id/conceptscheme/emissie/context.json")
df_in_list <- list('@graph' = df, '@context' = context)
df_in_json <- toJSON(df_in_list, auto_unbox=TRUE)
write(df_in_json, "/tmp/emissie.jsonld")


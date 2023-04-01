#!/usr/bin/Rscript
library(tidyr)
library(dplyr)
library(jsonlite)
library(stringr)
#setwd('/home/gehau/git/codelijst-emissie/src/main/R')
#setwd('/Users/pieter/work/git/codelijst-emissie/src/main/R')


# functie om dataframe om te zetten naar jsonld
to_jsonld <- function(dataframe) {
  # lees context
  context <- jsonlite::read_json("../resources/be/vlaanderen/omgeving/data/id/conceptscheme/emissie/context.json")
  # jsonld constructie
  df_in_list <- list('@graph' = dataframe, '@context' = context)
  df_in_json <- toJSON(df_in_list, auto_unbox=TRUE)
  return(df_in_json)
}

hasTopConcept_from_topConceptOf  <- function(df) {
  # hasTopConcept relatie uit inverse relatie
  schemes <- na.omit(distinct(df['topConceptOf']))
  for (scheme in as.list(schemes$topConceptOf)) {
    topconceptof <- subset(df, topConceptOf == scheme ,
                           select=c(uri, topConceptOf))
    hastopconcept <- as.list(topconceptof["uri"])
    df2 <- data.frame(scheme, hastopconcept)
    names(df2) <- c("uri","hasTopConcept")
    df <- bind_rows(df, df2)
  }
  return(df)
}

expand_df_on_pipe <- function(dataframe) {
  # fix voor vctrs_error_incompatible 
  df <- dataframe %>%
    mutate_all(list(~ str_c("", .)))
  # verdubbel rijen met pipe separator
  for(col in colnames(df)) {   # for-loop over columns
    df <- df %>%
      separate_rows(col, sep = "\\|")%>% 
      distinct()
  }
  return(df)
}
rename_columns <- function(df) {
  # rename columns
  df <- df %>%
    rename("@id" = uri,
           "@type" = type)
  return(df)
}

df <- read.csv(file = "../resources/be/vlaanderen/omgeving/data/id/conceptscheme/emissie/emissie.csv", sep=",", na.strings=c("","NA"))


df <- expand_df_on_pipe(df)%>% 
  hasTopConcept_from_topConceptOf()%>%
  rename_columns()

write.csv(df,"../resources/be/vlaanderen/omgeving/data/id/conceptscheme/emissie/emissie_separate_rows.csv", row.names = FALSE)


# bewaar jsonld
write(to_jsonld(df), "/tmp/emissie.jsonld")

# serialiseer jsonld naar mooie turtle en mooie jsonld
# hiervoor dienen jena cli-tools geinstalleerd, zie README.md
system("riot --formatted=TURTLE /tmp/emissie.jsonld > ../resources/be/vlaanderen/omgeving/data/id/conceptscheme/emissie/emissie.ttl")
system("riot --formatted=JSONLD ../resources/be/vlaanderen/omgeving/data/id/conceptscheme/emissie/emissie.ttl > ../resources/be/vlaanderen/omgeving/data/id/conceptscheme/emissie/emissie.jsonld")


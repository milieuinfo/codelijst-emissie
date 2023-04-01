#!/bin/bash

# Transform csv, ../resources/be/vlaanderen/omgeving/data/id/conceptscheme/emissie/emissie.csv
# to jsonld, /tmp/emissie.jsonld
# Rscript ../R/csv_to_json.R
Rscript ../R/csv_to_rdf.R

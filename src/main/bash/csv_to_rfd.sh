#!/bin/bash

# Transform csv, ../resources/be/vlaanderen/omgeving/data/id/conceptscheme/emissie/emissie.csv
# to jsonld, /tmp/emissie.jsonld
Rscript ../R/csv_to_json.R

# Make formatted jsonld and turtle
riot --formatted=TURTLE /tmp/emissie.jsonld   > '../resources/be/vlaanderen/omgeving/data/id/conceptscheme/emissie/emissie.ttl'
riot --formatted=JSONLD '../resources/be/vlaanderen/omgeving/data/id/conceptscheme/emissie/emissie.ttl'   > '../resources/be/vlaanderen/omgeving/data/id/conceptscheme/emissie/emissie.jsonld' 


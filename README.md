# codelijst-emissie

## Samenvatting
Lijst van types emissie, zoals die binnen het kader van het OSLO thema omgeving is opgesteld en tools om deze lijst te beheren en om te zetten naar webformaten.


## Gebruik

### Versienummer in pom.xml bestand
Het version element in het pom.xml bestand bevat het 'SNAPSHOT'-versienummer van de nieuwe release waarop gewerkt wordt.
Bv. '1.0.0' is de huidige release en '2.0.0' is de nieuwe release waarop gewerkt wordt. Dan is '2.0.0-SNAPSHOT' het 'SNAPSHOT'-versienummer in het pom.xml bestand.  
### Wijzigingen aan de codelijst doorvoeren
Pas het bron CSV bestand van de codelijst aan (src/main/resources/source/codelijst_source.csv).

Bv. Voeg een definitie van een nieuw type emissie toe.

### Genereer de verspreidingsvormen van de codelijst
#### csv naar rdf
```
cd $PROJECT_HOME/src/main/bash
bash csv_to_rdf.sh
```
#### rdf naar csv
```
cd $PROJECT_HOME/src/main/sparql
sparql --results=CSV --data=../resources/be/vlaanderen/omgeving/data/id/conceptscheme/emissie/emissie.ttl  --query rdf_to_csv.rq > ../resources/be/vlaanderen/omgeving/data/id/conceptscheme/emissie/emissie.csv
```
### Commit/push de wijzigingen
Geef steeds een duidelijke commit boodschap mee (i.e vermelding van de gelogde issues die zijn opgelost).

### Voorbereiding release
#### Valideer het versienummer
Het version element in het pom.xml bestand staat op het 'SNAPSHOT'-versienummer van de komende release staan.
Bv. '2.0.0' is het versienummer van de nieuwe release. Dan is '2.0.0-SNAPSHOT' het 'SNAPSHOT'-versienummer in het pom.xml bestand.
#### Genereer en voeg de metadata van de nieuwe codelijst versie toe
```
cd $PROJECT_HOME/src/main/bash
bash dcat-from-csv.sh
```
#### Commit/push metadata en eventuele andere wijzigingen

### Release
Release het overeenkomstige codelijsten project in Bamboo. Zie https://www.milieuinfo.be/bamboo/browse/CODELIJST

## Dependencies

**_RDF tools:_**

In dit project worden twee jena cli-tools gebruikt: riot en sparql.
Sparql wordt gebruikt om het rdf-formaat om te zetten naar csv, riot wordt gebruikt om de rdf-formaten om te zetten, e.i. json-ld naar turtle.
- Lees eerst [deze documentatie](https://jena.apache.org/documentation/tools/index.html).
- Installeer de jena [binaries](https://dlcdn.apache.org/jena/binaries/).
Bijvoorbeeld:
```
curl -O https://dlcdn.apache.org/jena/binaries/apache-jena-4.6.0.tar.gz
tar -xf apache-jena-4.6.0.tar.gz -C /opt
echo 'export PATH="/opt/apache-jena-4.6.0/bin:$PATH"' >> ~/.bashrc
. ~/.bashrc
```

**_R:_**

Met behulp van de tidyverse bibliotheek in R wordt de csv omgezet naar jsonld.
```
sudo apt install r-base build-essential r-cran-jsonlite r-cran-tidyr r-cran-dplyr
```



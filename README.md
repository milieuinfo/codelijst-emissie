# codelijst-emissie

## Samenvatting
Lijst van types emissie, zoals die binnen het kader van het OSLO thema omgeving is opgesteld en tools om deze lijst te beheren en om te zetten naar webformaten.

## Projectinhoud
In dit project worden de bron bestanden en de verschillende verspreidingsvormen van de codelijst beheerd.
Het project bevat ook tools om deze lijst te beheren en om te zetten naar webformaten.

## Gebruik

### Versienummer in pom.xml bestand
Het version element in het pom.xml bestand bevat het 'SNAPSHOT'-versienummer van de nieuwe release waarop gewerkt wordt.
Voorbeeld: Indien '1.0.0' de huidige release is en '2.0.0' is het versienummer van de nieuwe release waarop gewerkt wordt, dan is '2.0.0-SNAPSHOT' het versienummer in het pom.xml bestand.
### Wijzigingen aan de codelijst doorvoeren
Pas het bron CSV bestand van de codelijst aan (src/main/resources/source/codelijst_source.csv).

Voorbeeld: Voeg een definitie van een nieuwe code in de codelijst toe.

### Genereer de verspreidingsvormen van de codelijst
#### csv naar rdf
```
cd $PROJECT_HOME/src/main/bash
bash 01_csv_to_rdf.sh
```
Dit script gaat het bron CSV bestand omzetten naar een SKOS lijst in verschillende RDF formaten en een CSV bestand.
Het JSONLD context bestand van de codelijst (src/main/resources/source/codelijst_context.csv) bevat de mapping van CSV naar RDF.
#### custom csv(s)
Eventuele custom csv kan op basis van een sparql query gegenereerd worden
```
sparql --results=CSV --data={data_inputfile}  --query {file_containing_a_query} > {csv_outputfile}
```
Voorbeeld:
```
cd $PROJECT_HOME/src/main/sparql
sparql --results=CSV --data=../resources/be/vlaanderen/omgeving/data/id/conceptscheme/emissie/emissie.ttl  --query rdf_to_csv.rq > ../resources/be/vlaanderen/omgeving/data/id/conceptscheme/emissie/emissie.csv
```
### Commit/push de wijzigingen
Geef steeds een duidelijke commit boodschap mee (i.e vermelding van de gelogde issues die zijn opgelost).

### Voorbereiding release
#### Valideer het versienummer
Het version element in het pom.xml bestand staat op het 'SNAPSHOT'-versienummer van de komende release.
Voorbeeld: Indien '2.0.0' het versienummer is van de nieuwe release die gemaakt wordt, dan is '2.0.0-SNAPSHOT' het versienummer in het pom.xml bestand.
#### Genereer en voeg de metadata van de nieuwe codelijst versie toe
```
cd $PROJECT_HOME/src/main/bash
bash 99_dcat-from-csv.sh
```
Bij de release van een nieuwe codelijst versie moet de gepaste metadata voor die versie aangemaakt en toegevoegd worden aan de metadata van de codelijst. Voor het doorvoeren van wijzigingen aan de metadata kunnen de bron CSV bestanden van de metadata worden aangepast:
- src/main/resources/source/dataset_source.csv
- src/main/resources/source/catalog_source.csv

Het dataset_source.csv bestand wordt als template gebruikt om de metadata van de dataset en van een nieuwe codelijst versie te genereren. Het catalog_source.csv bestand bevat de metadata van de dataset en al zijn codelijst versies die in de catalogus gepubliceerd moeten worden. Dit is een "evolutief" bestand waar de metadata van een nieuwe versie telkens aan wordt toegevoegd.
Het script genereert op basis van deze 2 bron bestanden de gepaste DCAT metadata bestanden voor de codelijst en zijn verschillende versies.

Normaliter moet het bron bestand dataset_source.csv maar eenmalig worden opgesteld en aangepast voor de codelijst.
Het scriptje genereert op basis van dit template bestand de metadata van een nieuwe codelijst versie en voegt dit toe aan het andere bron bestand catalog_source.csv.
Het catalog_source.csv bestand kan zelf ook nog geediteerd worden.
Vervolgens genereert het scriptje op basis van het catalog_source.csv bestand de finale DCAT metadata bestanden van de codelijst en zijn versies.

Het JSONLD context bestand van de codelijst metadata (src/main/resources/source/codelijst_context.csv) bevat de mapping van CSV naar RDF.
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


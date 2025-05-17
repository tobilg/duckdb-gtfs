#!/bin/bash

mkdir -p source-data/providers/gtfs-de-full/

# Download the GTFS data from the URL
curl -o source-data/providers/gtfs-de-full/gtfs.zip https://download.gtfs.de/germany/free/latest.zip

# Unzip the GTFS data
unzip source-data/providers/gtfs-de-full/gtfs.zip -d source-data/providers/gtfs-de-full/
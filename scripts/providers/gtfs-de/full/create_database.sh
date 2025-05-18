#!/bin/bash

mkdir -p exported-data/providers/gtfs-de/full

cp database/gtfs.duckdb exported-data/providers/gtfs-de/full/data.duckdb

duckdb exported-data/providers/gtfs-de/full/data.duckdb < queries/providers/gtfs-de/full/load_data.sql

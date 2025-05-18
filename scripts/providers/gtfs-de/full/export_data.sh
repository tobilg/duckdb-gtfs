#!/bin/bash

mkdir -p exported-data/providers/gtfs-de/full

duckdb exported-data/providers/gtfs-de/full/data.duckdb -c "EXPORT DATABASE 'exported-data/providers/gtfs-de/full' (FORMAT parquet, COMPRESSION ZSTD);"
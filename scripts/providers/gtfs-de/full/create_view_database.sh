#!/bin/bash

mkdir -p exported-data/providers/gtfs-de/full

duckdb exported-data/providers/gtfs-de/full/database.duckdb < queries/providers/gtfs-de/full/create_view_database.sql
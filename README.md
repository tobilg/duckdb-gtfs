# duckdb-gtfs
Loading and analyzing GTFS Schedule data with DuckDB.

## GTFS Schedule DuckDB database
This projects provides an empty DuckDB database that contains the necessary tables and their relations for GTFS Schedule datasets. It can be found at [database/gtfs.duckdb](database/gtfs.duckdb).

The SQL script that created the DuckDB database can be found at [](). It's directly derived from the [official GTFS Schedule Field Definitions docs](https://gtfs.org/documentation/schedule/reference/#field-definitions).

## Loading an example dataset
To show the GTFS Schedule database can be used, this repo contains an example of how to transform and load a public dataset.

There’s a [German dataset](https://gtfs.de/de/feeds/de_full/) that contains the full train and local traffic for Germany.It contains 1.6 million trips, and 663 thousand stops.

### Usage
First, you need to clone this git repo locally. Then you can run the 
[scripts/providers/gtfs-de-full/download.sh](scripts/providers/gtfs-de-full/download.sh) script to download the data to the [source-data/providers/gtfs-de-full](source-data/providers/gtfs-de-full) directory.

After that, you can load the data to a copy of the pre-existing GTFS database with the following command:

```bash
$ cp database/gtfs.duckdb database/gtfs-de-full.duckdb

$ duckdb database/gtfs-de-full.duckdb < queries/providers/gtfs-de-full/load_gtfs.sql
```

Once this is done, you can open the DuckDB CLI to query the data:

```bash
$ duckdb database/gtfs-de-full.duckdb
```

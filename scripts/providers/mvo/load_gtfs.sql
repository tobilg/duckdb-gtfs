INSERT INTO agency (agency_id,agency_name,agency_url,agency_timezone,agency_lang,agency_phone) SELECT * FROM read_csv('source-data/mvoe/railway-schedules/20250426-0116_gtfs_evu_2025/agency.txt', delim = ',', header = true);

INSERT INTO calendar_dates (service_id,"date",exception_type) SELECT * FROM read_csv('source-data/mvoe/railway-schedules/20250426-0116_gtfs_evu_2025/calendar_dates.txt', delim = ',', header = true, columns = {
  'service_id': 'VARCHAR',
  'date': 'DATE',
  'exception_type': 'INTEGER'
}, dateformat = '%Y%m%d');

INSERT INTO calendar (service_id,monday,tuesday,wednesday,thursday,friday,saturday,sunday,start_date,end_date) 
SELECT * FROM read_csv('source-data/mvoe/railway-schedules/20250426-0116_gtfs_evu_2025/calendar.txt', delim = ',', header = true, dateformat = '%Y%m%d');

INSERT INTO feed_info (feed_publisher_name,feed_publisher_url,feed_lang,feed_start_date,feed_end_date,feed_version,feed_contact_email,feed_contact_url) 
SELECT * FROM read_csv('source-data/mvoe/railway-schedules/20250426-0116_gtfs_evu_2025/feed_info.txt', delim = ',', header = true, dateformat = '%Y%m%d');

INSERT INTO levels (level_id,level_index,level_name) 
SELECT * FROM read_csv('source-data/mvoe/railway-schedules/20250426-0116_gtfs_evu_2025/levels.txt', delim = ',', header = true);

INSERT INTO pathways (pathway_id,from_stop_id,to_stop_id,pathway_mode,is_bidirectional,traversal_time) 
SELECT * EXCLUDE (row_num) FROM (SELECT DISTINCT row_number() OVER (PARTITION BY pathway_id) row_num, * FROM read_csv('source-data/mvoe/railway-schedules/20250426-0116_gtfs_evu_2025/pathways.txt', delim = ',', header = true)) WHERE row_num = 1;

INSERT INTO routes (route_id,agency_id,route_short_name,route_long_name,route_type) 
SELECT * FROM read_csv('source-data/mvoe/railway-schedules/20250426-0116_gtfs_evu_2025/routes.txt', delim = ',', header = true);

INSERT INTO shapes (shape_id,shape_pt_lat,shape_pt_lon,shape_pt_sequence,shape_dist_traveled) 
SELECT * FROM read_csv('source-data/mvoe/railway-schedules/20250426-0116_gtfs_evu_2025/shapes.txt', delim = ',', header = true);

INSERT INTO stop_times (trip_id,arrival_time,departure_time,stop_id,stop_sequence,stop_headsign,pickup_type,drop_off_type,shape_dist_traveled) 
SELECT * FROM read_csv('source-data/mvoe/railway-schedules/20250426-0116_gtfs_evu_2025/stop_times.txt', delim = ',', header = true, ignore_errors = true);

INSERT INTO stops (stop_id,stop_name,stop_lat,stop_lon,zone_id,location_type,parent_station,level_id,platform_code) 
SELECT * FROM read_csv('source-data/mvoe/railway-schedules/20250426-0116_gtfs_evu_2025/stops.txt', delim = ',', header = true);

INSERT INTO transfers (from_stop_id,to_stop_id,from_route_id,to_route_id,from_trip_id,to_trip_id,transfer_type,min_transfer_time) 
SELECT * FROM read_csv('source-data/mvoe/railway-schedules/20250426-0116_gtfs_evu_2025/transfers.txt', delim = ',', header = true);

INSERT INTO trips (route_id,service_id,trip_id,shape_id,trip_headsign,trip_short_name,direction_id,block_id) 
SELECT * FROM read_csv('source-data/mvoe/railway-schedules/20250426-0116_gtfs_evu_2025/trips.txt', delim = ',', header = true);

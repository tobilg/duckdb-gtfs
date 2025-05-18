INSERT INTO agency (agency_id,agency_name,agency_url,agency_timezone,agency_lang) SELECT * FROM read_csv('source-data/providers/gtfs-de/full/agency.txt', delim = ',', header = true);

INSERT INTO attributions (attribution_id,organization_name,is_producer,attribution_url,attribution_email) SELECT * FROM read_csv('source-data/providers/gtfs-de/full/attributions.txt', delim = ',', header = true);

INSERT INTO calendar (monday,tuesday,wednesday,thursday,friday,saturday,sunday,start_date,end_date,service_id) 
SELECT * FROM read_csv('source-data/providers/gtfs-de/full/calendar.txt', delim = ',', header = true, dateformat = '%Y%m%d');

INSERT INTO calendar_dates (service_id,exception_type,"date") SELECT * FROM read_csv('source-data/providers/gtfs-de/full/calendar_dates.txt', delim = ',', header = true, columns = {
  'service_id': 'VARCHAR',
  'exception_type': 'INTEGER',
  'date': 'DATE'
}, dateformat = '%Y%m%d', ignore_errors = true);

INSERT INTO feed_info (feed_publisher_name,feed_publisher_url,feed_lang,feed_version,feed_contact_email,feed_contact_url) 
SELECT * FROM read_csv('source-data/providers/gtfs-de/full/feed_info.txt', delim = ',', header = true, dateformat = '%Y%m%d');

INSERT INTO routes (route_long_name,route_short_name,agency_id,route_type,route_id) 
SELECT * FROM read_csv('source-data/providers/gtfs-de/full/routes.txt', delim = ',', header = true);

INSERT INTO trips (route_id,service_id,trip_id) 
SELECT * FROM read_csv('source-data/providers/gtfs-de/full/trips.txt', delim = ',', header = true, ignore_errors = true);

INSERT INTO stops (stop_name,parent_station,stop_id,stop_lat,stop_lon,location_type) 
SELECT * FROM read_csv('source-data/providers/gtfs-de/full/stops.txt', delim = ',', header = true);

INSERT INTO stop_times (trip_id,arrival_time,departure_time,stop_id,stop_sequence,pickup_type,drop_off_type) 
SELECT * FROM read_csv('source-data/providers/gtfs-de/full/stop_times.txt', delim = ',', header = true, ignore_errors = true);
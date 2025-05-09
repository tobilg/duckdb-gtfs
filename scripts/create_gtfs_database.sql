-- GTFS Database Schema for DuckDB
-- Based on GTFS Specification v2.0

-- levels.txt
CREATE TABLE levels (
    level_id TEXT PRIMARY KEY,
    level_index DOUBLE NOT NULL,
    level_name TEXT
);

-- agency.txt
CREATE TABLE agency (
    agency_id TEXT PRIMARY KEY,
    agency_name TEXT NOT NULL,
    agency_url TEXT NOT NULL,
    agency_timezone TEXT NOT NULL,
    agency_lang TEXT,
    agency_phone TEXT,
    agency_fare_url TEXT,
    agency_email TEXT
);

-- areas.txt
CREATE TABLE areas (
    area_id TEXT PRIMARY KEY,
    area_name TEXT
);

-- networks.txt
CREATE TABLE networks (
    network_id TEXT PRIMARY KEY,
    network_name TEXT NOT NULL
);

-- location_groups.txt
CREATE TABLE location_groups (
    location_group_id TEXT PRIMARY KEY,
    location_group_name TEXT NOT NULL
);

-- booking_rules.txt
CREATE TABLE booking_rules (
    booking_rule_id TEXT PRIMARY KEY,
    booking_type INTEGER NOT NULL,
    prior_notice_duration_min INTEGER,
    prior_notice_duration_max INTEGER,
    prior_notice_last_day INTEGER,
    prior_notice_last_time TIME,
    prior_notice_start_day INTEGER,
    prior_notice_start_time TIME,
    prior_notice_service_id TEXT,
    message TEXT,
    pickup_message TEXT,
    drop_off_message TEXT,
    phone_number TEXT,
    info_url TEXT,
    booking_url TEXT
);

-- calendar.txt
CREATE TABLE calendar (
    service_id TEXT PRIMARY KEY,
    monday INTEGER NOT NULL,
    tuesday INTEGER NOT NULL,
    wednesday INTEGER NOT NULL,
    thursday INTEGER NOT NULL,
    friday INTEGER NOT NULL,
    saturday INTEGER NOT NULL,
    sunday INTEGER NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);

-- stops.txt
CREATE TABLE stops (
    stop_id TEXT PRIMARY KEY,
    stop_code TEXT,
    stop_name TEXT,
    tts_stop_name TEXT,
    stop_desc TEXT,
    stop_lat DOUBLE,
    stop_lon DOUBLE,
    zone_id TEXT,
    stop_url TEXT,
    location_type INTEGER,
    parent_station TEXT,
    stop_timezone TEXT,
    wheelchair_boarding INTEGER,
    level_id TEXT,
    platform_code TEXT,
    FOREIGN KEY (level_id) REFERENCES levels(level_id),
    FOREIGN KEY (parent_station) REFERENCES stops(stop_id)
);

-- routes.txt
CREATE TABLE routes (
    route_id TEXT PRIMARY KEY,
    agency_id TEXT,
    route_short_name TEXT,
    route_long_name TEXT,
    route_desc TEXT,
    route_type INTEGER NOT NULL,
    route_url TEXT,
    route_color TEXT,
    route_text_color TEXT,
    route_sort_order INTEGER,
    continuous_pickup INTEGER,
    continuous_drop_off INTEGER,
    network_id TEXT,
    FOREIGN KEY (agency_id) REFERENCES agency(agency_id)
);

-- trips.txt
CREATE TABLE trips (
    route_id TEXT NOT NULL,
    service_id TEXT NOT NULL,
    trip_id TEXT PRIMARY KEY,
    trip_headsign TEXT,
    trip_short_name TEXT,
    direction_id INTEGER,
    block_id TEXT,
    shape_id TEXT,
    wheelchair_accessible INTEGER,
    bikes_allowed INTEGER,
    FOREIGN KEY (route_id) REFERENCES routes(route_id)
);

-- stop_times.txt
CREATE TABLE stop_times (
    trip_id TEXT NOT NULL,
    arrival_time TIME,
    departure_time TIME,
    stop_id TEXT NOT NULL,
    location_group_id TEXT,
    location_id TEXT,
    stop_sequence INTEGER NOT NULL,
    stop_headsign TEXT,
    start_pickup_drop_off_window TIME,
    end_pickup_drop_off_window TIME,
    pickup_type INTEGER,
    drop_off_type INTEGER,
    continuous_pickup INTEGER,
    continuous_drop_off INTEGER,
    shape_dist_traveled DOUBLE,
    timepoint INTEGER,
    pickup_booking_rule_id TEXT,
    drop_off_booking_rule_id TEXT,
    FOREIGN KEY (trip_id) REFERENCES trips(trip_id),
    FOREIGN KEY (stop_id) REFERENCES stops(stop_id),
    FOREIGN KEY (pickup_booking_rule_id) REFERENCES booking_rules(booking_rule_id),
    FOREIGN KEY (drop_off_booking_rule_id) REFERENCES booking_rules(booking_rule_id)
);

-- calendar_dates.txt
CREATE TABLE calendar_dates (
    service_id TEXT NOT NULL,
    "date" DATE NOT NULL,
    exception_type INTEGER NOT NULL,
    FOREIGN KEY (service_id) REFERENCES calendar(service_id)
);

-- fare_attributes.txt
CREATE TABLE fare_attributes (
    fare_id TEXT PRIMARY KEY,
    price DOUBLE NOT NULL,
    currency_type TEXT NOT NULL,
    payment_method INTEGER NOT NULL,
    transfers INTEGER,
    agency_id TEXT,
    transfer_duration INTEGER,
    FOREIGN KEY (agency_id) REFERENCES agency(agency_id)
);

-- fare_rules.txt
CREATE TABLE fare_rules (
    fare_id TEXT NOT NULL,
    route_id TEXT,
    origin_id TEXT,
    destination_id TEXT,
    contains_id TEXT,
    FOREIGN KEY (fare_id) REFERENCES fare_attributes(fare_id),
    FOREIGN KEY (route_id) REFERENCES routes(route_id)
);

-- stop_areas.txt
CREATE TABLE stop_areas (
    area_id TEXT NOT NULL,
    stop_id TEXT NOT NULL,
    FOREIGN KEY (area_id) REFERENCES areas(area_id),
    FOREIGN KEY (stop_id) REFERENCES stops(stop_id)
);

-- route_networks.txt
CREATE TABLE route_networks (
    route_id TEXT NOT NULL,
    network_id TEXT NOT NULL,
    FOREIGN KEY (route_id) REFERENCES routes(route_id),
    FOREIGN KEY (network_id) REFERENCES networks(network_id)
);

-- shapes.txt
CREATE TABLE shapes (
    shape_id TEXT NOT NULL,
    shape_pt_lat DOUBLE NOT NULL,
    shape_pt_lon DOUBLE NOT NULL,
    shape_pt_sequence INTEGER NOT NULL,
    shape_dist_traveled DOUBLE
);

-- frequencies.txt
CREATE TABLE frequencies (
    trip_id TEXT NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    headway_secs INTEGER NOT NULL,
    exact_times INTEGER
);

-- transfers.txt
CREATE TABLE transfers (
    from_stop_id TEXT NOT NULL,
    to_stop_id TEXT NOT NULL,
    from_route_id TEXT,
    to_route_id TEXT,
    from_trip_id TEXT,
    to_trip_id TEXT,
    transfer_type INTEGER NOT NULL,
    min_transfer_time INTEGER,
    FOREIGN KEY (from_stop_id) REFERENCES stops(stop_id),
    FOREIGN KEY (to_stop_id) REFERENCES stops(stop_id),
    FOREIGN KEY (from_trip_id) REFERENCES trips(trip_id),
    FOREIGN KEY (to_trip_id) REFERENCES trips(trip_id),
    FOREIGN KEY (from_route_id) REFERENCES routes(route_id),
    FOREIGN KEY (to_route_id) REFERENCES routes(route_id)
);

-- pathways.txt
CREATE TABLE pathways (
    pathway_id TEXT PRIMARY KEY,
    from_stop_id TEXT NOT NULL,
    to_stop_id TEXT NOT NULL,
    pathway_mode INTEGER NOT NULL,
    is_bidirectional INTEGER NOT NULL,
    "length" DOUBLE,
    traversal_time INTEGER,
    stair_count INTEGER,
    max_slope DOUBLE,
    min_width DOUBLE,
    signposted_as TEXT,
    reversed_signposted_as TEXT,
    FOREIGN KEY (from_stop_id) REFERENCES stops(stop_id),
    FOREIGN KEY (to_stop_id) REFERENCES stops(stop_id)
);

-- timeframes.txt
CREATE TABLE timeframes (
    timeframe_group_id TEXT PRIMARY KEY,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    service_id TEXT
);

-- rider_categories.txt
CREATE TABLE rider_categories (
    rider_category_id TEXT PRIMARY KEY,
    rider_category_name TEXT NOT NULL,
    is_default_fare_category INTEGER NOT NULL,
    eligibility_url TEXT
);

-- fare_media.txt
CREATE TABLE fare_media (
    fare_media_id TEXT PRIMARY KEY,
    fare_media_name TEXT,
    fare_media_type INTEGER NOT NULL
);

-- fare_products.txt
CREATE TABLE fare_products (
    fare_product_id TEXT PRIMARY KEY,
    fare_product_name TEXT NOT NULL,
    rider_category_id TEXT,
    fare_media_id TEXT,
    amount DOUBLE NOT NULL,
    currency TEXT NOT NULL
);

-- fare_leg_rules.txt
CREATE TABLE fare_leg_rules (
    leg_group_id TEXT,
    network_id TEXT,
    from_area_id TEXT,
    to_area_id TEXT,
    from_timeframe_group_id TEXT,
    to_timeframe_group_id TEXT,
    fare_product_id TEXT NOT NULL,
    rule_priority INTEGER
);

-- fare_leg_join_rules.txt
CREATE TABLE fare_leg_join_rules (
    from_network_id TEXT NOT NULL,
    to_network_id TEXT NOT NULL,
    from_stop_id TEXT,
    to_stop_id TEXT
);

-- fare_transfer_rules.txt
CREATE TABLE fare_transfer_rules (
    from_leg_group_id TEXT,
    to_leg_group_id TEXT,
    transfer_count INTEGER NOT NULL,
    duration_limit INTEGER,
    duration_limit_type INTEGER,
    fare_transfer_type INTEGER NOT NULL,
    fare_product_id TEXT
);

-- location_group_stops.txt
CREATE TABLE location_group_stops (
    location_group_id TEXT NOT NULL,
    stop_id TEXT NOT NULL,
    FOREIGN KEY (location_group_id) REFERENCES location_groups(location_group_id),
    FOREIGN KEY (stop_id) REFERENCES stops(stop_id)
);

-- translations.txt
CREATE TABLE translations (
    table_name TEXT NOT NULL,
    field_name TEXT NOT NULL,
    language TEXT NOT NULL,
    translation TEXT NOT NULL,
    record_id TEXT,
    record_sub_id TEXT,
    field_value TEXT
);

-- feed_info.txt
CREATE TABLE feed_info (
    feed_publisher_name TEXT NOT NULL,
    feed_publisher_url TEXT NOT NULL,
    feed_lang TEXT NOT NULL,
    default_lang TEXT,
    feed_start_date TEXT,
    feed_end_date TEXT,
    feed_version TEXT,
    feed_contact_email TEXT,
    feed_contact_url TEXT
);

-- attributions.txt
CREATE TABLE attributions (
    attribution_id TEXT,
    agency_id TEXT,
    route_id TEXT,
    trip_id TEXT,
    organization_name TEXT NOT NULL,
    is_producer INTEGER,
    is_operator INTEGER,
    is_authority INTEGER,
    attribution_url TEXT,
    attribution_email TEXT,
    attribution_phone TEXT
);

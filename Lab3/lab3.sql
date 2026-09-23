-- 1
INSERT into airport
(airport_id, airport_name, country, state, city, created_at, updated_at)
select
    1000 + i,
    'Airport ' || i,
    (ARRAY['Kazakhstan','USA','UK','France','Germany'])
        [floor(random() * 5 + 1)::int],
    (ARRAY['Almaty Region','Astana Region','California','Texas','Bavaria'])
        [floor(random() * 5 + 1)::int],
    (ARRAY['Almaty','Astana','London','Tokyo','Paris'])
        [floor(random() * 5 + 1)::int],
    CURRENT_TIMESTAMP,
    current_timestamp
FROM generate_series(1,200) AS i;


-- 2
insert INTO airline
(airline_id, airline_code, airline_name, airline_country, created_at, updated_at)
VALUES
(100, 'KAZ', 'KazAir', 'Kazakhstan', CURRENT_TIMESTAMP, current_timestamp);


-- 3
UPDATE airline
set airline_country = 'Turkey'
WHERE airline_name = 'KazAir';


-- 4
INSERT INTO airline
(airline_id, airline_code, airline_name, airline_country, created_at, updated_at)
values
(101, 'AE', 'AirEasy', 'France', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(102, 'FH', 'FlyHigh', 'Brazil', current_timestamp, CURRENT_TIMESTAMP),
(103, 'FF', 'FlyFly', 'Poland', CURRENT_TIMESTAMP, current_timestamp);


-- 5
delete FROM flights
WHERE act_arrival_time >= '2024-01-01'
and act_arrival_time < '2025-01-01';


-- 6
UPDATE booking
SET ticket_price = ticket_price * 1.15;


-- 7
delete from booking
WHERE ticket_price < 10000;


-- 8
UPDATE airline
set airline_code = 'UNK'
where airline_code IS NULL;


-- 9
DELETE FROM baggage_check
where created_at < '2023-06-01'
AND check_result = 'Not checked';


-- 10
delete FROM airport
WHERE state IS NULL
and city IN ('Mlawe', 'Kepuh');


-- 11
INSERT into baggage_check
(baggage_check_id, check_result, created_at, updated_at, booking_id, passenger_id)
VALUES
(100, 'Not checked', CURRENT_TIMESTAMP, current_timestamp, 1, 1)
RETURNING baggage_check_id, created_at;


-- 12
update airline
SET airline_country = UPPER(airline_country);


-- 13
UPDATE airline
set airline_name = 'Global Airways',
    airline_country = 'United Kingdom',
    updated_at = CURRENT_TIMESTAMP
WHERE airline_id = 5;


-- 14
update airport
SET state = 'Capital District'
where city IN ('Astana', 'London', 'Tokyo');


-- 15
UPDATE baggage_check
SET check_result = 'Checked'
where created_at >= '2024-03-01'
AND created_at < '2024-04-01'
and check_result = 'Not checked';

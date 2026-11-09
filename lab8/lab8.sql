--1
CREATE INDEX IF NOT EXISTS idx_actual_departure
on flights(act_departure_time);

select * from pg_indexes
WHERE tablename = 'flights';


--2
alter table flights
ADD COLUMN IF NOT EXISTS flight_no varchar(20);

UPDATE flights
set flight_no = 'FL' || flight_id
where flight_no is null;

create UNIQUE INDEX idx_flight_no_date
ON flights(flight_no, sch_time);

--3
CREATE INDEX IF NOT EXISTS idx_airport_route
on flights(departing_airport_id, arriving_airport_id);

select * FROM pg_indexes
where tablename = 'flights';


--4
drop index if EXISTS idx_actual_departure;

EXPLAIN ANALYZE
select * from flights
where act_departure_time = (
    SELECT min(act_departure_time) from flights
);

CREATE index idx_actual_departure
on flights(act_departure_time);

explain analyze
SELECT * from flights
where act_departure_time = (
    select min(act_departure_time) FROM flights
);


--5
EXPLAIN ANALYZE
select * FROM flights
where departing_airport_id = 1
and arriving_airport_id = 2;


--6
create UNIQUE INDEX IF NOT EXISTS idx_passport
ON passengers(passport_number);

select indexname, indexdef
from pg_indexes
WHERE tablename = 'passengers';

WITH ids AS (
    select coalesce(max(passenger_id), 0) as last_id
    from passengers
)
INSERT INTO passengers
(passenger_id, first_name, last_name, date_of_birth,
 gender, country_of_citizenship, country_of_residence,
 passport_number, created_at, updated_at)
select last_id + 1, 'Ali', 'Nurlan', '2002-05-14',
       'Male', 'Kazakhstan', 'Kazakhstan',
       'LAB7P001', now(), now()
from ids
ON CONFLICT DO NOTHING;

WITH ids AS (
    select coalesce(max(passenger_id), 0) as last_id
    from passengers
)
insert into passengers
(passenger_id, first_name, last_name, date_of_birth,
 gender, country_of_citizenship, country_of_residence,
 passport_number, created_at, updated_at)
select last_id + 1, 'Dana', 'Askar', '2003-08-20',
       'Female', 'Kazakhstan', 'Kazakhstan',
       'LAB7P002', now(), now()
from ids
ON CONFLICT DO NOTHING;

select * from passengers
WHERE passport_number in ('LAB7P001', 'LAB7P002');


--7
CREATE INDEX IF NOT EXISTS idx_passenger_info
on passengers(country_of_citizenship, date_of_birth,
              first_name, last_name);

EXPLAIN ANALYZE
select * FROM passengers
where country_of_citizenship = 'Philippines'
and date_of_birth >= '1984-01-01'
and date_of_birth < '1985-01-01';


--8
select indexname, indexdef
FROM pg_indexes
where tablename = 'passengers';

DROP INDEX IF EXISTS idx_passport;
drop index if exists idx_passenger_info;

SELECT indexname, indexdef
from pg_indexes
WHERE tablename = 'passengers';


--9
drop INDEX if exists idx_booking_passenger;

EXPLAIN ANALYZE
select * from booking
where passenger_id = 100;

CREATE INDEX idx_booking_passenger
on booking(passenger_id);

explain analyze
SELECT * FROM booking
where passenger_id = 100;


--10
CREATE INDEX IF NOT EXISTS idx_booking_flight
ON booking_flight(booking_id, flight_id);

EXPLAIN ANALYZE
select f.flight_no, b.ticket_price
from booking b
JOIN booking_flight bf
on b.booking_id = bf.booking_id
join flights f
ON bf.flight_id = f.flight_id
where b.ticket_price > 9000;

select * from pg_indexes
WHERE tablename = 'booking_flight';


--11
alter TABLE flights
add column IF NOT EXISTS status varchar(30);

UPDATE flights
set status = case
    when flight_id % 10 = 0 then 'Boarding'
    else 'Departed'
end
where status IS NULL;

CREATE index IF NOT EXISTS idx_flight_status
on flights(status);

EXPLAIN ANALYZE
select * from flights
where status = 'Departed';

explain analyze
SELECT * from flights
where status = 'Boarding';


--12
create INDEX IF NOT EXISTS idx_baggage_weight
ON baggage(weight_in_kg);

EXPLAIN ANALYZE
select * FROM baggage
where weight_in_kg > 49;

explain analyze
SELECT * from baggage
where weight_in_kg > 5;


--13
CREATE INDEX IF NOT EXISTS idx_airport_name
on airport(airport_name varchar_pattern_ops);

EXPLAIN ANALYZE
select * from airport
WHERE airport_name LIKE 'A%';

explain analyze
SELECT * FROM airport
where airport_name LIKE '%Airport';


--14
create index IF NOT EXISTS idx_airport_country_city
ON airport(country, city);

EXPLAIN ANALYZE
select * from airport
where country = 'Philippines';

explain analyze
SELECT * from airport
where city = 'Manila';

EXPLAIN ANALYZE
select * FROM airport
where country = 'Philippines'
and city = 'Manila';


--15
CREATE INDEX IF NOT EXISTS idx_lower_lastname
on passengers(LOWER(last_name));

EXPLAIN ANALYZE
select * from passengers
WHERE lower(last_name) = 'irnis';

explain analyze
SELECT * FROM passengers
where last_name = 'Irnis';


--16
create INDEX IF NOT EXISTS idx_booking_cover
on booking(passenger_id)
INCLUDE (ticket_price);

ANALYZE booking;

EXPLAIN ANALYZE
select ticket_price
FROM booking
where passenger_id = 100;


--17
select airline_code, count(*)
from airline
GROUP BY airline_code
having count(*) > 1;

WITH duplicates AS (
    select airline_id, airline_code,
           row_number() over (
               partition by airline_code
               order by airline_id
           ) as rn
    from airline
)
UPDATE airline a
set airline_code = 'L7_' || a.airline_id
FROM duplicates d
where a.airline_id = d.airline_id
and d.rn > 1;

CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_airline_code
on airline(airline_code);

select indexname, indexdef
FROM pg_indexes
where tablename = 'airline';

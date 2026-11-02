--1
select f.*
from flights as f
join airline as a
ON f.airline_id =a.airline_id
where a.airline_name ='KazAir';
--2
SELECT f.flight_id,a.airport_name
from flights as f
Join airport as a
on f.departing_airport_id = a.airport_id
--3
SELECT  a.airline_name
from airline as a
left join flights as f
on a.airline_id=f.airline_id
and f.sch_time::timestamp>=date_trunc('month',current_date)+interval '1 month'
and f.sch_time::timestamp<date_trunc('month',current_date) +interval '2 month'
where f.flight_id is null;
--4
SELECT p.first_name, p.last_name
From passengers as p
join booking as b
on p.passenger_id=b.passenger_id
join flights as f
on f.flight_id=b.flight_id
where f.flight_id=1;
--5
select
    f.flight_id,
    AVG(b.ticket_price) as average_price,
    SUM(b.ticket_price) as total_price,
    MIN(b.ticket_price) as min_price,
    MAX(b.ticket_price) as max_price
from flights as f
left join booking as b
on f.flight_id=b.flight_id
group by f.flight_id;
--6
SELECT f.flight_id,a.airline_name,ap.country
from flights as f
join airport as ap
on f.arriving_airport_id=ap.airport_id
join airline as a
on f.airline_id=a.airline_id
where country='France'
--7
select p.first_name,p.last_name,ap.city
from passengers as p
join booking as b
on p.passenger_id = b.passenger_id
join flights as f
on b.flight_id=f.flight_id
join airport as ap
on f.arriving_airport_id=ap.airport_id
where p.date_of_birth>current_date - interval '18 years';
--8
select
    p.first_name || ' ' || p.last_name AS full_name,
    p.passport_number,
    f.act_arrival_time
from passengers as p
join booking as b
on p.passenger_id=b.passenger_id
join flights as f
on b.flight_id=f.flight_id
--9
SELECT
    ap.country,
    COUNT(*) AS flights_count
FROM flights AS f
JOIN airline AS a
    ON f.airline_id = a.airline_id
JOIN airport AS ap
    ON f.departing_airport_id = ap.airport_id
WHERE a.airline_country = ap.country
GROUP BY ap.country;
--10
SELECT
    f.flight_id,
    a.airline_name,
    dep.airport_name AS departure_airport,
    arr.airport_name AS arrival_airport
FROM flights AS f
JOIN airline AS a
    ON f.airline_id = a.airline_id
JOIN airport AS dep
    ON f.departing_airport_id = dep.airport_id
JOIN airport AS arr
    ON f.arriving_airport_id = arr.airport_id;
--11

SELECT
    p.first_name || ' ' || p.last_name AS full_name,
    f.flight_id
FROM passengers AS p
JOIN booking AS b
    ON p.passenger_id = b.passenger_id
JOIN flights AS f
    ON b.flight_id = f.flight_id
JOIN airline AS a
    ON f.airline_id = a.airline_id
WHERE a.airline_id = 5;
--12

SELECT
    f.flight_id,
    ap.country AS destination_country,
    COUNT(DISTINCT b.passenger_id) AS passenger_count
FROM flights AS f
JOIN airport AS ap
    ON f.arriving_airport_id = ap.airport_id
LEFT JOIN booking AS b
    ON f.flight_id = b.flight_id
GROUP BY f.flight_id, ap.country;

--13

SELECT
    p.passenger_id,
    p.first_name,
    p.last_name
FROM passengers AS p
LEFT JOIN booking AS b
    ON p.passenger_id = b.passenger_id
WHERE b.booking_id IS NULL;

--14

SELECT
    a.airline_name,
    COUNT(f.flight_id) AS total_flights
FROM airline AS a
LEFT JOIN flights AS f
    ON a.airline_id = f.airline_id
GROUP BY a.airline_id, a.airline_name
ORDER BY total_flights DESC;

--15

SELECT
    a.airline_name,
    f.flight_id,
    ap.city AS departure_city
FROM flights AS f
JOIN airline AS a
    ON f.airline_id = a.airline_id
JOIN airport AS ap
    ON f.departing_airport_id = ap.airport_id
WHERE ap.country = 'Kazakhstan';


--1
ALTER table passenger
ADD constraint check_age
CHECK (date_of_birth <= current_date - interval '10 years');


--2
alter TABLE booking
add constraint check_price
CHECK (ticket_price between 0 and 50000);


--3
ALTER table baggage
Add constraint check_weight
check (weight_kg between 1 and 23);


--4
alter table airport
ADD constraint check_airport_name
CHECK (length(airport_name) >= 10);


--5
ALTER table airport
add constraint unique_airport_name
UNIQUE (airport_name);

alter TABLE airline
ADD constraint unique_airline_name
unique (name);

ALTER table flight
add constraint unique_flight
UNIQUE (airline_id, scheduled_departure_time);

alter table booking
ADD constraint unique_booking
unique (flight_id, passenger_id);

ALTER table booking_change
ADD constraint unique_change
unique (booking_id, created_at);

alter TABLE boarding_pass
add constraint unique_boarding
UNIQUE (booking_id);

ALTER table baggage
ADD constraint unique_baggage
unique (booking_id, weight_kg);

alter table baggage_checking
ADD constraint unique_checking
UNIQUE (baggage_id, passenger_id);

ALTER table security_check
add constraint unique_security
UNIQUE (passenger_id, created_at);


--6
ALTER table passenger
add constraint check_gender_age
CHECK (
    (gender = 'Male' AND date_of_birth <= current_date - interval '18 years')
    OR
    (gender = 'Female' AND date_of_birth <= current_date - interval '19 years')
);


--7
Alter table passenger
ADD constraint check_country_age
check (
    (country_of_citizenship = 'Kazakhstan'
    AND date_of_birth <= current_date - interval '18 years')
    OR
    (country_of_citizenship = 'France'
    AND date_of_birth <= current_date - interval '17 years')
    OR
    (country_of_citizenship NOT IN ('Kazakhstan','France')
    AND date_of_birth <= current_date - interval '19 years')
);


--8
ALTER table booking
ADD COLUMN ticket_discount numeric(10,2);

UPDATE booking
SET ticket_discount =
CASE
    WHEN created_at > '2024-01-01'
    THEN round(ticket_price * 0.05, 2)
    ELSE round(ticket_price * 0.10, 2)
END;

alter TABLE booking
ADD constraint check_discount
CHECK (
    (created_at > '2024-01-01'
    AND ticket_discount = round(ticket_price * 0.05, 2))
    OR
    (created_at <= '2024-01-01'
    AND ticket_discount = round(ticket_price * 0.10, 2))
);


--9
ALTER table booking
ALTER COLUMN status
SET DEFAULT 'Confirmed';

INSERT into booking
(booking_id, passenger_id, flight_id, booking_platform,
created_at, updated_at, ticket_price, ticket_discount)
SELECT
    (SELECT coalesce(max(booking_id), 0) + 1 FROM booking),
    p.passenger_id,
    f.flight_id,
    'Online',
    current_timestamp,
    current_timestamp,
    15000,
    750
FROM passenger p
CROSS JOIN flight f
WHERE NOT EXISTS (
    SELECT 1 FROM booking b
    WHERE b.passenger_id = p.passenger_id
    AND b.flight_id = f.flight_id
)
LIMIT 1;

SELECT booking_id, booking_platform, status, ticket_price
FROM booking
ORDER BY booking_id DESC
LIMIT 1;


--10
ALTER table booking
ALTER COLUMN created_at
SET DEFAULT current_timestamp;

alter TABLE booking
ALTER COLUMN updated_at
SET DEFAULT current_timestamp;

--1
CREATE OR REPLACE PROCEDURE add_flight1(
    p_flight_id INT,
    p_flight_no VARCHAR,
    p_airline_id INT,
    p_departure_airport_id INT,
    p_arrival_airport_id INT,
    p_scheduled_departure TIMESTAMP,
    p_status VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO flights(
        flight_id,
        flight_no,
        airline_id,
        departure_airport_id,
        arrival_airport_id,
        scheduled_departure,
        status
    )
    VALUES (
        p_flight_id,
        p_flight_no,
        p_airline_id,
        p_departure_airport_id,
        p_arrival_airport_id,
        p_scheduled_departure,
        p_status
    );
END;
$$;
CALL add_flight1(
    9999,
    'KC999',
    1,
    1,
    2,
    '2026-12-10 10:00:00',
    'Scheduled'
);


--2
CREATE OR REPLACE PROCEDURE update_flight_status(
    p_flight_id INT,
    p_status VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE flights
    SET status = p_status
    WHERE flight_id = p_flight_id;
END;
$$;

CALL update_flight_status(5, 'Departed');

--3
CREATE OR REPLACE PROCEDURE get_airport_flights(
    p_airport_id INT,
    INOUT p_cursor REFCURSOR
)
LANGUAGE plpgsql
AS $$
BEGIN
    OPEN p_cursor FOR
    SELECT *
    FROM flights
    WHERE departure_airport_id = p_airport_id;
END;
$$;

BEGIN;
CALL get_airport_flights(1, 'airport_cursor');
FETCH ALL FROM airport_cursor;
COMMIT;

--4
CREATE OR REPLACE FUNCTION average_delay(
    p_airport_id INT
)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    avg_result NUMERIC;
BEGIN
    SELECT AVG(
        GREATEST(
            EXTRACT(EPOCH FROM
                (actual_arrival - scheduled_arrival)
            ) / 60,
            0
        )
    )
    INTO avg_result
    FROM flights
    WHERE arrival_airport_id = p_airport_id
      AND actual_arrival IS NOT NULL
      AND scheduled_arrival IS NOT NULL;

    RETURN avg_result;
END;
$$;

SELECT average_delay(1);


--5
CREATE OR REPLACE PROCEDURE get_flight_passengers(
    p_flight_no VARCHAR,
    INOUT p_cursor REFCURSOR
)
LANGUAGE plpgsql
AS $$
BEGIN
    OPEN p_cursor FOR
    SELECT DISTINCT
        p.passenger_id,
        p.first_name,
        p.last_name
    FROM passengers p
    JOIN booking b
        ON p.passenger_id = b.passenger_id
    JOIN booking_flight bf
        ON b.booking_id = bf.booking_id
    JOIN flights f
        ON bf.flight_id = f.flight_id
    WHERE f.flight_no = p_flight_no;
END;
$$;

BEGIN;
CALL get_flight_passengers('KC101', 'passenger_cursor');
FETCH ALL FROM passenger_cursor;
COMMIT;

--6
CREATE OR REPLACE PROCEDURE most_active_passenger(
    INOUT p_cursor REFCURSOR
)
LANGUAGE plpgsql
AS $$
BEGIN
    OPEN p_cursor FOR
    SELECT
        p.passenger_id,
        p.first_name,
        p.last_name,
        COUNT(DISTINCT bf.flight_id) AS total_flights
    FROM passengers p
    JOIN booking b
        ON p.passenger_id = b.passenger_id
    JOIN booking_flight bf
        ON b.booking_id = bf.booking_id
    GROUP BY p.passenger_id, p.first_name, p.last_name
    ORDER BY total_flights DESC, p.passenger_id
    LIMIT 1;
END;
$$;

BEGIN;
CALL most_active_passenger('active_cursor');
FETCH ALL FROM active_cursor;
COMMIT;

--7
CREATE OR REPLACE PROCEDURE delayed_flights_24h(
    INOUT p_cursor REFCURSOR
)
LANGUAGE plpgsql
AS $$
BEGIN
    OPEN p_cursor FOR
    SELECT
        flight_id,
        flight_no,
        scheduled_departure,
        actual_departure,
        actual_departure - scheduled_departure AS delay
    FROM flights
    WHERE actual_departure - scheduled_departure
          > INTERVAL '24 hours';
END;
$$;

BEGIN;
CALL delayed_flights_24h('delayed_cursor');
FETCH ALL FROM delayed_cursor;
COMMIT;


--8
CREATE OR REPLACE FUNCTION count_flights_per_airline()
RETURNS TABLE(
    result_airline_id INT,
    result_airline_name TEXT,
    flight_count BIGINT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        a.airline_id,
        a.airline_name::TEXT,
        COUNT(f.flight_id)
    FROM airline a
    LEFT JOIN flights f
        ON a.airline_id = f.airline_id
    GROUP BY a.airline_id, a.airline_name;
END;
$$;

SELECT * FROM count_flights_per_airline();

--9
CREATE OR REPLACE PROCEDURE average_ticket_price(
    IN p_flight_id INT,
    INOUT p_average NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT AVG(b.price)
    INTO p_average
    FROM booking b
    JOIN booking_flight bf
        ON b.booking_id = bf.booking_id
    WHERE bf.flight_id = p_flight_id;
END;
$$;

CALL average_ticket_price(5, NULL);


--10
CREATE OR REPLACE PROCEDURE most_expensive_flight(
    INOUT p_cursor REFCURSOR
)
LANGUAGE plpgsql
AS $$
BEGIN
    OPEN p_cursor FOR
    SELECT
        f.flight_no,
        dep.airport_name AS departure_airport,
        arr.airport_name AS arrival_airport,
        b.price
    FROM booking b
    JOIN booking_flight bf
        ON b.booking_id = bf.booking_id
    JOIN flights f
        ON bf.flight_id = f.flight_id
    JOIN airport dep
        ON f.departure_airport_id = dep.airport_id
    JOIN airport arr
        ON f.arrival_airport_id = arr.airport_id
    ORDER BY b.price DESC, f.flight_id
    LIMIT 1;
END;
$$;

BEGIN;
CALL most_expensive_flight('expensive_cursor');
FETCH ALL FROM expensive_cursor;
COMMIT;


--11
CREATE OR REPLACE PROCEDURE insert_passenger(
    p_passenger_id INT,
    p_first_name TEXT,
    p_last_name TEXT,
    p_date_of_birth DATE,
    p_gender TEXT,
    p_citizenship TEXT,
    p_residence TEXT,
    p_passport TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO passengers(
        passenger_id,
        first_name,
        last_name,
        date_of_birth,
        gender,
        country_of_citizenship,
        country_of_residence,
        passport_number
    )
    VALUES (
        p_passenger_id,
        p_first_name,
        p_last_name,
        p_date_of_birth,
        p_gender,
        p_citizenship,
        p_residence,
        p_passport
    );
END;
$$;

CALL insert_passenger(
    9999,
    'Ali',
    'Nur',
    '2002-05-15',
    'Male',
    'Kazakhstan',
    'Kazakhstan',
    'AB987654'
);

--12
CREATE OR REPLACE PROCEDURE update_passenger_residence(
    p_passenger_id INT,
    p_country TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE passengers
    SET country_of_residence = p_country
    WHERE passenger_id = p_passenger_id;
END;
$$;

CALL update_passenger_residence(5, 'Kazakhstan');


--13
CREATE OR REPLACE PROCEDURE delete_booking_safely(
    p_booking_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM booking_flight
        WHERE booking_id = p_booking_id
    )
    OR EXISTS (
        SELECT 1 FROM baggage
        WHERE booking_id = p_booking_id
    )
    OR EXISTS (
        SELECT 1
        FROM baggage_check bc
        JOIN baggage bg
            ON bc.baggage_id = bg.baggage_id
        WHERE bg.booking_id = p_booking_id
    )
    OR EXISTS (
        SELECT 1 FROM boarding_pass
        WHERE booking_id = p_booking_id
    )
    THEN
        RAISE NOTICE 'Cannot delete: related records exist';
        RETURN;
    END IF;

    DELETE FROM booking
    WHERE booking_id = p_booking_id;

    RAISE NOTICE 'Delete operation completed';
END;
$$;

--14
CREATE OR REPLACE FUNCTION count_passengers_by_country(
    p_country TEXT
)
RETURNS BIGINT
LANGUAGE plpgsql
AS $$
DECLARE
    total_passengers BIGINT;
BEGIN
    SELECT COUNT(*)
    INTO total_passengers
    FROM passengers
    WHERE country_of_citizenship = p_country;

    RETURN total_passengers;
END;
$$;

SELECT count_passengers_by_country('Kazakhstan');


--15
CREATE OR REPLACE FUNCTION airline_revenue(
    p_airline_id INT
)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    total_revenue NUMERIC;
BEGIN
    SELECT COALESCE(SUM(b.price), 0)
    INTO total_revenue
    FROM booking b
    JOIN booking_flight bf
        ON b.booking_id = bf.booking_id
    JOIN flights f
        ON bf.flight_id = f.flight_id
    WHERE f.airline_id = p_airline_id;

    RETURN total_revenue;
END;
$$;

SELECT airline_revenue(1);


--16
CREATE OR REPLACE PROCEDURE get_passenger_bookings(
    p_passenger_id INT,
    INOUT p_cursor REFCURSOR
)
LANGUAGE plpgsql
AS $$
BEGIN
    OPEN p_cursor FOR
    SELECT
        booking_id,
        booking_date,
        booking_status,
        booking_platform,
        price
    FROM booking
    WHERE passenger_id = p_passenger_id;
END;
$$;

BEGIN;
CALL get_passenger_bookings(5, 'bookings_cursor');
FETCH ALL FROM bookings_cursor;
COMMIT;

--17
CREATE OR REPLACE PROCEDURE frequent_flyers(
    p_min_flights INT,
    INOUT p_cursor REFCURSOR
)
LANGUAGE plpgsql
AS $$
BEGIN
    OPEN p_cursor FOR
    SELECT
        p.passenger_id,
        p.first_name,
        p.last_name,
        COUNT(DISTINCT bf.flight_id) AS total_flights
    FROM passengers p
    JOIN booking b
        ON p.passenger_id = b.passenger_id
    JOIN booking_flight bf
        ON b.booking_id = bf.booking_id
    GROUP BY p.passenger_id, p.first_name, p.last_name
    HAVING COUNT(DISTINCT bf.flight_id) > p_min_flights
    ORDER BY total_flights DESC;
END;
$$;

BEGIN;
CALL frequent_flyers(3, 'frequent_cursor');
FETCH ALL FROM frequent_cursor;
COMMIT;


--18
CREATE OR REPLACE FUNCTION count_arriving_flights(
    p_airport_id INT,
    p_start_date DATE,
    p_end_date DATE
)
RETURNS BIGINT
LANGUAGE plpgsql
AS $$
DECLARE
    total_flights BIGINT;
BEGIN
    SELECT COUNT(*)
    INTO total_flights
    FROM flights
    WHERE arrival_airport_id = p_airport_id
      AND scheduled_arrival >= p_start_date
      AND scheduled_arrival < p_end_date + 1;

    RETURN total_flights;
END;
$$;

SELECT count_arriving_flights(
    1, '2026-11-01', '2026-11-30'
);


--19
CREATE OR REPLACE PROCEDURE update_old_bookings(
    p_date DATE,
    p_new_status TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE booking
    SET booking_status = p_new_status
    WHERE booking_date < p_date;
END;
$$;


--20
CREATE OR REPLACE FUNCTION passenger_booking_info(
    p_passenger_id INT
)
RETURNS TABLE(
    full_name TEXT,
    total_bookings BIGINT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM passengers p
        WHERE p.passenger_id = p_passenger_id
    ) THEN
        RAISE EXCEPTION 'Passenger not found';
    END IF;

    RETURN QUERY
    SELECT
        CONCAT_WS(' ', p.first_name, p.last_name),
        COUNT(b.booking_id)
    FROM passengers p
    LEFT JOIN booking b
        ON p.passenger_id = b.passenger_id
    WHERE p.passenger_id = p_passenger_id
    GROUP BY p.passenger_id, p.first_name, p.last_name;
END;
$$;

SELECT * FROM passenger_booking_info(5);

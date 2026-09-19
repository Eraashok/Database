CREATE table Airline_info (
    airline_id INT not null Primary Key,
    Airline_code varchar(30) NOT NULL,
    airline_name VARCHAR(50) not null,
    Airline_country varchar(50) NOT NULL,
    created_at TIMESTAMP not null,
    Updated_at timestamp NOT NULL,
    info VARCHAR(50) not null
);

create TABLE Airport (
    Airport_id int NOT NULL primary key,
    airport_name VARCHAR(50) not null,
    Country varchar(50) NOT NULL,
    state VARCHAR(50) not null,
    City varchar(50) NOT NULL,
    created_at TIMESTAMP not null,
    Updated_at timestamp NOT NULL
);
CREATE TABLE Baggage_check (
    baggage_check_id INT not null PRIMARY KEY,
    Check_result varchar(50) NOT NULL,
    created_at TIMESTAMP not null,
    Updated_at timestamp NOT NULL,
    booking_id int NOT NULL,
    Passenger_id INT not null
);
create table Baggage (
    Baggage_id INT NOT NULL primary key,
    weight_in_kg decimal(4,2) not null,
    Created_at TIMESTAMP NOT NULL,
    updated_at timestamp not null,
    Booking_id int NOT NULL
);
CREATE Table Boarding_pass (
    Boarding_pass_id int NOT NULL PRIMARY KEY,
    booking_id INT not null,
    Seat varchar(50) NOT NULL,
    boarding_time TIMESTAMP not null,
    Created_at timestamp NOT NULL,
    updated_at TIMESTAMP not null
);
create TABLE Booking_flight (
    booking_flight_id INT NOT NULL primary key,
    Booking_id int not null,
    flight_id INT NOT NULL,
    Created_at timestamp not null,
    updated_at TIMESTAMP NOT NULL
);
CREATE TABLE Booking (
    Booking_id int not null Primary Key,
    flight_id INT NOT NULL,
    Passenger_id int not null,
    booking_platform VARCHAR(50) NOT NULL,
    Created_at timestamp not null,
    updated_at TIMESTAMP NOT NULL,
    Status varchar(50) not null,
    price DECIMAL(7,2) NOT NULL
);
create table Flights (
    flight_id INT not null Primary Key,
    Sch_departure_time timestamp NOT NULL,
    sch_arrival_time TIMESTAMP not null,
    Departing_airport_id int NOT NULL,
    arriving_airport_id INT not null,
    Departing_gate varchar(50) NOT NULL,
    arriving_gate VARCHAR(50) not null,
    Airline_id int NOT NULL,
    act_departure_time TIMESTAMP not null,
    Act_arrival_time timestamp NOT NULL,
    created_at TIMESTAMP not null,
    Updated_at timestamp NOT NULL
);
CREATE TABLE Passengers (
    passenger_id INT NOT NULL Primary key,
    First_name varchar(50) not null,
    last_name VARCHAR(50) NOT NULL,
    Date_of_birth date not null,
    gender VARCHAR(50) NOT NULL,
    Country_of_citizenship varchar(50) not null,
    country_of_residence VARCHAR(50) NOT NULL,
    Passport_number varchar(20) not null,
    created_at TIMESTAMP NOT NULL,
    Updated_at timestamp not null
);
create TABLE Security_check (
    Security_check_id int NOT NULL primary key,
    check_result VARCHAR(20) not null,
    Created_at timestamp NOT NULL,
    updated_at TIMESTAMP not null,
    Passenger_id INT NOT NULL
);
--5
ALTER TABLE Airline_info RENAME TO airline;
--6
alter TABLE Booking rename Column price TO ticket_price;
--7
ALTER table Flights alter COLUMN departing_gate Type text;
--8
Alter table airline DROP column info;
--9
alter TABLE Security_check
    ADD constraint fk_security_passenger
    FOREIGN KEY (passenger_id) references Passengers(passenger_id);

ALTER table Booking
    add CONSTRAINT fk_booking_passenger
    foreign key (passenger_id) REFERENCES Passengers(passenger_id);

Alter TABLE Baggage_check
    ADD CONSTRAINT fk_baggagecheck_passenger
    FOREIGN KEY (passenger_id) References Passengers(passenger_id);

alter table Baggage_check
    Add constraint fk_baggagecheck_booking
    FOREIGN key (booking_id) references Booking(booking_id);

ALTER TABLE Baggage
    add CONSTRAINT fk_baggage_booking
    foreign KEY (booking_id) REFERENCES Booking(booking_id);

Alter table Boarding_pass
    ADD Constraint fk_boardingpass_booking
    FOREIGN KEY (booking_id) references Booking(booking_id);

alter TABLE Booking_flight
    ADD constraint fk_bookingflight_booking
    Foreign Key (booking_id) REFERENCES Booking(booking_id);

ALTER table Booking_flight
    add CONSTRAINT fk_bookingflight_flight
    foreign key (flight_id) References Flights(flight_id);

Alter TABLE Flights
    ADD CONSTRAINT fk_flights_departing_airport
    FOREIGN key (departing_airport_id) references Airport(airport_id);

alter table Flights
    Add constraint fk_flights_arriving_airport
    FOREIGN KEY (arriving_airport_id) REFERENCES Airport(airport_id);

ALTER TABLE Flights
    add CONSTRAINT fk_flights_airline
    foreign KEY (airline_id) references airline(airline_id);
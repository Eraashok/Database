--1
 select upper(airline_name)
 from airline;
--2
Select REPLACE(airline_name,'Air','Aero')
from airline;
--3
select flight_id
from flights
where airline_id in (1,2);
--4
select *
from airport
where airport_name like '%Reginal%'
  and airport_name like '%Air%';
--5
select first_name,
       last_name,
       TO_CHAR(date_of_birth, 'Month DD, YYYY')
from passengers;
--6
select * from flights
where act_arrival_time > sch_arrival_time;
--8
select * from airline
where airline_country in ('France','Portugal', 'Poland')
and created_at between '2023-11-01' and '2024-03-31';
--9
select * from baggage where weight_in_kg >25
order by weight_in_kg desc limit 3
--10
select first_name,last_name,date_of_birth from passengers
order by date_of_birth desc limit 1;
--11
select booking_platform, MIN(ticket_price)
from booking
group by booking_platform;
--12
select *
from airline where airline_code ~'[0-9]';
--13
select *
from airline
order by created_at desc limit 5;
--14
select * from baggage_check
where booking_id between 200 and 300 and check_result <>'Checked'
--15
select *
from baggage_check
where DATE_TRUNC('month', updated_at) = DATE_TRUNC('month', created_at)
  and updated_at < created_at;

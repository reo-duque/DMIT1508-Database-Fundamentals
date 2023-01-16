/*
  STUDENT_NAME: Reonel Duque
  CourseName & SectionNumber: DMIT 1508 Section A02
  Instructor Name: Shane Bell
  Deficiencies: N/A
 */

-- Place your solution to the lab in this file.

-- ### Part 1 - Queries (**26 marks**)

-- 1. (1 mark) Select the airport name, city, country, and timezone of the airport with the code 1028. Show the city and country as one column titled "Serving City" with a comma between the city and the country.
Select Name, City + ',' + Country 'Serving City', TimeZone 
from Airports 
where AirportCode = '1028'

-- 2. (3 marks) For all bookings, select the flight code, confirmation number and the number of passengers on the booking
Select FlightCode, Bookings.ConfirmationNumber, Count(Passengers.CustomerID) 'NumberofPassengers' 
From Bookings 
Inner Join Passengers on Bookings.ConfirmationNumber = Passengers.ConfirmationNumber 
Group By FlightCode, Bookings.ConfirmationNumber

-- 3. (1 mark) Select the average payment amount.
Select Avg(Amount) 'AveragePaymentAmount' From Payments


-- 4. (3 marks) Select the flight codes for all bookings whose total payment amounts are less than $ 10,000.
Select FlightCode 
from Bookings 
Inner Join Payments on Bookings.PaymentConfirmationNumber = Payments.ConfirmationNumber 
group by FlightCode
having (Sum(Amount) < 10000.000)

-- 5. (4 marks) Select the flight number, departure date, and the full names of all passengers on all of the scheduled flights for December 15 that are leaving from Edmonton. Include those flights that do not have any passengers.
Select FlightNumber, Date, Passengers.FirstName + ' ' + Passengers.MiddleName + ' ' + Passengers.LastName 'PassengerFullName' From Flights
Left Outer Join Bookings on Flights.FlightCode = Bookings.FlightCode
Left Outer Join Passengers on Bookings.ConfirmationNumber = Passengers.ConfirmationNumber
Left Outer Join Airports on Flights.DepartureAirport = Airports.AirportCode
where (Airports.City = 'Edmonton') and
(Date = 'December 15, 2022')


-- 6. (1 mark) Select all airports that do not have the word "International" in their name.
Select Name From Airports where Name not like '%International%'

-- 7. (3 marks) Select the amount of money that was made each day in the month of August (based on the timestamp in the Payments table). Show the day's number and weekday name along with the total paments on that day. List the days in chronological order.
Select Sum(Amount) 'MoneyMade', Day(TimeStamp) 'Day', DateName(dw,TimeStamp) 'WeekDay'
From Payments
Group By Amount, TimeStamp
Having DateName(mm, TimeStamp) = 'August'
Order By TimeStamp


-- 8. (2 marks) Select the names of the airlines without any scheduled flights. (Use a subquery for your answer.)
Select Name From Airlines where AirlineCode not in (Select AirlineCode from Flights)

-- 9. (5 marks) Select the name(s) of airline(s) with the most number of scheduled flights in December. (*Hint: A subquery is required for this problem.*) Prove your solution by creating another seperate query the shows all airline names and the number of scheduled flights in December sorted from highest to lowest number of flights.
Select Name From Airlines where AirlineCode in (Select AirlineCode From Flights  Group By AirlineCode Having Count(FlightCode) = (Select Max(MyCount) From (Select Count(FlightCode) MyCount From Flights where DateName(mm, Date) = 'December' Group By AirlineCode) x))
 
--  PROOF
Select Name, Count(FlightCode) 'DecemberFlightCount' From Airlines Inner Join Flights on Airlines.AirlineCode = Flights.AirlineCode where DateName(mm, Date) = 'December' Group By Name


-- 10. (3 marks) Select the time and flight number for all flights going into and out of the 'Lester B. Pearson International Airport' on December 22. Ensure the time displayed is appropriate (the arrival time for flights entering Lester B. Pearson and departure time for flights leaving Lester B. HINT: Cast(Arrival as time) Pearson). Include a column stating "Arriving" if it's an arrival or "Departing" if it's a departure. Sort the results by time in ascending order. (*Hint: A union operation works best.*) 
Select 'Departing: ' + Cast(Departure As varchar(8)) 'Time', FlightNumber From Flights where (Day(Date) = '22') and (DateName(mm, Date) = 'December' and DepartureAirport in (Select AirportCode From Airports where Name = 'Lester B. Pearson International Airport'))
UNION ALL
Select 'Arriving: ' +  Convert(Varchar(8), Arrival, 108), FlightNumber From Flights where (Day(Arrival) = '22') and (DateName(mm, Arrival) = 'December' and ArrivalAirport in (Select AirportCode From Airports where Name = 'Lester B. Pearson International Airport'))
Order by Time asc

-- ========================================================

-- ### Part 2 - Views (**4 marks**)

-- 1. (2 marks) Create a view called AirlineSchedule that returns the airline name, flight number, departure date (without the time), departure time (in 24-hour format), name of the departure city, name of the arrival city, and arrival time (in 24-hour format).
-- (Hint: To convert a DateTime to 24-hour format, use CONVERT(VARCHAR(8), F.Arrival, 108))
Go
Create view AirlineSchedule as Select Airlines.Name, FlightNumber, Date, Convert(varchar(8), Departure, 108) 'DepartureTime', DepartureAirport, ArrivalAirport, Convert(varchar(8), Arrival, 108) 'ArrivalTime'
From Airlines Inner Join Flights on Flights.AirlineCode = Airlines.AirlineCode
Go

-- 2. (2 marks) Using the AirlineSchedule view as your query source, select all flights arriving at Toronto on Dec 25.
Select FlightNumber From Flights where ArrivalAirport in (Select AirportCode From Airports where City = 'Toronto') and Day(Arrival) = '25' and DateName(mm, Arrival) = 'December'
-- ----

-- ### Part 3 - DML (**10 marks**)

-- Write DML statements to accomplish the following:

-- 1. (1 mark) Insert the following records into the Airports table:
--     | Name                          | City    | Country | IATA | ICAO | Latitude      | Longitude      | Altitude | TimeZone | TzDatabaseTimeZone |
--     |-------------------------------|---------|---------|------|------|---------------|----------------|----------|----------|--------------------|
--     | Kelowna International Airport | Kelowna | Canada  | YLW  | CYLW | 49.9561004639 | -119.377998352 | 1421     | -8       | America/Vancouver  |
Insert into Airports(Name, City, Country, IATA, ICAO, Latitude, Longitude, Altitude, TimeZone, TzDatabaseTimeZone)
values
('Kelowna International Airport', 'Kelowna', 'Canada', 'YLW', 'CYLW', 49.9561004639, -119.377998352, 1421, -8, 'America/Vancouver')

-- 2. (2 marks) Insert the following records into the Airports table, using subqueries where appropriate:
--     | Name                  | City          | Country | IATA | ICAO | Latitude     | Longitude      | Altitude | TimeZone & TzDatabaseTimeZone                                       |
--     |-----------------------|---------------|---------|------|------|--------------|----------------|----------|---------------------------------------------------------------------|
--     | Fort McMurray Airport | Fort Mcmurray | Canada  | YMM  | CYMM | 56.653301239 | -111.222000122 | 1211     | The same time zone as used for the `Edmonton International Airport` |
Insert into Airports(Name, City, Country, IATA, ICAO, Latitude, Longitude, Altitude, TimeZone, TzDatabaseTimeZone)
values
('Fort McMurray Airport', 'Fort McMurray', 'Canada', 'YMM', 'CYMM', 56.653301239, -111.222000122, 1211, (Select TimeZone from Airports where Name = 'Edmonton International Airport'), (Select TzDatabaseTimeZone From Airports where Name = 'Edmonton International Airport'))

-- 3. (2 marks) Change all the flights on December 24 for airline code 'ACA' to indicate that they are now full.
Update Flights
Set
IsFull = 1
where Day(Arrival) = '24' and DateName(mm, Arrival) = 'December' and AirlineCode = 'ACA'

-- 4. (3 marks) The runways in Abbotsford's airport are getting repaved. Cancel all scheduled flights arriving at or departing from that airport between Christmas and New Years Eve.
Update Flights
Set
Cancelled = 1
where Datepart(dy, DATE) in (359, 365) and Datepart(dy, Arrival) in (359, 365)

-- 5. (2 marks) Remove all the airlines that do not have scheduled flights.
Delete Airlines
where AirlineCode not in (Select AirlineCode From Flights)
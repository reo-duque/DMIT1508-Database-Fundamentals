--1.	Write the code to drop the tables in the database, ensuring that you drop the tables in the correct order. 
drop table Passengers
drop table Bookings
drop table Flights
drop table Payments
drop table Airports
drop table Airlines
Go

--2.	Create the required tables for Flights of Fancy incorporating the constraints (Primary Key, Foreign Key, Check and Default) and Identity properties as described below. Create each table using a single Create Table statement. Do NOT use the Alter Table statement in this question. The symbol (O) indicates a nullable attribute. Ensure the table names and column names are identical to what is specified in the ERD on next page. 
create table Airlines
(
	AirlineCode char(3) not null constraint PK_Airlines primary key clustered,
	Name varchar(85) not null
)


create table Airports
(
	AirportCode int not null identity(1000,1) constraint PK_Airports primary key clustered ,
	Name varchar(85) not null,
	City varchar(35) not null,
	Country varchar(35) not null,
	IATA char(4) null,
	ICAO char(4) null,
	Latitude decimal not null,
	Longitude decimal not null,
	Altitude int not null,
	Timezone int not null,
	TzDatabaseTimeZone varchar(50) not null,
)


create table Payments
(
	PaymentConfirmationNumber varchar(40) not null constraint PK_Payments primary key,
	Timestamp datetime not null constraint df_Timestamp default getdate(),
	Amount money not null constraint ck_ProperAmount Check (Amount > 0),
	PaymentType varchar(10) not null,
)


create table Flights
(
	FlightCode varchar(18) not null constraint PK_Flights primary key clustered,
	FlightNumber varchar(8) not null,
	Date date not null,
	DepartureAirport int not null constraint FK_DepartureFlightstoAirports references Airports(AirportCode),
	Departure time not null,
	ArrivalAirport int not null constraint FK_ArrivalFlightstoAirports references Airports(AirportCode),
	Arrival time not null,
	constraint ck_DepartureAirportNotArrivalAirport Check (DepartureAirport != ArrivalAirport),
	FlightDuration time not null,
	Cancelled char(1) null,
	IsFull char(1) not null constraint df_IsFull default 'N',
	AirlineCode char(3) not null constraint FK_FlightstoAirlines references Airlines(AirlineCode),
)


create table Bookings
(
	ConfirmationNumber char(11) not null constraint PK_Bookings primary key,
	Flightcode varchar(18) not null constraint FK_BookingstoFlights references Flights(FlightCode),
	PaymentConfirmationNumber varchar(40) null constraint FK_BookingstoPayments references Payments(PaymentConfirmationNumber),
	FirstName varchar(40) not null,
	MiddleName varchar(40) null,
	LastName varchar(40) not null,
	PhoneNumber char(14) not null constraint ck_PhoneNumber Check(PhoneNumber like '[0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
	AlternatePhoneNumber char(14) null constraint ck_AlternatePhoneNumber Check(AlternatePhoneNumber like '[0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
	EmailAddress varchar(50) not null,
	StreetAddress varchar(50) not null,
	City varchar(40) not null,
	Region varchar(25) null,
	Country varchar(35) not null,
)

create table Passengers
(
	ConfirmationNumber char(11) not null constraint FK_PassengerstoBookings references Bookings(ConfirmationNumber),
	CustomerID int not null,
	constraint PK_Passengers primary key clustered (ConfirmationNumber, CustomerID),
	FirstName varchar(40) not null,
	MiddleName varchar(40) null,
	LastName varchar(40) not null,
	PhoneNumber char(14) null constraint ck_PassengerPhoneNumber Check(PhoneNumber like '[0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
)
Go

--2a.	Passengers Table: add an 8-character variable length mandatory column called AgeGroup. AgeGroup will only allow ‘Child’, ‘Adult’, or ‘Senior’; and will default to ‘Adult’’
Alter Table Passengers
	Add AgeGroup varchar(8) not null constraint ck_AgeGroup Check (AgeGroup = 'Child' or AgeGroup = 'Adult' or AgeGroup = 'Senior')

Alter Table Passengers
	Add constraint df_AgeGroup default 'Adult' for AgeGroup

--2b.	Flights Table: add a default of ‘N’ to the Cancelled column
Alter Table Flights
	Add constraint df_Cancelled default 'N' for Cancelled
Go


--3.	Create non-clustered indexes on all foreign keys 
Create nonclustered index ix_DepartureAirport on Flights(DepartureAirport)
Create nonclustered index ix_ArrivalAirport on Flights(ArrivalAirport)
Create nonclustered index ix_AirlineCode on Flights(AirlineCode)
Create nonclustered index ix_FlightCode on Bookings(FlightCode)
Create nonclustered index ix_PaymentConfirmationNumber on Bookings(PaymentConfirmationNumber)
Create nonclustered index ix_ConfirmationNumber on Passengers(ConfirmationNumber)
Go

--I liked that this lab was a continuation of the previous lab so we understand how we formed the table from the previous normalization process we did
--This lab took me longer than expected due to the multiple updates, but overall, it took me about 3 hours.
--I felt pretty prepared for the lab since we covered all the topics necessary to complete it
--For future labs, I recommend double checking that the test labs work so that there'll be no frustrations for future students
--No known errors.

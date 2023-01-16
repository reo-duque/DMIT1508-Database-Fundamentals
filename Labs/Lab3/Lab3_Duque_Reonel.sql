--1.	Write a stored procedure called LookUpPassengers that will be passed a ConfirmationNumber. Return the FirstName and LastName (as one column), DateOfBirth ordered by CustomerID. If the ConfirmationNumber does not exist, raise an error. (3 marks)
Create Procedure LookUpPassengers (@confirmNum char(11) = null)
as
if (@confirmNum is null)
	Begin
	RaisError('You must input a proper value', 16, 1)
	End
else
	Begin
	if not exists (Select * from Bookings where ConfirmationNumber = @confirmNum)
		Begin
		RaisError('ConfimationNumber does not exist', 16, 1)
		End
	else
		Begin
		Select FirstName + ' ' + LastName 'PassengerName', DateOfBirth from Passengers where ConfirmationNumber = @confirmNum
		End
	End
return
go

--2.	Write a stored procedure called AddAirport that accepts a Name, City, Country, IATA, ICAO, Latitude, Longitude, Altitude, Timezone, and TzDatabaseTimeZone. If the airport name already exists in the table, raise an appropriate error message, and do not add it. Otherwise add the new airport to the Airports table and select the new AirportCode. (4 marks)
Create Procedure AddAirport (@name varchar(90) = null, @city varchar(35) = null, @country varchar(35) = null, @Iata char(3) = null, @Icao varchar(4) = null, @latitude decimal(12,9) = null, @longitude decimal(12,9) = null, @altitude int = null, @timezn decimal(2,0) = null, @tzdtz varchar(50) = null)
as
if @name is null or @city is null or @country is null or @latitude is null or @longitude is null or @altitude is null or @timezn is null or @tzdtz is null
	Begin
	RaisError('You must input the proper values', 16, 1)
	End
else
	Begin
	if exists (Select Name from Airports where Name = @name)
		Begin
		RaisError('Airport name already exists in the table', 16, 1)
		End
	else
		Begin
		Insert into Airports (Name, City, Country, IATA, ICAO, Latitude, Longitude, Altitude, Timezone, TzDatabaseTimeZone)
		values (@name, @city, @country, @iata, @icao, @latitude, @longitude, @altitude, @timezn, @tzdtz)
		if @@Error <> 0
			Begin
			RaisError('Insert failed', 16, 1)
			End
		else
			Begin
			Select * from Airports where Name = @name
			End
		End
	End
return
go


--3.	Write a stored procedure called LookUpFlights that accepts a part of a FlightCode as a parameter. Return the FlightCode, FlightNumber, Date, Departure Airport Name, and the Arrival Airport Name for any flights that have that input parameter somewhere in the FlightCode. If no flights exist with that FlightCode part, raise an error. (4 marks)
Create Procedure LookUpFlights (@flightcode varchar(18) = null)
as
if @flightcode is null
	Begin
	RaisError('You must input a proper value', 16, 1)
	End
else
	Begin
	if exists(Select FlightCode from Flights where FlightCode like ('%'+@flightcode+'%'))
		Begin
		Select FlightCode, FlightNumber, Date, DepartureAirport, ArrivalAirport From Flights where FlightCode like ('%'+@flightcode+'%')
		End
	else
		Begin
		RaisError('No flights exist with that part of a flight code', 16, 1)
		End
	End
return

Select Name From Airports where AirportCode in (Select DepartureAirport from Flights where FlightCode like ('%' + 'ACA' + '%'))
go

--4.	Write a stored procedure called ArchiveBookings that will move a Bookings record to the BookingsArchive table for storage. A booking can only be archived if it does not have any passengers. A ConfirmationNumber will be passed to this procedure as a parameter. Error messages are required if the ConfirmationNumber does not exist or if the booking cannot be archived because it has passengers. (6 marks)
Create Procedure ArchiveBookings (@confirmNum char(11) = null)
as
if @confirmNum is null
	Begin
	RaisError('You must input a proper value', 16, 1)
	End
else
	Begin
	if not exists(Select * from Bookings where ConfirmationNumber = @confirmNum)
		Begin
		RaisError('ConfirmationNumber does not exist', 16, 1)
		End
	else
		Begin
		if (Select PassengerCount from Bookings where ConfirmationNumber = @confirmNum) > 0
			Begin
			RaisError('Booking cannot be archived because it has passengers', 16, 1)
			End
		else
			Begin
			Begin Transaction
			insert into BookingsArchive Select * from Bookings Where ConfirmationNumber = @confirmNum
			if @@Error <> 0
				Begin
				RaisError('Archiving failed', 16, 1)
				Rollback Transaction
				End
			else
				Begin
				Delete Bookings where ConfirmationNumber = @confirmNum
				if @@ERROR <> 0
					Begin
					RaisError('Delete from bookings failed', 16, 1)
					Rollback Transaction
					End
				else
					Begin
					Commit Transaction
					End
				End
			End
		End
	End
return
go

--5.	Write a stored procedure called DeleteAirlines that accepts an AirlineCode as a parameter. If the record does not exist in the Airlines table, raise an appropriate message. If there are flights with that AirlineCode, raise an appropriate message. Otherwise, delete the record from the Airlines table. (5 marks)
Create Procedure DeleteAirlines (@airlineCode char(3) = null)
as
if @airlineCode is null
	Begin
	RaisError('You must input a proper value', 16, 1)
	End
else
	Begin
	if not exists (Select * from Airlines where AirlineCode = @airlineCode)
		Begin
		RaisError('Airline Code does not exist', 16, 1)
		End
	else
		Begin
		if not exists(Select * from Flights where AirlineCode = @airlineCode)
			Begin
			Delete Airlines where AirlineCode = @airlineCode
			if @@ERROR <> 0
				Begin
				RaisError('Deletion of Airlines failed', 16, 1)
				End
			End
		else
			Begin
			RaisError('AirlineCode has flights, cannot delete', 16, 1)
			End
		End
	End
Return
Go

--6.	Write a procedure AddPassenger that will add a record to the Passengers table and update the PassengerCount column in the Bookings table. Input parameters will be ConfirmationNumber, FirstName, LastName, and DateOfBirth. The CustomerID will start at 1 for the first passenger and increment by 1 for each additional passenger added on to that ConfirmationNumber. All input parameters will be valid. (6 marks)
Create Procedure AddPassenger (@confirmNum char(11) = null, @fName varchar(40) = null, @lName varchar(40) = null, @dob date = null)
as
Declare @customID int
Select @customID = (Select count(CustomerID) from Passengers where ConfirmationNumber = @confirmNum) + 1
if @confirmNum is null or @fName is null or @lName is null or @dob is null
	Begin
	RaisError('You must input the proper values', 16, 1)
	End
else
	Begin
	if not exists (Select * from Bookings where ConfirmationNumber = @confirmNum)
		Begin
		RaisError('Confirmation Number does not exist in that Booking', 16, 1)
		End
	else
		Begin
		Begin Transaction
		Update Bookings
		Set PassengerCount = @customID where ConfirmationNumber = @confirmNum
		if @@ERROR <> 0
			Begin
			RaisError('Update Bookings failed', 16, 1)
			Rollback Transaction
			End
		else
			Begin
			Insert into Passengers (ConfirmationNumber, CustomerID, FirstName, LastName, DateOfBirth)
			values (@confirmNum, @customID, @fName, @lName, @dob)
			if @@ERROR <> 0
				Begin
				RaisError('Inserting Passengers failed', 16, 1)
				Rollback Transaction
				End
			else
				Begin
				Commit Transaction
				End
			End
		End
	End
return
go

--Short discussion
--What I liked/disliked about the lab
--I liked that the lab was straightforward, except for number 3 where we had to learn stuff outside of class

--How long it took to complete the lab
--4 hours

--How prepared you felt you were for the lab
--Moderately prepared

--Known errors
--#3 does not return names for departure and arrival airport

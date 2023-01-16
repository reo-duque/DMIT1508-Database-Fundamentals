Drop Trigger TR_Lab4Q1
Drop Trigger TR_Lab4Q2
Drop Trigger TR_Lab4Q3
Drop Trigger TR_Lab4Q4
go
--1.	Create a trigger called Lab4Q1 to ensure that the payment amount will not increase by more than 18%. If this happens raise an error and do not allow the update. (3.5 Marks)
Create Trigger TR_Lab4Q1
on Payments
For Update
as
if @@RowCount > 0 and update(Amount)
	Begin
	if exists(Select * from inserted inner join deleted on inserted.PaymentConfirmationNumber = deleted.PaymentConfirmationNumber where inserted.Amount > (deleted.Amount * 1.18))
		Begin
		RaisError('Too much increase', 16, 1)
		Rollback Transaction
		End
	End
Return
Go

--2.	Create a trigger called Lab4Q2 to ensure that a departure airport code and arrival airport code cannot be the same on a new flight. If this happens, raise an error, and do not allow the insert. (3 Marks)
Create Trigger TR_Lab4Q2
on Flights
For Insert
as
if @@rowcount > 0
	Begin
	if exists (Select * from Flights Inner Join inserted on inserted.FlightCode = Flights.FlightCode where Flights.ArrivalAirport = Flights.DepartureAirport)
		Begin
		RaisError('Arrival Airport cannot be the same as Departure Airport', 16, 1)
		Rollback Transaction
		End
	End
return
go

--3.	Create a trigger called Lab4Q3 that will enforce a rule that, due to high processing fees, a new payment is not allowed to have an amount less than 100. If an attempt is made to insert a new payment with an amount less than 100, set it to 100. (3.5 marks)
Create Trigger TR_Lab4Q3
on Payments
For Insert
as
if @@rowcount > 0
	Begin
	if exists (Select * from Payments inner join inserted on Inserted.PaymentConfirmationNumber = Payments.PaymentConfirmationNumber where Inserted.Amount < 100)
		Begin
		RaisError('Not enough payment, will make it $100', 16, 1)
		Update Payments
		Set Amount = 100 from Payments Inner Join Inserted on Inserted.PaymentConfirmationNumber = Payments.PaymentConfirmationNumber where Inserted.Amount < 100
		if @@ERROR <> 0
			Begin
			RaisError('Update failed', 16, 1)
			Rollback Transaction
			End
		End
	End
go

--4.	Create a trigger called Lab4Q4 to log Bookings that have a high PassengerCount. When the PassengerCount of a booking is updated to over 5, add a record to the HighPassengerCount table. Do not add a record to the HighPassengerCount table if the PassengerCount was already over 5. (3 Marks)
Create Trigger TR_Lab4Q4
on Bookings
For Update
as
if @@rowcount > 0 and update(passengercount)
	Begin
	Insert into HighPassengerCount (logDate, ConfirmationNumber, NewPassengerCount, OldPassengerCount)
	Select getdate(), Inserted.ConfirmationNumber, Inserted.PassengerCount, Deleted.PassengerCount from Inserted Inner Join Deleted on Inserted.ConfirmationNumber = Deleted.ConfirmationNumber where Deleted.PassengerCount < 5 and Inserted.PassengerCount > 5
	if @@Error <> 0
		Begin
		RaisError('Update failed', 16, 1)
		Rollback Transaction
		End
	End
go

--Short Discussion
--What I liked/disliked about the lab
--I liked that the lab was straightforward and combines the lesson learned from Stored Procedure

--How long it took me to complete the lab
--The lab took me about 3 hours to complete

--How prepared you felt you were for the lab
--Pretty prepared

--No known errors
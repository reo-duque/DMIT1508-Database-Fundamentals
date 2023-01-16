--Stored Procedure Logic
--Declare a variable
--All variables (and parameters) must start with '@'
--Must be declared before using

Declare @firstName varchar(30)
go

Declare @firstName varchar(30)
--Place a value in a variable
--there are two ways

--1. Using SET
Set @firstName = 'Homer'
print @firstName --Print only prints out in SSMS. DO NOT use print for messages to the user
go

--2. Using Select
Declare @firstName varchar(30)
Select @firstName='Homer'
print @firstName
go

--Usually we are selecting data from the DB into variables
--From the DB
--SET(not recommended)
Declare @firstName varchar(30)
Set @firstName = (Select firstName from Staff where StaffID = 1)
print @firstName
go
--Select
Declare @firstName varchar(30)
Select @firstName = firstName from staff where StaffID = 1
print @firstName
go

--Select firstname, lastname, and positionid for staffid 1 into 3 variables. Use SET
Declare @firstName varchar(30), @lastName varchar(30), @positionID tinyint
Set @firstName = (Select firstName from Staff where StaffID = 1)
Set @lastName = (Select lastName from Staff where StaffID = 1)
Set @positionID = (Select positionID from Staff where StaffID = 1)
print @firstName 
print @lastName 
print @positionID
go

--Select firstname, lastname, and positionid for staffid 1 into 3 variables. Use Select
Declare @firstName varchar(30), @lastName varchar(30), @positionID tinyint
Select @firstName = firstName, @lastName = lastName, @positionID = positionID from Staff where StaffID = 1
print @firstName
print @lastName
print @positionID
go

--Decisions --if/else
Declare @firstName varchar(30)
Set @firstName = 'Joe'
if @firstName = 'Joe'
	print 'Hello Joe!'
else
	print 'Hello, whoever you are...'
go -- begin and end in the code block is not needed because it's only one statement

Declare @firstName varchar(30)
Set @firstName = 'Joe'
if @firstName = 'Joe'
	Begin
	print 'Hello Joe!'
	print 'Good to see ya Joe'
	End
else
	Begin
	print 'Hello, whoever you are...'
	print 'Have a groovy day'
	End
go

--Nested Decisions
Declare @city varchar(20), @studentID int
Set @studentid = 199899200
Select @city = city from student where studentID = @studentID
if @city = 'Edmonton'
	Begin
	print 'That is awesome'
	End
else
	Begin
	if @city = 'Red Deer'
		Begin
		print 'That is cool, too.'
		End
	Else
		Begin
		if @city = 'Calgary'
			Begin
			print 'Ew'
			End
		else
			Begin
			print 'Other places are groovy'
			End
		End
	End
go

Declare @city varchar(20), @studentID int
Set @studentid = 199899200
Select @city = city from student where studentID = @studentID
if @city = 'Edmonton'
	print 'That is awesome'
else
	if @city = 'Red Deer'
		print 'That is cool, too.'
	else
		if @city = 'Calgary'
			print 'Ew'
		else
			print 'Other places are groovy'
go --if/else is considered one statement??

Declare @city varchar(20), @studentID int
Set @studentid = 199899200
Select @city = city from student where studentID = @studentID
if @city = 'Edmonton'
	Begin
	print 'That is awesome'
	End
else if @city = 'Red Deer'
	Begin
	print 'That is cool, too.'
	End
else if @city = 'Calgary'
	Begin
	print 'Ew'
	End
else
	Begin
	print 'Other places are groovy'
	End
go

Declare @city varchar(20), @studentID int
Set @city = 'Calgary'
if @city = 'Edmonton'
	Begin
	print 'That is awesome'
	End
else if @city = 'Red Deer'
	Begin
	print 'That is cool, too.'
	End
else if @city = 'Calgary'
	Begin
	print 'Ew'
	End
else
	Begin
	print 'Other places are groovy'
	End
go

--1.	Create a stored procedure called StudentClubCount. It will accept a clubID as a parameter. If the count of students in that club is greater than 2 print ‘A successful club!’ . If the count is not greater than 2 print ‘Needs more members!’.
Create Procedure StudentClubCount (@clubID varchar(10) = null)
as
Declare @condition int
Select @condition = count(StudentID) from activity where ClubID = @clubID
if @clubID is null
	Begin
	RaisError('You must input a proper value', 16, 1)
	End
else
	Begin
	if @condition > 2 
		Begin
		print ('A successful club')
		End
	else
		Begin
		print ('Need more members!')
		End
	End
return
go

Drop Procedure StudentClubCount
Execute StudentClubCount 'CSS'
--2.	Create a stored procedure called BalanceOrNoBalance. It will accept a studentID as a parameter. Each course has a cost. If the total of the costs for the courses the student is registered in is more than the total of the payments that student has made then print ‘balance owing !’ otherwise print ‘Paid in full! Welcome to School 158!’
--Do Not use the BalanceOwing field in your solution. 
Drop Procedure BalanceOrNoBalance
Go
Create Procedure BalanceOrNoBalance (@studentID int = null)
as
Declare @amountowed int, @amountpaid int
Select @amountowed = Sum(CourseCost) from Course
	Inner Join Offering on Offering.CourseID = Course.CourseID
	Inner Join Registration on Registration.OfferingCode = Offering.OfferingCode
	Inner Join Student on Student.StudentID = Registration.StudentID where Student.StudentID = @studentID
Select @amountpaid = Sum(Amount) from Payment
	Inner Join Student on Student.StudentID = Payment.StudentID where Student.StudentID = @studentID
if @studentID is null
	Begin
	RaisError('You must input a proper value', 16, 1)
	End
else
	Begin
	if (@amountowed) > (@amountpaid)
		Begin
		print('Balance owing!')
		End
	else
		Begin
		print('Paid in full!')
		End
	End
return
Go
Execute BalanceOrNoBalance 199899200
Go
--3.	Create a stored procedure called ‘DoubleOrNothin’. It will accept a students first name and last name as parameters. If the student name already is in the table then print ‘We already have a student with the name firstname lastname!’ Other wise print ‘Welcome firstname lastname!’
Create Procedure DoubleOrNothin (@stdntfn varchar(25) = null, @stdntln varchar(35) = null)
as
if @stdntfn is null or @stdntln is null
	Begin
	RaisError('You need to input proper value', 16, 1)
	End
else
	Begin
	if exists(Select FirstName, Lastname From Student where FirstName = @stdntfn and LastName = @stdntln)
		Begin
		print('We already have a student with that name')
		End
	else
		Begin
		print('Welcome!')
		End
	End
return
go
Execute DoubleorNothin 'Ivy', 'Brent'
go
--4.	Create a procedure called ‘StaffRewards’. It will accept a staff ID as a parameter. If the number of classes the staff member has ever taught is between 0 and 10 print ‘Well done!’, if it is between 11 and 20 print ‘Exceptional effort!’, if the number is greater than 20 print ‘Totally Awesome Dude!’
Create Procedure StaffRewards (@staffID smallint = null)
as
Declare @condition int
Select @condition = count(*) From Offering
Inner Join Registration on Registration.OfferingCode = Offering.OfferingCode
Inner Join Student on Student.StudentID = Registration.StudentID
where StaffID = @staffID
if @staffID is null
	Begin
	RaisError('You need to input proper value', 16, 1)
	end
else
	Begin
	if @condition between 0 and 10
		Begin
		print('Well done!')
		End
	else if @condition between 11 and 20
		Begin
		print('Exceptional effort!')
		End
	else if @condition > 20
		Begin
		print('Totally Awesome Dude!')
		End
	End
return
go
execute StaffRewards 6
Drop Procedure StaffRewards
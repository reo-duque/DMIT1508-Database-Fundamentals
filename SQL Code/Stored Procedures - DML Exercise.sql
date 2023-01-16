--ALWAYS CHECK @@ERROR AFTER EVERY INSERT, UPDATE, OR DELETE
--1.	Create a stored procedure called ‘AddClub’ to add a new club record.
Create Procedure AddClub (@clubID varchar(10) = null, @clubName varchar(50) = null)
as
if @clubID is null or @clubName is null
	Begin
	RaisError('You need to input a proper value', 16, 1)
	End
Else
	Begin
	Insert into Club (ClubID, ClubName)
	values (@clubid, @clubName)
	if @@Error <> 0
		Begin
		RaisError('Insert failed', 16, 1)
		End
	Else
		Begin
		Select ClubID, ClubName From Club where ClubID = @clubid
		End
	End
Return
Go
Drop Procedure AddClub
Go
Execute AddClub 'Climbers', 'ClimbingClub'
Select * from Club
go
--2.	Create a stored procedure called ‘DeleteClub’ to delete a club record.
Create Procedure DeleteClub (@clubID varchar(10) = null)
as
if @clubID is null
	Begin
	RaisError('You must input a proper value', 16, 1)
	End
else
	Begin
	If not exists(Select * from club where ClubID = @clubID)
		Begin
		RaisError('ClubID does not exist', 16, 1)
		End
	Else
		Begin
		Delete Club where ClubID = @clubID
		End
	End
return
go
Execute DeleteClub Climb
Select * from Club
go
--3.	Create a stored procedure called ‘Updateclub’ to update a club record. Do not update the primary key!
Create Procedure UpdateClub (@clubID varchar(10) = null, @clubName varchar(50) = null)
as
if @clubID is null or @clubName is null
	Begin
	RaisError('You must input a proper value', 16, 1)
	End
else
	Begin
	if not exists(Select * from Club where ClubID = @clubID)
		Begin
		RaisError('ClubID does not exist', 16, 1)
		End
	Else
		Begin
		Update Club
		Set ClubName = @clubName where ClubID = @clubID
		if @@Error <> 0
			Begin
			RaisError('Update failed', 16, 1)
			End
		End
	End
return
go
execute UpdateClub 'Climbers', 'Climbing Club Community'
execute UpdateClub 'Climb', 'Climb'
Select * from Club
go
--4.	Create a stored procedure called ‘ClubMaintenance’. It will accept parameters for both ClubID and ClubName as well as a parameter to indicate if it is an insert, update or delete. This parameter will be ‘I’, ‘U’ or ‘D’.  insert, update, or delete a record accordingly. Focus on making your code as efficient and maintainable as possible.
Create Procedure ClubMaintenance (@clubID varchar(10) = null, @clubName varchar(50) = null, @option char(1) = null)
as
if @clubID is null or @clubName is null or @option is null or Upper(@option) not in ('I', 'U', 'D')
	Begin
	RaisError('You must input a proper value', 16, 1)
	End
else
	Begin
	if Upper(@option) = 'I' 
		Begin
		Insert into Club (ClubID, ClubName)
		values (@clubid, @clubName)
		if @@Error <> 0
			Begin
			RaisError('Insert failed', 16, 1)
			End
		Else
			Begin
			Select ClubID, ClubName From Club where ClubID = @clubid
			End
		End
	if Upper(@option) = 'U'
		Begin
		if not exists(Select * from Club where ClubID = @clubID)
			Begin
			RaisError('ClubID does not exist', 16, 1)
			End
		Else
			Begin
			Update Club
			Set ClubName = @clubName where ClubID = @clubID
			if @@Error <> 0
				Begin
				RaisError('Club update failed', 16, 1)
				End
			End
		End
	if Upper(@option) = 'D'
		Begin
		If not exists(Select * from club where ClubID = @clubID)
			Begin
			RaisError('ClubID does not exist', 16, 1)
			End
		Else
			Begin
			Delete Club where ClubID = @clubID
			if @@Error <> 0
				Begin
				RaisError('Club deletion failed', 16, 1)
				End
			End
		End
	End
Return
Go

Execute ClubMaintenance 'PowerLift', 'Power Lifting Community', 'i'
Execute ClubMaintenance 'PowerLift', 'Power Lifting Community', 'I'
Execute ClubMaintenance 'PowerLift', 'All Might', 'u'
Execute ClubMaintenance 'Power', 'All Might', 'u'
Execute ClubMaintenance 'PowerLift', 'Something', 'D'
Execute ClubMaintenance 'Power', 'Something', 'D'


Go
--5.	 Create a stored procedure called ‘RegisterStudent’ that accepts StudentID and OfferingCode as parameters. If the number of students in that Offering are not greater than the Max Students for that course, add a record to the Registration table and add the cost of the course to the students balance. If the registration would cause the Offering to have greater than the MaxStudents   raise an error. 
Create Procedure RegisterStudent (@studentID int = null, @offerCode int = null)
as
Declare @maxStudent int, @countStudent int
Select @maxStudent = count(*) from course inner join offering on course.courseid = offering.courseid where OfferingCode = @offerCode
Select @countStudent = count(*) from registration where offeringcode = @offerCode and WithdrawYN <> 'Y'
if @studentID is null or @offerCode is null
	Begin
	RaisError('You must input a proper value', 16, 1)
	End
Else
	Begin
	if @countStudent > @maxStudent
		Begin
		Insert into Registration (OfferingCode, StudentID)
		values (@offerCode, @studentID)
		if @@Error <> 0
			Begin
			RaisError('Insert failed', 16, 1)
			End
		Else
			Begin
			Declare @addcost money
			Select @addcost = CourseCost from Course where CourseID in (Select CourseID from Offering where OFferingCode = @offerCode)
			Update Student
			Set BalanceOwing = BalanceOwing + @addcost from Student where StudentID = @studentID
			if @@Error <> 0
				Begin
				RaisError('Updating of student failed', 16, 1)
				End
			Select OfferingCode, Student.StudentID, BalanceOwing From Registration Inner Join Student on Student.StudentID = Registration.StudentID where OfferingCode = @OfferCode
			End
		End
	Else
		Begin
		RaisError('Number of max student reached', 16, 1)
		End
	End
return
go
Drop Procedure RegisterStudent
execute RegisterStudent 199899200, 1009
Select * from Registration
go

--6.	Create a procedure called ‘StudentPayment’ that accepts PaymentID, Student ID, paymentamount, and paymentTypeID as parameters. Add the payment to the payment table and adjust the students balance owing to reflect the payment. 
Create Procedure StudentPayment (@paymentID int = null, @studentID int = null, @amount money = null, @paymenttypeid tinyint = null)
as
if @paymentID is null or @studentID is null or @amount is null or @paymenttypeid is null
	Begin
	RaisError('You must input a proper value', 16, 1)
	End
else
	Begin
	Insert into Payment (PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
	values (@paymentid, getdate(), @amount, @paymenttypeid, @studentID)
	if @@Error!=0
		Begin
		RaisError('Insert failed', 16, 1)
		End
	else
		Begin
		Update Student
		Set BalanceOwing = BalanceOwing - @amount From Student where StudentID = @studentID
		if @@ERROR <> 0
			Begin
			RaisError('Update failed', 16, 1)
			End
		End
	End
return
go
Drop Procedure StudentPayment
execute StudentPayment 38, 199899200, 100, 4
Select * from Student
go
--7.	Create a stored procedure caller ‘FireStaff’ that will accept a StaffID as a parameter. Fire the staff member by updating the record for that staff and entering todays date as the DateReleased. 
Create Procedure FireStaff (@staffID smallint = null)
as
if @staffID is null
	Begin
	RaisError('You need to input a proper value', 16, 1)
	End
else
	Begin
	if not exists(Select * from Staff where StaffID = @staffID)
		Begin
		RaisError('StaffID does not exist', 16, 1)
		End
	else
		Begin
		if (Select DateReleased from Staff where StaffID = @staffID) is not null
			Begin
			RaisError('StaffID was already released', 16, 1)
			End
		else
			Begin
			Update Staff
			Set DateReleased = getdate() from staff where StaffID = @staffid
			End
		End
	End
return
go
Drop Procedure FireStaff
execute FireStaff 3
execute FireStaff 1
Select StaffID, DateReleased from staff
go
--8.	Create a stored procedure called ‘WithdrawStudent’ that accepts a StudentID, and OfferingCode as parameters. Withdraw the student by updating their Withdrawn value to ‘Y’ and subtract ½ of the cost of the course from their balance. If the result would be a negative balance set it to 0.
Create Procedure WithdrawStudent (@studentID int = null, @offercode int = null)
as
if @studentID is null or @offercode is null
	Begin
	RaisError('You need to input a proper value', 16, 1)
	End
else
	Begin
	if not exists (Select StudentID from Student where StudentID = @studentID) or not exists(Select * from Offering where OfferingCode = @offercode)
		Begin
		RaisError('An input does not exist', 16, 1)
		End
	else
		Begin
		if (Select count(*) from Registration where StudentID = @studentID and OfferingCode = @offercode) = 0
			Begin
			RaisError('StudentID is not registered in the course', 16, 1)
			End
		Else
			Begin
			if (Select WithdrawYN from Registration where StudentID = @studentID and OfferingCode = @offercode) = 'Y'
				Begin
				RaisError('Student already withdrew from the course', 16, 1)
				End
			Else
				Begin
				Update Registration
				Set WithdrawYN = 'Y' from Registration where StudentID = @studentID and OfferingCode = @offercode
				Declare @courseCost decimal(6,2)
				Select @courseCost = CourseCost From Course where CourseID in (Select CourseID from Offering where OfferingCode = @offercode)
				if (@courseCost/2) > (Select BalanceOwing from Student where StudentID = @studentID)
					Begin
					Update Student
					Set BalanceOwing = 0 from Student where StudentID = @studentID
					if @@ERROR <> 0
						Begin
						RaisError('update failed', 16, 1)
						End
					End
				else
					Begin
					Update Student
					Set BalanceOwing = BalanceOwing - (@courseCost/2) from Student where StudentID = @studentID
					if @@ERROR <> 0
						Begin
						RaisError('update failed', 16, 1)
						End
					End
				End
			End
		End
	End
return
go

Drop Procedure WithdrawStudent
execute WithdrawStudent 199899200, 1004



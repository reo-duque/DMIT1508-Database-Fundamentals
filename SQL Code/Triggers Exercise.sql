--1.	In order to be fair to all students, a student can only belong to a maximum of 3 clubs. Create a trigger to enforce this rule.
Create Trigger TR_Activity_Insert_Update
On Activity
For Insert, Update
as
If @@RowCount > 0 and Update(StudentID)
	Begin
	if exists((Select * from Activity where StudentID in (Select StudentID from Inserted) having count(*) > 3))
		Begin
		RaisError('Cannot add anymore club to this student, max reached', 16, 1)
		Rollback Transaction
		End
	End
go
Drop Trigger Tr_Activity_Insert_Update
Insert into Activity(StudentID, clubID)
values(200322620, 'chess')
Select * from Activity
--2.	The Education Board is concerned with rising course costs! Create a trigger to ensure that a course cost does not get increased by more than 20% at any one time.

--3.	Too many students owe us money and keep registering for more courses! Create a trigger to ensure that a student cannot register for any more courses if they have a balance owing of more than $500.

--4.	Our network security officer suspects our system has a virus that is allowing students to alter their Balance Owing! In order to track down what is happening we want to create a logging table that will log any changes to the BalanceOwing column in the student table. You must create the logging table and the trigger to populate it when a balance owing is updated. LogID is the primary key and will have Identity (1,1).

--BalanceOwingLog
--LogID	int
--StudentID	Int
--ChangeDateTime	datetime
--OldBalance	decimal (7,2)
--NewBalance	decimal (7,2)

--5.	We have learned it is a bad idea to update primary keys. Yet someone keeps trying to update the Club tables ClubID column and the Course tables CourseID column! Create a trigger(s) to stop this from happening! You are authorized to use whatever force is necessary! Well, in your triggers, anyways !

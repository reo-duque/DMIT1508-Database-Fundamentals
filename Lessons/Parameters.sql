--Parameters
--Create Procedure NAME (@parameter datatype)
--as
--sql code
--return

Create Procedure ListOneStudent (@StudentID int)--parenthesis is not needed but it makes it easier to read
as
Select firstName + ' ' + lastName 'StudentName' From Student
Where StudentID = @StudentID
return

execute ListOneStudent 199899200 --parenthesis is not used in executes

--more than one paremeter
Create Procedure ListStudentsByName (@firstName varchar(30), @lastName varchar(30))
as
Select studentID, firstName, lastName, city from Student
where firstName = @firstName and lastName = @lastName
return
go
--Parameters are not optional
execute ListStudentsByName Ivy, Kent
execute ListStudentsByName --not happy --errors
--you can assign defaults to parameters
go

Alter Procedure ListStudentsByName (@firstName varchar(30)=null, @lastName varchar(30)=null)
as
Select studentID, firstName, lastName, city from Student
where firstName = @firstName and lastName = @lastName
return

execute ListStudentsByName --happy now --no errors
execute ListStudentsByName 'Thomas', 'Brown'
--If the SP is called and parameters are not passed to it, let the user know that parameters are required
go

Alter Procedure ListStudentsByName (@firstName varchar(30)=null, @lastName varchar(30)=null)
as
if (@firstName is null or @lastName is null)
	Begin
	RaisError('you must provide a firstname and lastname', 16, 1)--will throw a message to application, tkaes three parameters -message, 16 <-*do not need to know this info* severity level (16 is high level), 1 <--*do not need to know this info* state parameter (not use it anymore)
	End
else
	Begin
	Select studentID, firstName, lastName, city from Student
	where firstName = @firstName and lastName = @lastName
	End
return

execute ListStudentsByName
execute ListStudentsByName 'Thomas'
execute ListStudentsByName 'Brown'
execute ListStudentsByName 'Thomas', 'Brown'
go

--JAXON LEFT AT THIS POINT

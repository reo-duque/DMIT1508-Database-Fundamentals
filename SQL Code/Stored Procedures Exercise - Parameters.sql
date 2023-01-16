--**Stored Procedure has to be the first statement in a batch so place GO in between each question to execute the previous batch (question) and start another. NOTE: all parameters are required. Raise an error message if a parameter is not passed to the procedure.
--1.	Create a stored procedure called “GoodCourses” to select all the course names that have averages  greater than a given value. 
Create Procedure GoodCourses (@avgMark decimal(5,2) = null)
as
if @avgMark is null
	Begin
	RaisError ('You must provide the average', 16, 1)
	End
else
	Select CourseName from Course 
	Inner Join Offering on Offering.CourseID = Course.CourseID
	Inner Join Registration on Registration.OfferingCode = Offering.OfferingCode
	Group By Course.CourseID, CourseName
	Having avg(mark) > @avgMark
return
go

--2.	Create a stored procedure called “HonorCoursesForOneTerm” to select all the course names that have average > a given value in a given semester. *can check parameters in one conditional expression and a common message printed if any of them are missing*
Create Procedure HonorCoursesForOneTerm (@avgMark decimal(5,2)= null, @semester char(5)=null)
as
if @avgMark is null or @semester is null
	Begin
	RaisError ('You must provide the average', 16, 1)
	End
else
	Select CourseName From Course
	Inner Join Offering on Offering.CourseID = Course.CourseID
	Inner Join Semester on Semester.SemesterCode = Offering.SemesterCode
	Inner Join Registration on Registration.OfferingCode = Offering.OfferingCode
	where Semester.SemesterCode = @semester
	Group By Course.CourseID, CourseName
	Having avg(mark) > @avgMark
return

execute HonorCoursesForOneTerm 80, 'A100'
go

--3.	Create a stored procedure called “NotInACourse” that lists the full names of the staff that are not taught a given courseID.
Create Procedure NotInACourse (@courseID char(7) = null)
as
if @courseID is null
	Begin
	RaisError ('You must provide the average', 16, 1)
	End
else
	Begin
	Select firstName + ' ' + lastName 'StaffName' from Staff
	where StaffID not in (Select StaffId from Offering where CourseID = @courseID)
	End
return

execute NotInACourse DMIT101
go

--4.	Create a stored procedure called “ListaProvince” to list all the students names that are in a given province.
Create Procedure ListaProvince (@province char(2) = null)
as
if @province is null
	Begin
	RaisError ('You must provide the average', 16, 1)
	End
else
	Begin
	Select firstName + ' ' + lastName 'StudentName' from Student
	where Province = @province
	End
return
go
--5.	Create a stored procedure called “transcript” to select the transcript for a given studentID. Select the StudentID, full name, course ID’s, course names, and marks.
Create Procedure Transcript (@studentID int = null)
as
if @studentID is null
	Begin
	RaisError ('You must provide the proper input', 16, 1)
	End
else
	Begin
	Select Student.StudentID, firstName + ' ' + lastName 'StudentName', Course.CourseID, CourseName, Mark From Student
	Inner Join Registration on Registration.StudentID = Student.StudentID
	Inner Join Offering on Offering.OfferingCode = Registration.OfferingCode
	Inner Join Course on Course.CourseID = Offering.CourseID
	End
return
go
--6.	Create a stored procedure called “PaymentTypeCount” to select the count of payments made for a given payment type description. 
Create Procedure PaymentTypeCount (@paymenttypedes varchar(40) = null)
as
if @paymenttypedes is null
	Begin
	RaisError('You must provide the proper input', 16, 1)
	End
else
	Begin
	Select count(PaymentID) from Payment Inner Join PaymentType on PaymentType.PaymentTypeID = Payment.PaymentTypeID where PaymentTypeDescription = @paymenttypedes Group By Payment.PaymentID
	End
return
go

--7.	Create stored procedure called “Class List” to select student Full names that are in a course for a given semesterCode and Coursename.
Create Procedure ClassList (@smstrCode char(5) = null , @crsName varchar(40) = null)
as
if (@smstrCode is null or @crsName is null)
	Begin
	RaisError('You must provide the proper input', 16, 1)
	End
else
	Begin
	Select firstName + ' ' + lastName 'StudentName' from Student
	Inner Join Registration on Registration.StudentID = Student.StudentID
	Inner Join Offering on Offering.OfferingCode = Registration.OfferingCode
	Inner Join Course on Course.CourseID = Offering.CourseID
	Inner Join Semester on Semester.SemesterCode = Offering.SemesterCode
	where Semester.SemesterCode = @smstrCode and CourseName = @crsName
	End
return
go
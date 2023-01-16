--1.	Create a stored procedure called “HonorCourses” to select all the course names that have averages >80%. 
Create Procedure HonorCourses
As
Select CourseName From Course
Inner Join Offering on Offering.CourseID = Course.CourseID
Inner Join Registration on Offering.OfferingCode = Registration.Offeringcode
Group by Course.CourseID, CourseName
Having avg(mark) > 80
return

--2.	Create a stored procedure called “HonorCoursesOneTerm” to select all the course names that have average >80% in semester A100.
Create Procedure HonorCoursesOneTerm
As
Select CourseName From Course
Inner Join Offering on Offering.CourseID = Course.CourseID
Inner Join Registration on Offering.OfferingCode = Registration.Offeringcode
Inner Join Semester on Semester.SemesterCode = Offering.SemesterCode
where Semester.SemesterCode = 'A100'
Group by Course.CourseID, CourseName
Having avg(mark) > 80
return

--3.	Oops, made a mistake! For question 2, it should have been for semester A200. Write the code to change the procedure accordingly. 
Alter Procedure HonorCoursesOneTerm
As
Select CourseName From Course
Inner Join Offering on Offering.CourseID = Course.CourseID
Inner Join Registration on Offering.OfferingCode = Registration.Offeringcode
Inner Join Semester on Semester.SemesterCode = Offering.SemesterCode
where Semester.SemesterCode = 'A200'
Group by Course.CourseID, CourseName
Having avg(mark) > 80
return

--4.	Create a stored procedure called “NotInDMIT221” that lists the full names of the staff that have not taught DMIT221.
Create procedure NotInDMIT221
as
Select firstname + ' ' + lastname 'Staff Name' from Staff
where StaffID not in (Select StaffID from offering where CourseId = 'DMIT221')
return

--5.	Create a stored procedure called “Provinces” to list all the students provinces.
Create Procedure Provinces
As
Select distinct Province From Student
return

--6.	OK, question 6 was ridiculously simple and serves no purpose. Lets remove that stored procedure from the database.
Drop Procedure Provinces

--7.	Create a stored procedure called StudentPaymentTypes that lists all the student names and their payment type Description. Ensure all the student names are listed.
Create Procedure StudentPaymentTypes
As
Select Distinct FirstName + ' ' + LastName 'StudentName', PaymentTypeDescription From Student
Left Outer Join Payment on Student.StudentID = Payment.StudentID
Left Outer Join PaymentType on Payment.PaymentTypeID = PaymentType.PaymentTypeID
Return

--8.	Modify the procedure from question 8 to return only the student names that have made payments.
Alter Procedure StudentPaymentTypes
As
Select FirstName + ' ' + LastName 'StudentName', PaymentTypeDescription From Student
Inner Join Payment on Student.StudentID = Payment.StudentID
Inner Join PaymentType on Payment.PaymentTypeID = PaymentType.PaymentTypeID
Return

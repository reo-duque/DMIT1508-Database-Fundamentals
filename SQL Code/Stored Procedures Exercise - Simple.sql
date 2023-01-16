--1.	Create a stored procedure to select all the course names that have averages >80%.
Create Procedure HonorCourses
as
Select coursename  from Course 
inner join offering on Course.CourseId = offering.CourseId
inner join Registration on offering.OfferingCode = Registration.OfferingCode
group by course.courseid, CourseName
having AVG(mark)> 80
return
GO
--2.	Create a stored procedure called �HonorCoursesOneTerm� to select all the course names that have average >80% in semester A100.
Create Procedure HonorCoursesOneTerm
as
Select coursename  from Course 
inner join offering on Course.CourseId = offering.CourseId
inner join Registration on offering.OfferingCode = Registration.OfferingCode
where SemesterCode = 'A100'
group by course.courseid, CourseName
having AVG(mark)> 80
return
GO
--3.	Oops, made a mistake! For question 2, it should have been for semester A200. Write the code to change the procedure accordingly.
Alter Procedure HonorCoursesOneTerm
as
Select coursename  from Course 
inner join offering on Course.CourseId = offering.CourseId
inner join Registration on offering.OfferingCode = Registration.OfferingCode
where SemesterCode = 'A200'
group by course.courseid, CourseName
having AVG(mark)> 80
return
GO
--4.	Create a stored procedure called �NotInDMIT221� that lists the full names of the staff that have not taught DMIT221.
Create procedure NotInDMIT221
as
Select firstname + ' ' + lastname 'Staff Name' from Staff
where StaffID not in (Select StaffID from offering where CourseId = 'DMIT221')
return

GO
--5.	Create a stored procedure to select the course name of the course(s) that have had the lowest number of students in it. assume all courses have registrations.
Create procedure LowNumbers
as
Select coursename from registration 
inner join offering on offering.OfferingCode=Registration.OfferingCode
inner join course on course.CourseId=offering.CourseID
group by course.courseid,coursename
	having COUNT(*) <=all (Select COUNT(*) from registration inner join offering on Registration.OfferingCode=offering.OfferingCode
	 group by CourseId)
return
GO
--6.	Create a stored procedure called �Provinces� to list all the students provinces.
create procedure Provinces
as
Select distinct province from Student
return
GO
--7.	OK, question 6 was ridiculously simple and serves no purpose. Lets remove that stored procedure from the database.
Drop Procedure Provinces
GO
--8.	Create a stored procedure called StudentPaymentTypes that lists all the student names and their payment type descriptions. Ensure all the student names are listed.
create procedure StudentPaymentTypes
as
Select DISTINCT firstname + ' ' + lastname 'student',PaymentTypeDescription from Student
Left outer join Payment on Student.StudentID = Payment.StudentID
Left outer join PaymentType on PaymentType.PaymentTypeID = Payment.PaymentTypeID
return
GO
--9.	Modify the procedure from question 8 to return only the student names that have made payments.
alter procedure StudentPaymentTypes
as
Select firstname + ' ' + lastname 'student' from Student
inner join Payment on Student.StudentID = Payment.StudentID
inner join PaymentType on PaymentType.PaymentTypeID = Payment.PaymentTypeID
return
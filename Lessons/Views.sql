--Views

--A query that is stored in the database
--The results of the query are given a name. This is a view
--We can use a view like a table. We can select from a view

--Create a view that contains all the students names

Go
Create view StudentNameView as Select FirstName, LastName From Student
Go

--Use the view like a table
Select Firstname + ' ' + Lastname 'StudentName' from StudentNameView

--Views contain no data
--When a view is used, the query the view is created from executes, and populate the view to use.
--Why??
--Only show required data
--Simplify complex queries

Go
Create view StudentTranscript as
--Why would you want to type this all out everytime you want a transcript? make a view out of it instead
Select Student.StudentID, Student.FirstName + ' ' + Student.LastName 'StudentName', Mark, Course.CourseID, CourseName, CourseCost, Staff.FirstName + ' ' + Staff.LastName 'StaffName'
From Student
Inner Join Registration on Student.StudentID = Registration.StudentID
Inner Join Offering on Registration.OfferingCode = Offering.OfferingCode
Inner Join Staff on Offering.StaffID = Staff.StaffID
Inner Join Course on Offering.CourseID = Course.CourseID
Go

Select * from StudentTranscript
where StudentID = 199899200

--Maintain a view
--Drop a view
Drop view StudentNameView
--Retrieve the source code
sp_helptext StudentTranscript

--Alter a view -have to rewrite from original script, thats why retrieving the source code is good
Go
Alter view StudentTranscript as
--Why would you want to type this all out everytime you want a transcript? make a view out of it instead
Select Student.StudentID, Student.FirstName + ' ' + Student.LastName 'Student', Mark, Course.CourseID, CourseName, CourseCost, Staff.FirstName + ' ' + Staff.LastName 'Staff'
From Student
Inner Join Registration on Student.StudentID = Registration.StudentID
Inner Join Offering on Registration.OfferingCode = Offering.OfferingCode
Inner Join Staff on Offering.StaffID = Staff.StaffID
Inner Join Course on Offering.CourseID = Course.CourseID
Go
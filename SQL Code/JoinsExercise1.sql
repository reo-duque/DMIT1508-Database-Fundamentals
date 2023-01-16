--1.	Select Student full names and the course ID's they are registered in.
Select * from Student
Select distinct FirstName + ' ' + LastName 'StudentName', Course.CourseID FROM Student INNER JOIN Registration ON Student.StudentID = Registration.StudentID INNER JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode INNER JOIN Course ON Offering.CourseID = Course.CourseID

--2.	Select the Staff full names and the Course ID’s they teach
Select distinct FirstName + ' ' + LastName 'StaffName', Offering.CourseID FROM Staff INNER JOIN Offering ON Staff.StaffID = Offering.StaffID

--3.	Select all the Club ID's and the Student full names that are in them
Select Activity.ClubID, FirstName + ' ' + LastName 'StudentName' FROM Activity INNER JOIN Student ON Activity.StudentID = Student.StudentID

--4.	Select the Student full name, courseID's and marks for studentID 199899200.
Select FirstName + ' ' + LastName 'StudentName', CourseID, Mark From Student INNER JOIN Registration ON Student.StudentID = Registration.StudentID INNER JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode where Student.StudentID = '199899200'

--5.	Select the Student full name, course names and marks for studentID 199899200.
Select FirstName + ' ' + LastName 'StudentName', CourseName, Mark FROM Student INNER JOIN Registration ON Student.StudentID = Registration.StudentID INNER JOIN Offering ON Registration.OfferingCode = Offering.OfferingCode INNER JOIN Course ON Offering.CourseID = Course.CourseID where Student.StudentID = 199899200

--6.	Select the CourseID, CourseNames, and the Semesters they have been taught in
Select Course.CourseID, CourseName, Offering.SemesterCode FROM Course INNER JOIN Offering ON Course.CourseID = Offering.CourseID 
--7.	What Staff Full Names have taught Networking 1?
Select FirstName + ' ' + LastName 'StaffName' FROM Staff INNER JOIN Offering ON Staff.StaffID = Offering.StaffID INNER JOIN Course ON Offering.CourseID = Course.CourseID where CourseName = 'Networking 1'

Select distinct firstname + ' ' + lastname 'Staff Name' from Staff
Inner Join Offering on Staff.StaffID = Offering.StaffID
Inner Join Course on Course.CourseId = offering.CourseId
where CourseName = 'Networking 1'
--8.	What is the course list for student ID 199912010 in semestercode A100. Select the Students Full Name and the CourseNames.
Select FirstName + ' ' + LastName 'StudentName', CourseName from Course Inner Join Offering On Course.CourseID = Offering.CourseID Inner Join Registration On Offering.OfferingCode = Registration.OfferingCode Inner Join Student On Registration.StudentID = Student.StudentID where Student.StudentID = 199912010 and Offering.SemesterCode = 'A100'

--9. What are the Student Names, courseID's that have Marks >80?
Select FirstName + ' ' + LastName 'StudentName', CourseID From Student Inner Join Registration on Student.StudentID = Registration.StudentID Inner Join Offering On Registration.OfferingCode = Offering.OfferingCode where Mark > 80

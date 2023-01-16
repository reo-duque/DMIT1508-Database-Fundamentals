--1. How many staff are there in each position? Select the number and Position Description
 Select Position.PositionDescription, count(Staff.StaffID) 'StaffCount'
 from Staff
 Inner Join Position on Staff.PositionID = Position.PositionID
 group by Position.PositionID, PositionDescription

--2. Select the average mark for each course. Display the CourseName and the average mark
Select CourseName, avg(Mark) 'AverageMark'
from Registration
Inner Join Offering on Registration.OfferingCode = Offering.OfferingCode
Inner Join Course on Offering.CourseID = Course.CourseID
group by Course.CourseID, CourseName

--3. How many payments where made for each payment type. Display the PaymentTypeDescription and the count
 Select PaymentTypeDescription, count(PaymentID) 'NumberofPayments'
 from Payment Inner Join PaymentType on Payment.PaymentTypeID = PaymentType.PaymentTypeID
 group by Payment.PaymentTypeID, PaymentTypeDescription

--4. Select the average Mark for each student. Display the Student Name and their average mark
 Select Student.FirstName +  ' ' +  Student.LastName 'StudentName', avg(Mark)
 From  Student
 Inner Join  Registration on Student.StudentID = Registration.StudentID
 Group By Student.StudentID, Student.FirstName, Student.LastName


--5. Select the same data as question 4 but only show the student names and averages that are > 80
 Select Student.FirstName +  ' ' +  Student.LastName 'StudentName', avg(Mark)
 From  Student
 Inner Join  Registration on Student.StudentID = Registration.StudentID
 Group By Student.StudentID, Student.FirstName, Student.LastName
 Having avg(Mark) >= 80

 
--6.what is the highest, lowest and average payment amount for each payment type Description? 
Select PaymentTypeDescription, max(amount), min(amount), avg(amount)
from Payment
Inner Join PaymentType on Payment.PaymentTypeID = PaymentType.PaymentTypeID
Group By PaymentType.PaymentTypeID, PaymentTypeDescription

--7. How many students are there in each club? Show the clubName and the count
 Select ClubName, Count(*) 'Number of Students'
 From Activity
 Inner Join Club on Activity.ClubID = Club.ClubID
 Group by Club.ClubID, ClubName

--8. Which clubs have 3 or more students in them? Display the Club Names.
Select ClubName from Activity
Inner Join Club
on Acitivty. ClubID = Club.ClubID
group by Club.ClubID, ClubName
Having Count(*) >= 3
 

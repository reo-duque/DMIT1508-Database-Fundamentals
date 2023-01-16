--Inner Join Example
--Transcript of student and course data
Select distinct Student.StudentID, Student.FirstName + ' ' + Student.LastName 'StudentName', Course.CourseID, CourseName, Mark, StartDate, EndDate, Staff.FirstName + ' ' + Staff.LastName 'StaffName'
from Student
Inner Join Registration on Student.StudentID = Registration.StudentID
Inner Join Offering on Registration.OfferingCode = Offering.OfferingCode
Inner Join Semester on Offering.SemesterCode = Semester.SemesterCode
Inner Join Course on Offering.CourseID = Course.CourseID
Inner Join Staff on Offering.StaffID = Staff.StaffID

--Inner Joins with aggregates
--if you have an aggregate function, you can use group by, but you can't use group by unless you have aggregate function
--ex for aggregate: average for class
--ex for group by: average mark for each student <-KEY WORD "FOR EACH" implies the usage of group by
--if you have a group by, you can use "having" <--having is like a where clause except for an aggregate
--ex for having: average mark for students with avg mark >= 80
--Having example
--average mark of all students
Select avg(mark) 'AverageMark' 
from Registration

--average mark for each students
--then show the studentid
Select StudentID, avg(mark) 'AverageMark' 
from Registration
group by StudentID

--average mark for each students but only show the honor students
Select StudentID, avg(mark) 'AverageMark' 
from Registration
group by StudentID
having avg(mark) >= 80

--inner joins with aggregates
Select * from registration
Select * from student

--70 records in registration
--17 records in student

--How many students are taking a course
Select distinct Student.FirstName + ' ' + Student.LastName, Student.StudentID 
from Student 
Inner Join Registration on Student.StudentId = Registration.StudentID
--or
Select distinct StudentID from Registration

--8 Students are taking courses
--9 Students not taking courses

--Select the StudentNames and the average mark for each student that is taking at least one course

Select FirstName + ' ' + LastName 'StudentName', Avg(Mark) 'AverageMark' 
from Registration 
Inner Join Student on Registration.StudentID = Student.StudentID 
group by FirstName, LastName
--the code above will only show 7 records instead of 8 because there are two records with exact same firstname and lastname, therefore the two dave browns got combined and shows their average mark
--we are grouping on student names. So we are getting the avg mark from each different student name, not each different student

Select FirstName + ' ' + LastName 'StudentName', Avg(Mark) 'AverageMark' 
from Registration 
Inner Join Student on Registration.StudentID = Student.StudentID 
group by Student.StudentID, FirstName, LastName
--YOU SHOULD ALWAYS GROUP BY WHAT UNIQUELY IDENTIFIES WHAT YOU WANT TO GROUP ON

--highest mark for each course. show the course name and the mark
Select CourseName, Max(Mark) 'HighestMark'
from Registration 
Inner Join Offering on Registration.OfferingCode = Offering.OfferingCode 
Inner Join Course on Offering.CourseID = Course.CourseID 
group by Course.CourseID, CourseName
--Outer Joins
--Remember  INNER JOINS only return records that have related records in their child tables

--Select all the position Description and the names of the staff in them
Select PositionDescription, FirstName + ' ' + LastName 'StaffName'
From Position
Inner Join Staff on Position.PositionID = Staff.PositionID

--we are not returning one position from above code because there are not staff in that position

--Use outer joins to get ALL the parent records, even if there are no related child records

--left outer joins/right outer joins
--In a 2 table join, you can use whichever one you want.

--Using a left outer  join t o get  All  the  position  descriptions,  the staff in them, even if they have no  staff
Select PositionDescription, FirstName + ' ' + LastName 'StaffName'
From Position
Left Outer Join Staff on Position.PositionID = Staff.PositionID

--same functionality as code above but using right outer join
Select PositionDescription, FirstName + ' ' + LastName 'StaffName'
From Staff
Right Outer Join Position on Staff.PositionID = Position.PositionID

--The following code does not make sense because it behaves like an inner join
Select PositionDescription, FirstName + ' ' + LastName 'StaffName'
From Position
Right Outer Join Staff on Position.PositionID = Staff.PositionID

--For a 2 Table outer join the left/right will ALWAYS point to the PARENT table

--GENERAL RULE - Your outer joins must always point to the data that you want to keep

--Select ALL the student names, their marks, and their courseid's
Select FirstName + ' ' + LastName 'StudentName', Mark, CourseID
From Student
Left Outer Join Registration on Student.StudentID = Registration.StudentID
Left Outer Join Offering on Registration.OfferingCode = Offering.OfferingCode

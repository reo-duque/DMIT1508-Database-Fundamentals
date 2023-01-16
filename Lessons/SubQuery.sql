--SubQueries
--A query inside another statement(query, insert, update, delete)
--A subquery is a full query that can be executed and tested on its own.
--Can usually be used anywhere a value is used
--A subquery can often be used instead of a join, BUT, joins are faster

--The subquery executes first, and the results of that subquery are used by the outer statement.

--join-- Select all the staff names that are a 'Dean'
Select FirstName + ' ' + LastName 'StaffName' From Staff Inner Join Position on Staff.PositionID = Position.PositionID where PositionDescription = 'Dean'

--same question as a subquery
Select FirstName + ' ' + LastName 'StaffName' From Staff
where PositionID = (Select PositionID from Position where PositionDescription='Dean')

--join-- Select the studentID and names of students that have made payments
Select distinct Student.StudentID, FirstName + ' ' + LastName 'StudentName' From Student
Inner Join Payment on Student.StudentID = Payment.StudentID

--same question above as a subquery
Select Student.StudentID, FirstName + ' ' + LastName 'StudentName' From Student
where StudentID in (Select StudentID from Payment)
-- "=" in the above code in place of in because subquery returns more than one value
--if the subquery returns more than one value you must use "in"

--studentid, names of students that have made NO payments
--join
Select Student.StudentID, FirstName + ' ' + LastName 'StudentName' From Student
Left Outer Join Payment on Student.StudentID = Payment.StudentID where PaymentID is null

--subquery
Select Student.StudentID, FirstName + ' ' + LastName 'StudentName' From Student
where StudentID not in (Select StudentID from Payment)

--How many payments has each(and every) student made? Show the studentdID, name and the count
Select Student.StudentID, FirstName + ' ' + LastName 'StudentName', count(*) 'NumberofTimesPaid' From Student
Left Outer Join Payment on Student.StudentID = Payment.StudentID
group by Student.StudentID, FirstName, LastName
--returns a value of 1 to the count(paid) because the outer join returns the students that have no payments and they get counted as 1

--fix --when using count() with outer joins you must count the PK of the child table
--If the parent has no child record, it will be null and therefore not counted
Select Student.StudentID, FirstName + ' ' + LastName 'StudentName', count(PaymentID) 'NumberofTimesPaid' From Student
Left Outer Join Payment on Student.StudentID = Payment.StudentID
group by Student.StudentID, FirstName, LastName
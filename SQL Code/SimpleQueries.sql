--Simple Queries
--Syntax
--Select column(s) from tablename

--Select all the records from the staff table
Select * from staff
-- * means all columns
--NEVER USE SELECT *
--Select * means all the columns in the table. That can change in the future
--Always use the columns by name. More secure and descriptive
Select StaffId, Firstname, LastName, DateHired, DateReleased, PositionID, LoginID from staff -- instead of Select * from staff
-- If you have red squiggles under a table name or column name and you are sure you are correct, the intellisense needs to be refreshed. To do so, ctrl+shift+R.

--Can choose which columns you want.
Select StaffID, FirstName, LastName from staff

--Custom Column Names(aliases)
Select 'StaffFirstName' = FirstName, 'StaffLastName' = LastName from staff
Select FirstName as 'StaffFirstName', LastName as 'StaffLastName' from staff
Select FirstName 'StaffFirstName', LastName 'StaffLastName' from staff

--Custom Columns
--Can contain string concatonation(combining strings) and math
Select firstname + ' ' + lastname 'StaffName' from staff
--ALL COLUMNS MUST HAVE A NAME

--MATH
--Select the courseid, coursename, coursecosts, and sale costs (80% off) of all the courses
Select courseid, coursename, coursecost, coursecost * 0.8 'SaleCosts' from course

--How much money is made from each course if the maximum number of students enrolled. Show the courseid, coursename, and the momey made for each course.
Select courseid, coursename, coursecost * maxstudents 'MoneyMade' from Course

--Select the studentids that are registered in at least one offering
Select StudentID from Registration
--to remove duplicate results, use distinct
Select distinct StudentID from registration
Select distinct StudentID, offeringcode from registration

--Where - used to select the records to return
--where uses the same conditions as check constraints
Select firstname, lastname from student where studentid = 199899200

--Select the paymentID and amount for all the payments that are over 600
Select paymentID, amount from payment where amount > 600

--Select the fullnames (one column) of students whose last names start with 's'
Select firstname + ' ' + lastname 'FullName' from student where lastname like 'S%'

--Select the firstname of students whose studentids are 198933540, 199912010 and 200688700
Select firstname from student where studentid = 198933540 or studentid = 199912010 or studentid = 200688700
Select firstname from student where studentid IN(198933540, 199912010,200688700)
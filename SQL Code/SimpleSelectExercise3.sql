--1. Select the staff names and the name of the month they were hired
Select FirstName + ' ' + LastName 'staff', datename(mm, datehired) 'Hire Month' from Staff


--2. How many days did Tess Agonor work for the school?
Select datediff(dd, datehired, datereleased) 'daysworked' from staff where firstname = 'Tess' and lastname = 'Agonor'

--3. How Many Students where born in each month? Display the Month Name and the Number of Students.
Select datename(mm, birthdate) 'monthName', count(studentid) 'numberofstudentspermonth' from student group by datename(mm,birthdate)

--4. Select the Names of all the students born in December.
Select firstname + ' ' + lastname 'Student' from student where datename(mm, birthdate) = 'december'

--5. select last three characters of all the courses
Select right(coursename, 3) from course

--6. Select the characters in the position description from characters 8 to 13 for PositionID 5
Select substring(positiondescription, 8, 5) from position where positionid = 5


--7. Select all the Student First Names as upper case.
Select Upper(FirstName) 'uppercasefirstname' from student

--8. Select the First Names of students whose first names are 3 characters long.
Select firstname '3charlong' from student where len(firstname) = 3

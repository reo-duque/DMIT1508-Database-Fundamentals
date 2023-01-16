--1.  Select all the information from the club table
Select ClubID, ClubName from club

--2. Select the FirstNames and LastNames of all the students
Select firstname, lastname from student

--3. Select all the CourseId and CourseName of all the coureses. Use the column aliases of Course ID and Course Name
Select courseid 'CourseID', coursename 'CourseName' from course

--4. Select all the course information for courseID 'DMIT101'
Select * from course where courseid = 'DMIT101'

--5. Select the Staff names who have positionID of 3
Select FirstName from Staff where positionID = 3

--6. select the CourseNames whos CourseHours are less than 96
Select coursename from course where coursehours <96

--7. Select the studentID's, OfferingCode and mark where the Mark is between 70 and 80
Select studentid, offeringcode, mark from registration where mark between 70 and 80

--8. Select the studentID's, Offering Code and mark where the Mark is between 70 and 80 and the OfferingCode is 1001 or 1009
Select studentid, offeringcode, mark from registration where mark between 70 and 80 and OfferingCode in (1001,1009)

--9. Select the students first and last names who have last names starting with S
Select firstname, lastname from student where lastname like 's%'

--10. Select Coursenames whose CourseID  have a 1 as the fifth character
Select coursename from course where courseid like '____1%'

--11. Select the CourseID's and Coursenames where the CourseName contains the word 'programming'
Select courseid, coursename from course where coursename like '%programming%'

--12. Select all the ClubNames who start with N or C.
Select clubname from club where clubname like 'n%' or clubname like 'c%'
Select clubname from club where clubname like '[NC]%'

--13. Select Student Names, Street Address and City where the lastName has only 3 letters long.
Select firstname + ' ' + lastname 'StudentName', streetaddress, city from student where lastname like '___'
Select firstname + ' ' + lastname 'StudentName', streetaddress, city from student where len(lastname) = 3

--14. Select all the StudentID's where the PaymentAmount < 500 OR the PaymentTypeID is 5
Select StudentID from Payment where amount < 500 or paymenttypeid = 5
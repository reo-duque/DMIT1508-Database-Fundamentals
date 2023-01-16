--Simple Select Exercise 3
--1. Select the average mark for each offeringCode. Display the OfferingCode and the average mark.
SELECT AVG(Mark), OfferingCode
FROM Registration
GROUP BY OfferingCode

--2. How many payments where made for each payment type. Display the Payment typeID and the count
SELECT COUNT(PaymentID) "AmmountOfPayments", PaymentTypeID
FROM Payment
GROUP BY PaymentTypeID

--3. Select the average Mark for each studentID. Display the StudentId and their average mark
SELECT AVG(Mark) "AverageMark", StudentID
FROM Registration
GROUP BY StudentID

--4. Select the same data as question 3 but only show the studentID's and averages that are > 80
SELECT AVG(Mark) "AverageMark", StudentID
FROM Registration
GROUP BY StudentID
HAVING AVG(Mark) > 80

--5. How many students are from each city? Display the City and the count.
SELECT COUNT(City)"NumOfStudents", City
FROM Student
GROUP BY City

--6. Which cities have 2 or more students from them? (HINT, remember that fields that we use in the where or having do not need to be selected.....)
SELECT City
FROM Student
GROUP BY City
HAVING COUNT(City) >= 2

--7.what is the highest, lowest and average payment amount for each payment type? 
SELECT MAX(Amount) "HighestPayment", MIN(Amount) "LowestPayment", AVG(Amount) "AveragePayment", PaymentTypeID
FROM Payment
GROUP BY PaymentTypeID

--8. How many students are there in each club? Show the clubID and the count
SELECT COUNT(StudentID) "NumberOfStudents", ClubID
FROM Activity
GROUP BY ClubID

--9. Which clubs have 3 or more students in them?
SELECT ClubID
FROM Activity
GROUP BY ClubID
HAVING COUNT(StudentID) >= 3
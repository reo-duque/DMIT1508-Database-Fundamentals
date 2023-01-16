--1.	Select the average Mark from all the Marks in the registration table
Select avg(mark) 'avgMark' from Registration

--2.	Select how many students are there in the Student Table
Select count(studentid) 'studentCount' from student

--3.	Select the average payment amount for payment type 5
Select avg(amount) 'avgPayment' from payment where paymenttypeid = 5

--4. Select the highest payment amount
Select max(amount) 'highestPayment' from payment

--5.	 Select the lowest payment amount
Select min(amount) 'lowestPayment' from payment

--6. Select the total of all the payments that have been made
Select sum(amount) 'totalPayment' from payment

--7. How many different payment types does the school accept?
Select count(paymenttypeid) 'paymentTypeCount' from paymenttype

--8. How many students are in club 'CSS'?
Select count(studentID) 'studentsInCss' from activity where ClubID = 'CSS'

--9. How many students have made at least one payment
Select count(distinct studentID)from payment
Select * from payment
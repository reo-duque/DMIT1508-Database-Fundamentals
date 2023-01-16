--Aggregate Functions
-- Return a single result from many values
--In SQL we use Sum, Min, Max, Average, Count

--Sum - Returns the sum of the selected value
--ex) How much would it cost to take all the courses once
Select sum(coursecost) 'sumCourseCost' from course

--How much would it cost to take all the programming courses(have programming in their course name)
Select sum(coursecost) 'sumofProgrammingCourseCost' from course where coursename like '%programming%'

--Min - returns the lowest value
Select min(coursecost) 'lowestCourseCost' from course

--Max -returns the highest value
Select max(coursecost) 'highestCourseCost' from course

--Average -returns the average value
Select avg(coursecost) 'averageCourseCost' from course

--Count -count(*) - * means 'records' when used in a count function. It does not mean all columns
-- returns number of rows in a table
--ex) how many staff are there?
Select count(*) 'staffCount' from staff

--		-count(columnName) - returns the number of rows in a column that is not null
Select count(coursecost) 'countCourseCost' from course
Select count(datereleased) 'staffCount' from staff
-- Shane recommends to use count(*) or count(PKcolumn) when possible

--Count the number of staff that do not work at the school anymore
Select count(datereleased) 'Released' from staff

--Count the number of staff that do work at the school anymore
Select count(staffID) 'WorkHere' from staff where datereleased is null -- if daterelased = null was used, it would return 0 instead of 9 because nothing is every equal to null
--to evaluate for null you must use "is" instead of "="
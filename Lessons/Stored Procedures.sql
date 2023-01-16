--Stored Procedures
--A bunch of SQL code that is given a name
--Can contain parameteres
--Called by their name
--can contain queries, DML, Logic, if/else, variables, transactions

--Syntax
--Create procedure NAME
--As
--SQL Code
--Return - not a programming return,

Create Procedure listAllStudents
As 
Select firstname, lastname from student
return

--execute
Execute listAllStudents
Exec listAllStudents
listAllStudents -- only works in management studio and the SP has no parameters

--Maintenance
--Same as views
Drop Procedure listAllStudents
--OR
Drop Proc listAllStudents

--Retrieve source doe from the DB
sp_helptext listAllStudents

--Editing an SP
Alter Procedure listAllStudents
As 
Select firstname, lastname, city from student
return

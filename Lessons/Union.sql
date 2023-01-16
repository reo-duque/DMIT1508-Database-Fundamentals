--Union
--Combine the results of more than one query into one result set of data

--Select all the names in the school
Select firstname, lastname from student -- 17
Select firstname, lastname from staff -- 10

Select FirstName, LastName From Student
Union
Select FirstName, LastName from Staff
--Oh no! We lost 2 people
--Union uses distinct by default

Select FirstName, LastName From Student
Union ALL
Select FirstName, LastName from Staff

--To return duplicates, use UNION ALL

--Rules
--Can combine any number of queries
--Queries must have the same number of columns
Select FirstName, LastName,city From Student
Union ALL
Select FirstName, LastName from Staff
--Columns being combined into one column must have similar datatypes
Select FirstName, Birthdate From Student
Union ALL
Select FirstName, LastName from Staff
--Column names are determined from the first query
Select FirstName 'ExampleFirstName', LastName From Student
Union ALL
Select FirstName 'DooDoo', LastName 'DahDah' from Staff
--if you order by, you apply it after the last query
Select FirstName, LastName From Student
Union ALL
Select FirstName, LastName from Staff
order by lastname asc, firstname asc


--Order By
--last clause in order of operations
Select firstname, lastname, city from student 
order by lastname asc --ascending

Select firstname, lastname, city from student 
order by lastname desc --descending

Select firstname, lastname, city from student 
order by lastname desc, firstname desc --descending


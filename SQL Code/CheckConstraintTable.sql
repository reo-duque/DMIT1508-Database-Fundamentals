--Check Constraints - Checks the incoming data to see if it meets certain criteria
					--Basic value checks
					--Pattern Matching(postalCode, phoneNumber)
--syntax is constraint ck_name check (condition)

--Wildcards
  --% - any number of any character(s)
  -- _ - any single character
  --when using wildcards, you MUST use 'like' instead of '='

--default constraint
  --a value that is placed in a column if no value is provided


Drop table CheckConstraint

Create table CheckConstraint
(
ConstraintID int not null identity (1,1) constraint pk_CheckConstraint primary key,
ConstraintType char (3) not null,
PurchaseDate datetime not null,

--Cost must be >= 0
--default of 1 on Cost
Cost smallmoney not null 
constraint ck_validCost check (Cost >=0)
constraint df_Cost default 1,

--SellPrice must be between 0 and 100
--SellPrice must be at least double to cost
SellPrice smallmoney not null constraint ck_validSellPrice check (SellPrice between 0 and 100) ,
--constraint ck_validSellPrice check (SellPrice between 0 and 100) , //between is inclusive

--Active must be a,b,c,d,e,f,g,j, or z
--Active must be a,b,c,d,e,f or g
--Active must be y or n
Active char(1) not null constraint ck_validActive check (Active between 'a' and 'g' or Active = 'j' or Active = 'z'),
--check (Active between 'a' and 'g'),
--check (Active = 'y' or Active = 'n'),

--code must start with s
--Code must start with a and end with z
--Code must start with a, have any 2 characters, then an r and anything after that
Code varchar (30) not null constraint ck_validCode check (Code like 'a__r%'),
--(Code like 's%'),
--(Code like 'a%z')

Identifier varchar (30) not null constraint ck_validIdentifier check (Identifier like '[g-k]___[6-8]%Hello[0-9][0-9]World'),

--(###)###-####	first digit of area code and phone cannot be 0
PhoneNumber char(13) not null constraint ck_validPhone check (PhoneNumber like '([1-9][0-9][0-9])[1-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
PostalCode char(7) not null constraint ck_validPostalCode check (PostalCode like '[a-z][0-9][a-z] [0-9][a-z][0-9]'),

--table level constraint from sellprice comparing sell price and cost
constraint ck_validSellProfit check (SellPrice >= 2 * Cost)
)

insert into CheckConstraint(ConstraintType, PurchaseDate, Cost, SellPrice, Active, Code, Identifier, PhoneNumber, PostalCode)
values('abc','jan 1 2021', default, 25, 'A', 'ambre', 'gref7numberHello69World','(780)555-5555', 'H0H 0H0')

Select * from CheckConstraint

--Exercise
--check constraint on identifier 
--start with letter between g and k
--any 3 characters
--number between 6 and 8
--any number of characters
--"Hello"
--any 2 numbers
--Ending in World
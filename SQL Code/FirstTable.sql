--Basic table
--Every table must have a name, attibutes, datatypes, and null/not null status(on attributes)

--FOOD
--FoodID			int			Not Null
--FoodDescription	varchar(50)	Not Null
--Price				smallmoney	Null
--ExpiryDate		Date		Not Null
--AgeRestriction	bit			Null

--Constraints - Enforce Rules. PK and Fk are constraints
--2 levels of constraints

--Column level - A constraint that involves only a single column. They are coded as part of that columns definition.
--Table Level - A constraint that involves more than one column. They are coded on their own line at the bottom of the table definition

--Primary key constraint - Enforces unique values
--Foreign Key constraint - Enforces that the value you type in the FK has a matching value in the PK of the parent table

--A child object cannot exist without the parent object
--Parent Tables MUST be created first. The FK constraint cannot reference a table that does not exist
--Child Tables MUST be dropped first.

--Identity is used when we want the PK to generate the value for the new record

--Alter Table
--Allows us to make changes to table definitions if the tables have data in them
--We will use alter table to:
--Add columns to a table
--Drop columns from a table
--Add constraints to a table
--Drop existing constraints
--Disable and re-enable an existing constraint
--Alter table statements are separate statements and DO NOT go in the original Create statement

Drop Table OrderFood
Drop Table CustomerOrder
Drop Table Customer
Drop Table Food

Create Table Food
(
FoodID int not null constraint pk_Food primary key,
FoodDescription varchar(50) not null,
Price smallmoney null,
ExpiryDate date not null,
AgeRestriction bit null
)

Create Table Customer
(
CustomerID int identity(100,5) not null constraint pk_Customer primary key,
FirstName varchar(35) not null,
LastName varchar(35) not null
)

Create Table CustomerOrder
(
OrderNumber int identity(1,1) not null constraint pk_CustomerOrder primary key,
OrderDate date not null,
Total smallmoney not null,
CustomerID int not null constraint fk_CustomerOrderToCustomer references Customer(CustomerID)
)


Create Table OrderFood
(
OrderNumber int not null constraint fk_OrderFoodToCustomerOrder references CustomerOrder(OrderNumber) ,
FoodID int not null constraint fk_OrderFoodToFood references Food(FoodID),
Qty smallint not null,
HistoricalPrice smallmoney not null,
constraint pk_OrderFood primary key(OrderNumber,FoodID)
)

insert into Food (FoodID, FoodDescription, Price, ExpiryDate,AgeRestriction)
values (2, 'good food', 10, 'Dec 1, 2022',0) 

Select * from food

insert into customer ( FirstName,LastName)
values
('homer','simpson'),
('marge','simpson'),
('bart','simpson')

insert into CustomerOrder( OrderDate, Total, CustomerID)
values('Dec 2 2021', 100, 100)

select * from CustomerOrder


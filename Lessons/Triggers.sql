Drop Table MovieCharacter
Drop Table Agent
Go

Create Table Agent
(
	AgentID			int identity(1,1)	not null
										constraint PK_Agent primary key clustered,
	AgentName		varchar(70)			not null,
	AgentFee		money				not null
)

Create Table MovieCharacter
(
	CharacterID		int identity(1,1)	not null
										constraint PK_Character primary key clustered,
	CharacterName	varchar(70)			not null,
	CharacterMovie	varchar(70)			not null,
	CharacterRating	char(1)				null 
										constraint DF_characterRating default 3,
	Characterwage	smallmoney			null,
	AgentID			int null			constraint FK_MovieCharacterToAgent
											references Agent(AgentID)
)
Go

Insert Into Agent
	(AgentName, AgentFee)
Values
	('Bob the agent', 50)
Insert Into Agent
	(AgentName, AgentFee)
Values
	('Good Acting For U', 125)
Insert Into Agent
	(AgentName, AgentFee)
Values
	('I represent anyone', 5)

Insert Into MovieCharacter	
	(CharacterName, CharacterMovie, CharacterRating, CharacterWage, AgentID)
Values
	('ET', 'ET The Extraterrestrial', '4', 20000, 3)
Insert Into MovieCharacter
	(CharacterName, CharacterMovie, CharacterRating, CharacterWage, AgentID)
Values
	('Luke Skywalker', 'Star Wars', '5', 12000, 2)
Insert Into MovieCharacter
	(CharacterName, CharacterMovie, CharacterRating, CharacterWage, AgentID)
Values
	('R2D2', 'Star Wars', '4', 0, 1)
Insert Into MovieCharacter
	(CharacterName, CharacterMovie, CharacterRating, CharacterWage, AgentID)
Values
	('Winnie The Pooh', 'Heffalump', '1', 20000, 2)
Insert Into MovieCharacter
	(CharacterName, CharacterMovie, CharacterRating, CharacterWage, AgentID)
Values
	('Guy in red uniform', 'Star Trek II', '4', 20000, 1)

--Triggers
--A bunch of code that executes in response to a particular DML statement on a particular table
--For example - we can create a trigger that will execute automatically when we perform an insert on the student table.
--Trigger Code is stored in the database, just like stored procedures and views
--We maintain triggers in the same manner as stored procedures and views (sp_helptext, alter trigger, drop trigger)
--Triggers are not called explicitly, and do not have parameters

--Why?
--Complex validation that cannot be done with check constraints
--logging, archiving, backups

--A trigger can have more than one DML statement that will cause it to execute

--Syntax
--Create Trigger NAME
--on TABLENAME
--For DML Statement(s)
--as
--SQL CODE
--Return

--simple trigger example
go
Create Trigger TR_Agent_Update --TR_tablename it's gonna execute on_for what dml statement
on Agent
For Update
as
RaisError('Yay, I''m a trigger!', 16, 1)
Return
Go

--Test the trigger
Update agent
set AgentFee = 100
where agentid = 3

--Won't work for other DML statements on that table
Insert into Agent(AgentName, AgentFee)
values ('Shane', 500)
Delete Agent
where AgentName = 'Shane'

--Inserted and deleted tables
--Are created for us by SQL for us to use in our triggers
--Both tables have the same structure(attributes) as the table the trigger is on(base table)
--but they contain different data

--INSERTED TABLE -contains the affected/changed records as they look AFTER the DML statement has executed (after imamge)
--DELETED TABLE -contains the affected/changed records as they look BEFORE the DML statement has executed (before image)

Update Agent
Set AgentFee = 10 --was 50
where AgentID = 1
go
--INSERTED
--AgentID					NAME					FEE
--1							Bob the agent			10

--DELETED
--AgentID					NAME					FEE
--1							Bob the agent			50


--For an insert trigger, the INSERTED table contains the inserted record(s), the DELETED table is empty
--For a delete trigger, the INSERTED table is empty, the DELETED table contains the deleted records

--Trigger to demonstrate what is inside the inserted and deleted tables
Create Trigger TR_MovieCharacter_Update
on MovieCharacter
For Update, Delete, Insert
as
Select * from Inserted
Select * from Deleted
Select * from MovieCharacter
Rollback transaction
Select * from Inserted
Select * from Deleted
Select * from MovieCharacter
Return
Go
Drop Trigger TR_MovieCharacter_Update
--After a rollback, the inserted and deleted tables are empty
--Triggers must work properly if 0, 1, or many records are affected

--Single Record Test
Update MovieCharacter
Set CharacterRating = 5 --was 4
where CharacterID = 1

--Multiple Record Test
Update MovieCharacter
Set CharacterRating = 5
where CharacterMovie like 's%'

--No Record Test
Update MovieCharacter
Set CharacterRating = 5
where CharacterMovie like 'C%'

Insert into MovieCharacter(CharacterName, CharacterMovie, CharacterRating, Characterwage, AgentID)
values ('Naruto', 'Naruto', 3, 10000, 2)
Delete MovieCharacter where CharacterRating = 4

Delete MovieCharacter where CharacterMovie like 'C%'
--Transactions
Create Table Account
(
CustomerID int not null identity(1,1) constraint pk_Acount primary key,
AccountBalance smallmoney not null
)

insert into Account(AccountBalance)
values
(500),
(500),
(1000)

Select * from Account

--Move $200 from Customer1 to Customer2
--2 steps
	--Subract $200 from Cutomer1
	--Adding $200 to Customer2
--Customer1					Customer2
--$500						$500
--$300(-$200)				$700(+$200)
--Same net balance which is good!
--What would happen if an error occured after the $200 was subracted from customer1? --The $200 would be lost
--$300 for customer1 and still $500 for Customer2.

--We need both tasks (BOTH UPDATES) for the transfer to succeed
--we want both updates to succeed or we want both to updates to fail

--transactions are used to ensure a task that involved more than one DML statement fully succeeds or fully fails

Select * from staff
Select * from position

--A single DML statement always fully succeeds or fully fails
--A single DML statement hasa  built in transaction around it

--What about transfer funds?
--When the task you want to complete (like transfer funds) contains more than one DML statement, we need to wrap up the entire task (all the DML statements together) in transaction code

--ONLY USE TRANSACTION CODE WHEN YOUR TASK INVOLVES MORE THAN 1 DML STATEMENT
--Syntax
--Begin transaction <- starts a transaction. any changes to the data after this, are reversible
--Rollback transaction <- reverses the changes to the data between the rollback transaction and the begin transaction. It also ends the transaction
--Commit transaction <- makes the changes to the data between the Begin transaction and commit transaction permanent! It also ends the transaction

--Delete the registration records and rollback
Begin Transaction
Select * from Registration
Delete Registration
Select * from Registration
Rollback Transaction
Select * from Registration

--Delete the registration records and commit
Begin Transaction
Select * from Registration
Delete Registration
Select * from Registration
Commit Transaction
Select * from Registration

--SP to transfer funds
go
Create Procedure TransferFunds(@fromcustomer int = null, @tocustomer int = null, @amount smallmoney = null)
as
if @fromcustomer is null or @tocustomer is null or @amount is null
	Begin
	RaisError('You must provide proper input values', 16, 1)
	End
else
	Begin
	if not exists(Select * from account where customerid = @fromcustomer) or not exists (Select * from account where customerid = @tocustomer)
		Begin
		RaisError('One of the CustomerID''s does not exist', 16, 1)
		End
	else
		Begin
		--Begin transaction right before the first DML Statement
		Begin Transaction
		Update Account
		Set AccountBalance -= @amount from Account where customerID = @fromcustomer
		if @@Error <> 0
			Begin
			RaisError('Subtracting funds failed', 16, 1)
			Rollback Transaction
			End
		else
			Begin
			Update Account
			Set AccountBalance += @amount from Account where customerID = @tocustomer
			if @@Error <> 0
				Begin
				RaisError('Adding funds failed', 16, 1)
				Rollback Transaction
				End
			else
				Begin
				Commit Transaction
				End
			End
		End
	End
return
go
Drop Procedure TransferFunds
Select * from account
execute TransferFunds 1, 2, 200

--Framework for transaction code
--Begin Transaction
--DML1
--if @@Error <> 0
	--RaisError
	--Rollback Transaction
--else
	--DML2
	--if @@Error<>0
		--RaisError
		--RollBack Transaction
	--else
		--DML3
		--etc, etc,

--ONLY USE TRANSACTION CODE WHERE THE TASK(SP) INVOLVES MORE THAN 1 DML STATEMENT
--ALL BEGIN TRANSACTIONS MUST END IN EITHER ROLLBACK OR COMMIT
--ONCE ROLLBACK OR COMMITTED, THE TRANSACTION IS COMPLETE AND YOU CANNOT EXECUTE ANOTHER ROLLBACK OR COMMIT
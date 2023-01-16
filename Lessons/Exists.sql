--Exists
--used to determine if there is at least ONE record that meets certain criteria
--use with if statements

--syntax --returns true or false if a record exists or not
--if exists(query)
--	Begin
--	Code
--	End

--ex. if there is a position that has no staff in it, raise an error 'Need More Staff'
Create Procedure HasStaff (@positionID tinyint = null)
as
if @positionID is null
	Begin
	RaisError('You must provide a proper input', 16, 1)
	End
else
	Begin
	if not exists(Select * from Position where PositionID = @positionID) --in exists clause, you can use "*", since it determines whether there's a record or not
		Begin
		RaisError('Need More Staff', 16, 1)
		End
	End
return
go

execute HasStaff 4
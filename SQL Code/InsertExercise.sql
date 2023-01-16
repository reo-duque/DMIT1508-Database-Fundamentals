--INSERT EXERCISE
--Use the Memories Forever database for this exercise.The current solution has the script to create it if you have not competed the create tables exercise.
--If an insert fails write a brief explanation why. Do not just quote the error message genereated by the server!
--INSERT EXERCISE
--Use the Memories Forever database for this exercise.The current solution has the script to create it if you have not competed the create tables exercise.
--If an insert fails write a brief explanation why. Do not just quote the error message genereated by the server!

--1. Add the following records into the ItemType Table:

--ItemTypeID	ItemTypeDescription
--1				Camera
--2				Lights
--3 			Stand
--2				Backdrop
--89899985225	Outfit
--‘4A’		Other
Insert into ItemType(ItemTypeID, ItemTypeDescription)
values
(1, 'Camera'),
(2, 'Lights'),
(3, 'Stand'),
--(2, 'Backdrop') -- error duplicate itemtypeid not allowed cause its a primary key,
--(89899985225, 'Outfit'), --error 89899985225 is too big of a number
--('4A', 'Other') --error 4A is not an int
Select * from ItemType
.

--GO
--2. Add the following records into the Item Table:


--ItemID	ItemDescription		PricePerDay	ItemTypeID
--			Canon G2			25			1
--			100W tungston		18			2
--			Super Flash			25			4
--			Canon EOS20D		30			1
--5			HP 630				25			1
--			Light Holdomatic	22			3
			
Insert into Item(ItemDescription, PricePerDay, ItemTypeID)
values
('Canon G2', 25, 1),
('100W Tunston' , 18, 2),
--('Super Flash', 25, 4), --error no itemtypeid 4 exists
--('Canon EOS20D', 30, 1), --error, itemtypeid is primary key, cannot be a duplicate
--(5, 'HP 630', 25, 1), --column has less than value inserted, and cannot insert into an identity column
('Light Holdomatic', 22, 3)
--GO
--3.  Add the following records into the StaffType Table:

--StaffTypeID	StaffTypeDescription
--1			Videographer
--2			Photographer
--1			Mixer
-- 			Sales
--3			Sales
Insert into StaffType(StaffTypeID, StaffTypeDescription)
values
(1, 'Videographer'),
(2, 'Photographer'),
--(1, 'Mixer') -- error, stafftypeid is a primarykey and cannot be duplicated
--('Sales'), --error, less values than columns indicated
(3, 'Sales')
	

--Go
--4.  Add the following records into the Staff Table:
	
--StaffID	StaffFirstName	StaffLastName	Phone		Wage	HireDate	StaffTypeID
--1		Joe				Cool			5551223212		23		Jan 1 2007	1
--1		Joe				Cool			5551223212		23		Apr 2 2023	1
--2		Sue				Photo			5556676612		15		Apr 2 2023	3
--3		Jason			Pic				3332342123		***		***			2
						
--***StaffID 3 will have the same wage as the highest wage of all the staff. HireDate will be the same hire date as Joe Cool. Use subqueries for these fields.
Insert into Staff(StaffID, StaffFirstName, StaffLastName, Phone, Wage, HireDate, StafftypeID)
values
--(1, 'Joe', 'Cool', '5551223212', 23, 'January 1, 2007', 1) --error date is not greater than today's date
(1, 'Joe', 'Cool', '5551223212', 23, 'April 2, 2023', 1),
(2, 'Sue', 'Photo', '5556676612', 15, 'April 2, 2023', 3),
(3, 'Jason', 'Pic', '3332342123', (Select Max(Wage) From Staff), (Select HireDate From Staff where StaffFirstName = 'Joe' and StaffLastName = 'Cool'), 2)


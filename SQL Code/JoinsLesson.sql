Select FirstName + ' ' + LastName 'StaffName', PositionDescription 'Position' FROM Staff INNER JOIN Position on Staff.PositionID = Position.PositionID

Select FirstName + ' ' + LastName 'StaffName', PositionDescription 'Position' FROM Staff RIGHT OUTER JOIN Position on Staff.PositionID = Position.PositionID

Select FirstName + ' ' + LastName 'StaffName', PositionDescription 'Position' FROM Staff LEFT OUTER JOIN Position on Staff.PositionID = Position.PositionID

--use inner join if what the table you're looking for always has a matching position on the other table
--this usually happens when your PK has a FK in its table ???
-- eg all staff has a position since staff is the child of position

--use outer join if what you're looking for has a matching table that does not have data
--eg. if a positition does not have a staff member


Select FirstName + ' ' + LastName 'StudentName', PaymentDate, PaymentTypeDescription FROM Student INNER JOIN Payment on Student.StudentID = Payment.StudentID INNER JOIN PaymentType ON Payment.PaymentTypeID = PaymentType.PaymentTypeID

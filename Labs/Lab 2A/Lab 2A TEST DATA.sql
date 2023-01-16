/*
Random Date Script:

DECLARE @FromDate DATETIME2(0)
DECLARE @ToDate   DATETIME2(0)
DECLARE @TimeStamp DATETIME2(0)

SET @FromDate = '2022-09-21 08:22:13' 
SET @ToDate =   '2022-09-30 17:56:31'

DECLARE @Seconds INT = DATEDIFF(SECOND, @FromDate, @ToDate)
DECLARE @Random INT = ROUND(((@Seconds-1) * RAND()), 0)

SET @TimeStamp = (SELECT DATEADD(SECOND, @Random, @FromDate))

*/

--USE [L2A_AnswerKey]
--GO
INSERT INTO [dbo].[Airlines]
            ([AirlineCode]
            ,[Name])
    VALUES
('WJA','WestJet "WestJet" (Calgary/Alberta)')
GO
SET IDENTITY_INSERT [dbo].[Airports] ON
GO
INSERT INTO [dbo].[Airports]
            ([AirportCode]
            ,[Name]
            ,[City]
            ,[Country]
            ,[IATA]
            ,[ICAO]
            ,[Latitude]
            ,[Longitude]
            ,[Altitude]
            ,[TimeZone]
            ,[TzDatabaseTimeZone])
    VALUES
('1028', 'Edmonton International Airport', 'Edmonton', 'Canada', 'YEG', 'CYEG', '53.309700012', '-113.580001831', '2373', '-7', 'America/Edmonton'),
('1134', 'Vancouver International Airport', 'Vancouver', 'Canada', 'YVR', 'CYVR', '49.193901062', '-123.183998108', '14', '-8', 'America/Vancouver'),
('1138', 'Winnipeg / James Armstrong Richardson International Airport', 'Winnipeg', 'Canada', 'YWG', 'CYWG', '49.909999847', '-97.239898682', '783', '-6', 'America/Winnipeg'),
('1156', 'Calgary International Airport', 'Calgary', 'Canada', 'YYC', 'CYYC', '51.113899231', '-114.019996643', '3557', '-7', 'America/Edmonton'),
('1171', 'Lester B. Pearson International Airport', 'Toronto', 'Canada', 'YYZ', 'CYYZ', '43.677200317', '-79.630599976', '569', '-5', 'America/Toronto'),
('1511', 'Phoenix Sky Harbor International Airport', 'Phoenix', 'United States', 'PHX', 'KPHX', '33.434299469', '-112.012001038', '1135', '-7', 'America/Phoenix'),
('1533', 'Los Angeles International Airport', 'Los Angeles', 'United States', 'LAX', 'KLAX', '33.942501070', '-118.407997100', '125', '-8', 'America/Los_Angeles'),
('1887', 'Palm Springs International Airport', 'Palm Springs', 'United States', 'PSP', 'KPSP', '33.829700470', '-116.507003784', '477', '-8', 'America/Los_Angeles')
GO
SET IDENTITY_INSERT [dbo].[Airports] OFF
GO

INSERT INTO [dbo].[Flights]
            ([FlightCode]
            ,[FlightNumber]
            ,[Date]
            ,[DepartureAirport]
            ,[Departure]
            ,[ArrivalAirport]
            ,[Arrival]
            ,[FlightDuration]
            ,[Cancelled]
            ,[IsFull]
            ,[AirlineCode])
    VALUES
('WJA1513-15DEC-0856', 'WJA1513', '2022-12-15', '1533', '08:56:00.0000000', '1511', '2022-12-15 12:36:00.000', '04:44:00.0000000', '0', '0', 'WJA'),
('WJA1537-15DEC-0925', 'WJA1537', '2022-12-15', '1511', '09:25:00.0000000', '1156', '2022-12-15 13:09:00.000', '04:44:00.0000000', '0', '0', 'WJA'),
('WJA4123-15DEC-0916', 'WJA4123', '2022-12-15', '1887', '09:16:00.0000000', '1134', '2022-12-15 11:59:00.000', '04:44:00.0000000', '0', '0', 'WJA'),
('WJA444-15DEC-0707', 'WJA444', '2022-12-15', '1028', '07:07:00.0000000', '1171', '2022-12-15 12:22:00.000', '04:44:00.0000000', '0', '0', 'WJA'),
('WJA444-16DEC-0707', 'WJA444', '2022-12-16', '1171', '07:07:00.0000000', '1028', '2022-12-15 10:22:00.000', '04:44:00.0000000', '0', '0', 'WJA'),
('WJA448-15DEC-0930', 'WJA448', '2022-12-15', '1134', '09:30:00.0000000', '1138', '2022-12-15 13:49:00.000', '04:44:00.0000000', '0', '0', 'WJA'),
('WJA706-15DEC-0916', 'WJA706', '2022-12-15', '1134', '09:16:00.0000000', '1171', '2022-12-15 16:21:00.000', '04:44:00.0000000', '0', '0', 'WJA')
GO
INSERT INTO [dbo].[Payments]
            ([PaymentConfirmationNumber]
            ,[Timestamp]
            ,[Amount]
            ,[PaymentType])
    VALUES
('58F93C75-3AE7-49EE-8FEF-0D57A1AA633D', '2022-09-21 15:44:14.000', '1540.00', 'CREDIT'),
('858A21F1-F960-4E43-BA5C-91B3A3973622', '2022-09-29 22:21:50.000', '3180.00', 'CREDIT'),
('5BCCD98A-DE55-40C5-B8B0-DC51AA8E304D', '2022-09-25 03:58:46.000', '2410.00', 'CREDIT'),
('49057B0B-27E7-4B56-8597-DEBAFD825545', '2022-09-25 21:49:13.000', '770.00', 'PayPal')
GO
INSERT INTO [dbo].[Bookings]
            ([ConfirmationNumber]
            ,[FlightCode]
            ,[PaymentConfirmationNumber]
            ,[FirstName]
            ,[MiddleName]
            ,[LastName]
            ,[PhoneNumber]
            ,[AlternatePhoneNumber]
            ,[EmailAddress]
            ,[StreetAddress]
            ,[City]
            ,[Region]
            ,[Country])
    VALUES
('3AE7-49EE-8', 'WJA444-15DEC-0707', '58F93C75-3AE7-49EE-8FEF-0D57A1AA633D', 'Indigo', NULL, 'Tharp'   , '1-474-337-7977', NULL, 'nighthawk@att.net'   ,'112 Avenue NW', 'Edmonton', 'Alberta', 'Canada'),
('F960-4E43-B', 'WJA444-16DEC-0707', '858A21F1-F960-4E43-BA5C-91B3A3973622', 'Falk',   NULL, 'Ell'     , '1-236-407-1742', NULL, 'jonas@sbcglobal.net' ,'Brintnell Boulevard NW', 'Edmonton', 'Alberta', 'Canada'),
('DE55-40C5-B', 'WJA444-15DEC-0707', '5BCCD98A-DE55-40C5-B8B0-DC51AA8E304D', 'Gautam', NULL, 'Vankleek', '1-587-710-6652', NULL, 'mcraigw@outlook.com' ,'83 Avenue NW', 'Edmonton', 'Alberta', 'Canada'),
('27E7-4B56-8', 'WJA444-16DEC-0707', '49057B0B-27E7-4B56-8597-DEBAFD825545', 'Joleen', NULL, 'Niemela' , '1-587-881-5936', NULL, 'jfmulder@outlook.com','141 Avenue NW', 'Edmonton', 'Alberta', 'Canada')
GO
INSERT INTO [dbo].[Passengers]
            ([ConfirmationNumber]
            ,[CustomerId]
            ,[FirstName]
            ,[MiddleName]
            ,[LastName]					
            ,[PhoneNumber]
            ,[AgeGroup])
    VALUES
('3AE7-49EE-8', 1, 'Indigo', NULL, 'Tharp'   , '1-474-337-7977', 'Adult'),
('3AE7-49EE-8', 2, 'Mary', NULL, 'Tharp'      , NULL, 'Adult'),

('F960-4E43-B', 1, 'Falk',   NULL, 'Ell'       ,'1-236-407-1742', 'Adult'),
('F960-4E43-B', 2, 'Miles',   NULL, 'Ell'        , NULL, 'Adult'),
('F960-4E43-B', 3, 'Howard',   NULL, 'Ell'       , NULL, 'Senior'),
('F960-4E43-B', 4, 'Colton',   NULL, 'Ell'       , NULL, 'Adult'),

('DE55-40C5-B', 1, 'Gautam', NULL, 'Vankleek'   ,'1-587-710-6652', 'Adult'),
('DE55-40C5-B', 2, 'Del',    NULL, 'Vankleek'   , NULL, 'Child'),
('DE55-40C5-B', 3, 'Corvina', NULL, 'Vankleek'   , NULL, 'Adult'),

('27E7-4B56-8', 1, 'Joleen', NULL, 'Niemela'    ,'1-587-881-5936', 'Adult')
GO

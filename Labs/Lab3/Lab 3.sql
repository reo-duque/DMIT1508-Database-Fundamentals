
-- Drop Tables
Drop Table if exists BookingsArchive;
Drop Table if exists Passengers;
Drop Table if exists Bookings;
Drop Table if exists Payments;
Drop Table if exists Flights;
Drop Table if exists Airlines;
Drop Table if exists Airports;
Go

-- Create Tables
Create Table Airports
(		
	AirportCode					int 			Identity(1000,1)
												Not Null
												Constraint PK_Airports_AirportCode Primary Key,
	Name						varchar(90)		Not Null,
	City						varchar(35)		Not Null,
	Country						varchar(35)		Not Null,
	IATA						char(3)			Null,
	ICAO						char(4)			Null,
	Latitude					decimal(12,9)	Not Null,
	Longitude					decimal(12,9)	Not Null,
	Altitude					int				Not Null,
	Timezone					decimal(2,0)	Not Null,
	TzDatabaseTimeZone			varchar(50)		Not Null
);

Create Table Airlines
(		
	AirlineCode					char(3)			Not Null
												Constraint PK_Airlines_AirlineCode Primary Key,
	Name						varchar(85)		Not Null	
);


Create Table Flights
(	
	FlightCode					varchar(18)		Not Null
												Constraint PK_Flights_FlightCode Primary Key,
	FlightNumber				varchar(8)		Not Null,
	Date						date			Not Null,
	DepartureAirport			int				Not Null
												Constraint FK_Flights_DepartureAirport_To_Airports_AirportCode
													References Airports (AirportCode),
	Departure					time			Not Null,
	ArrivalAirport				int				Not Null
												Constraint FK_Flights_ArrivalAirport_To_Airports_AirportCode
													References Airports (AirportCode),
	Arrival						datetime		Not Null,
	FlightDuration				time			Not Null,
	Cancelled					char(1)			Not Null
												Constraint DF_Flights_Cancelled_N
													Default 'N',
	IsFull						char(1)			Not Null
												Constraint DF_Flights_IsFull_N
													Default 'N',
	AirlineCode					char(3)			Not Null
												Constraint FK_Flights_AirlineCode_To_Flights_AirlineCode
													References Airlines (AirlineCode),
	Constraint CK_Flights_DepartureAirport_NotEqual_ArrivalAirport 
		Check (DepartureAirport != ArrivalAirport)
);


Create Table Payments
(
	PaymentConfirmationNumber	varchar(40)		Not Null
												Constraint PK_Payments_PaymentConfirmationNumber Primary Key,
	Timestamp					datetime		Not Null
												Constraint DF_Payments_Timestamp_CurrentDateTime
													Default GetDate(),
	Amount						money			Not Null
												Constraint CK_Payments_Amount_Gr_Zero
													Check (Amount > 0),
	PaymentType					varchar(10)		Not Null
);


Create Table Bookings
(
	ConfirmationNumber			char(11)		Not Null
												Constraint PK_Bookings_ConfirmationNumber Primary Key,
	FlightCode					varchar(18)		Not Null
												Constraint FK_Bookings_FlightCode_To_Flights_FlightCode
													References Flights (FlightCode),
	PaymentConfirmationNumber	varchar(40)		Null
												Constraint FK_Bookings_PaymentConfirmationNumber_To_Payments_PaymentConfirmationNumber
													References Payments (PaymentConfirmationNumber),
	FirstName					varchar(40)		Not Null,
	MiddleName					varchar(40)		Null,
	LastName					varchar(40)		Not Null,
	PhoneNumber					char(14)		Not Null
												Constraint CK_Bookings_PhoneNumber_Format
													Check (PhoneNumber Like '[0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
	AlternatePhoneNumber		char(14)		Null
												Constraint CK_Bookings_AlternatePhoneNumber_Format
													Check (AlternatePhoneNumber Like '[0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
	EmailAddress				varchar(50)		Not Null,
	StreetAddress				varchar(50)		Not Null,
	City						varchar(40)		Not Null,
	Region						varchar(25)		Null,
	Country						varchar(35)		Not Null,
	PassengerCount				int				Not Null
												Constraint DF_Bookings_PassengerCount_Zero
													Default 0
);


Create Table Passengers
(
	ConfirmationNumber			char(11)		Not Null
												Constraint FK_Passengers_ConfirmationNumber_To_Bookings_ConfirmationNumber
													References Bookings (ConfirmationNumber),
	CustomerID					int				Not Null,
	FirstName					varchar(40)		Not Null,
	MiddleName					varchar(40)		Null,
	LastName					varchar(40)		Not Null,
	PhoneNumber					char(14)		Null
												Constraint CK_Passengers_PhoneNumber_Format
													Check (PhoneNumber Like '[0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
	DateOfBirth					date			Not Null,
	Constraint PK_Passengers_ConfirmationNumber_CustomerID
		Primary Key Clustered (ConfirmationNumber, CustomerID)
);

Create Table BookingsArchive
(
	ConfirmationNumber			char(11)		Not Null,
	FlightCode					varchar(18)		Not Null,
	PaymentConfirmationNumber	varchar(40)		Null,
	FirstName					varchar(40)		Not Null,
	MiddleName					varchar(40)		Null,
	LastName					varchar(40)		Not Null,
	PhoneNumber					char(14)		Not Null,
	AlternatePhoneNumber		char(14)		Null,
	EmailAddress				varchar(50)		Not Null,
	StreetAddress				varchar(50)		Not Null,
	City						varchar(40)		Not Null,
	Region						varchar(25)		Null,
	Country						varchar(35)		Not Null,
	PassengerCount				int				Not Null
);
Go

-- Create Indexes
Create Index IX_Flights_DepartureAirport			On Flights (DepartureAirport)
Create Index IX_Flights_ArrivalAirport				On Flights (ArrivalAirport)
Create Index IX_Flights_AirlineCode					On Flights (AirlineCode)
Create Index IX_Bookings_FlightCode					On Bookings (FlightCode)
Create Index IX_Bookings_PaymentConfirmationNumber	On Bookings (PaymentConfirmationNumber)
Create Index IX_Passengers_ConfirmationNumber		On Passengers (ConfirmationNumber)
Go

-- Delete old data
Delete From Passengers
Delete From Bookings
Delete From Payments
Delete From Flights
Delete From Airlines
Delete From Airports
Go

-- Insert new data
SET IDENTITY_Insert Airports ON 
Go
Insert Into Airports
	(AirportCode, Name, City, Country, IATA, ICAO, Latitude, Longitude, Altitude, TimeZone, TzDatabaseTimeZone)
Values
	(1028, 'Edmonton International Airport', 'Edmonton', 'Canada', 'YEG', 'CYEG', CAST(53.309700012 AS Decimal(12, 9)), CAST(-113.580001831 AS Decimal(12, 9)), 2373, -7, 'America/Edmonton'),
	(1134, 'Vancouver International Airport', 'Vancouver', 'Canada', 'YVR', 'CYVR', CAST(49.193901062 AS Decimal(12, 9)), CAST(-123.183998108 AS Decimal(12, 9)), 14, -8, 'America/Vancouver'),
	(1138, 'Winnipeg / James Armstrong Richardson International Airport', 'Winnipeg', 'Canada', 'YWG', 'CYWG', CAST(49.909999847 AS Decimal(12, 9)), CAST(-97.239898682 AS Decimal(12, 9)), 783, -6, 'America/Winnipeg'),
	(1156, 'Calgary International Airport', 'Calgary', 'Canada', 'YYC', 'CYYC', CAST(51.113899231 AS Decimal(12, 9)), CAST(-114.019996643 AS Decimal(12, 9)), 3557, -7, 'America/Edmonton'),
	(1171, 'Lester B. Pearson International Airport', 'Toronto', 'Canada', 'YYZ', 'CYYZ', CAST(43.677200317 AS Decimal(12, 9)), CAST(-79.630599976 AS Decimal(12, 9)), 569, -5, 'America/Toronto'),
	(1511, 'Phoenix Sky Harbor International Airport', 'Phoenix', 'United States', 'PHX', 'KPHX', CAST(33.434299469 AS Decimal(12, 9)), CAST(-112.012001038 AS Decimal(12, 9)), 1135, -7, 'America/Phoenix'),
	(1533, 'Los Angeles International Airport', 'Los Angeles', 'United States', 'LAX', 'KLAX', CAST(33.942501070 AS Decimal(12, 9)), CAST(-118.407997100 AS Decimal(12, 9)), 125, -8, 'America/Los_Angeles'),
	(1887, 'Palm Springs International Airport', 'Palm Springs', 'United States', 'PSP', 'KPSP', CAST(33.829700470 AS Decimal(12, 9)), CAST(-116.507003784 AS Decimal(12, 9)), 477, -8, 'America/Los_Angeles'),
	(1888, 'Campbell River Airport', 'Campbell River', 'Canada', 'YBL', 'CYBL', CAST(49.950801849 AS Decimal(12, 9)), CAST(-125.271003723 AS Decimal(12, 9)), 346, -8, 'America/Vancouver'),
	(1889, 'Deer Lake Airport', 'Deer Lake', 'Canada', 'YDF', 'CYDF', CAST(49.210800171 AS Decimal(12, 9)), CAST(-57.391399384 AS Decimal(12, 9)), 72, -4, 'America/St_Johns'),
	(1890, 'Dease Lake Airport', 'Dease Lake', 'Canada', 'YDL', 'CYDL', CAST(58.422199249 AS Decimal(12, 9)), CAST(-130.031997681 AS Decimal(12, 9)), 2600, -8, 'America/Vancouver'),
	(1891, 'John C. Munro Hamilton International Airport', 'Hamilto', 'Canada', 'YHM', 'CYHM', CAST(43.173599243 AS Decimal(12, 9)), CAST(-79.934997559 AS Decimal(12, 9)), 780, -5, 'America/Toronto'),
	(1892, 'Halifax / Stanfield International Airport', 'Halifax', 'Canada', 'YHZ', 'CYHZ', CAST(44.880798340 AS Decimal(12, 9)), CAST(-63.508598328 AS Decimal(12, 9)), 477, -4, 'America/Halifax'),
	(1893, 'Waterloo Airport', 'Waterloo', 'Canada', 'YKF', 'CYKF', CAST(43.460800171 AS Decimal(12, 9)), CAST(-80.378601074 AS Decimal(12, 9)), 1055, -5, 'America/Toronto'),
	(1894, 'Kelowna International Airport', 'Kelowna', 'Canada', 'YLW', 'CYLW', CAST(49.956100464 AS Decimal(12, 9)), CAST(-119.377998352 AS Decimal(12, 9)), 1421, -8, 'America/Vancouver'),
	(1895, 'Old Crow Airport', 'Old Crow', 'Canada', 'YOC', 'CYOC', CAST(67.570602417 AS Decimal(12, 9)), CAST(-139.839004517 AS Decimal(12, 9)), 824, -8, 'America/Vancouver'),
	(1896, 'Ottawa Macdonald-Cartier International Airport', 'Ottawa', 'Canada', 'YOW', 'CYOW', CAST(45.322498322 AS Decimal(12, 9)), CAST(-75.669197083 AS Decimal(12, 9)), 374, -5, 'America/Toronto'),
	(1897, 'Quebec Jean Lesage International Airport', 'Quebec', 'Canada', 'YQB', 'CYQB', CAST(46.791100000 AS Decimal(12, 9)), CAST(-71.393303000 AS Decimal(12, 9)), 244, -5, 'America/Toronto'),
	(1898, 'Lethbridge County Airport', 'Lethbridge', 'Canada', 'YQL', 'CYQL', CAST(49.630298615 AS Decimal(12, 9)), CAST(-112.800003052 AS Decimal(12, 9)), 3048, -7, 'America/Edmonton'),
	(1899, 'Montreal / Pierre Elliott Trudeau International Airport', 'Montreal', 'Canada', 'YUL', 'CYUL', CAST(45.470600128 AS Decimal(12, 9)), CAST(-73.740798950 AS Decimal(12, 9)), 118, -5, 'America/Toronto'),
	(1900, 'Cranbrook/Canadian Rockies International Airport', 'Cranbrook', 'Canada', 'YXC', 'CYXC', CAST(49.610801697 AS Decimal(12, 9)), CAST(-115.781997681 AS Decimal(12, 9)), 3082, -7, 'America/Edmonton'),
	(1901, 'Prince George Airport', 'Prince George', 'Canada', 'YXS', 'CYXS', CAST(53.889400482 AS Decimal(12, 9)), CAST(-122.679000854 AS Decimal(12, 9)), 2267, -8, 'America/Vancouver'),
	(1902, 'Northwest Regional Airport Terrace-Kitimat', 'Terrace', 'Canada', 'YXT', 'CYXT', CAST(54.468498000 AS Decimal(12, 9)), CAST(-128.576009000 AS Decimal(12, 9)), 713, -8, 'America/Vancouver'),
	(1903, 'Abbotsford Airport', 'Abbotsford', 'Canada', 'YXX', 'CYXX', CAST(49.025299072 AS Decimal(12, 9)), CAST(-122.361000061 AS Decimal(12, 9)), 195, -8, 'America/Vancouver'),
	(1904, 'Whitehorse / Erik Nielsen International Airport', 'Whitehorse', 'Canada', 'YXY', 'CYXY', CAST(60.709598541 AS Decimal(12, 9)), CAST(-135.067001343 AS Decimal(12, 9)), 2317, -8, 'America/Vancouver'),
	(1905, 'Charlottetown Airport', 'Charlottetow', 'Canada', 'YYG', 'CYYG', CAST(46.290000916 AS Decimal(12, 9)), CAST(-63.121101379 AS Decimal(12, 9)), 160, -4, 'America/Halifax'),
	(1906, 'Victoria International Airport', 'Victoria', 'Canada', 'YYJ', 'CYYJ', CAST(48.646900177 AS Decimal(12, 9)), CAST(-123.426002502 AS Decimal(12, 9)), 63, -8, 'America/Vancouver'),
	(1907, 'St. JohNulls International Airport', 'St. JohNulls', 'Canada', 'YYT', 'CYYT', CAST(47.618598938 AS Decimal(12, 9)), CAST(-52.751899719 AS Decimal(12, 9)), 461, -4, 'America/St_Johns'),
	(1908, 'Yellowknife Airport', 'Yellowknife', 'Canada', 'YZF', 'CYZF', CAST(62.462799072 AS Decimal(12, 9)), CAST(-114.440002441 AS Decimal(12, 9)), 675, -7, 'America/Edmonton'),
	(1909, 'Houari Boumediene Airport', 'Algier', 'Algeria', 'ALG', 'DAAG', CAST(36.691001892 AS Decimal(12, 9)), CAST(3.215409994 AS Decimal(12, 9)), 82, 1, 'Africa/Algiers'),
	(1910, 'Brussels Airport', 'Brussels', 'Belgium', 'BRU', 'EBBR', CAST(50.901401520 AS Decimal(12, 9)), CAST(4.484439850 AS Decimal(12, 9)), 184, 1, 'Europe/Brussels'),
	(1911, 'Frankfurt am Main Airport', 'Frankfurt', 'Germany', 'FRA', 'EDDF', CAST(50.033333000 AS Decimal(12, 9)), CAST(8.570556000 AS Decimal(12, 9)), 364, 1, 'Europe/Berli'),
	(1912, 'London Gatwick Airport', 'Londo', 'United Kingdom', 'LGW', 'EGKK', CAST(51.148102000 AS Decimal(12, 9)), CAST(-0.190278000 AS Decimal(12, 9)), 202, 0, 'Europe/Londo'),
	(1913, 'London Heathrow Airport', 'Londo', 'United Kingdom', 'LHR', 'EGLL', CAST(51.470600000 AS Decimal(12, 9)), CAST(-0.461941000 AS Decimal(12, 9)), 83, 0, 'Europe/Londo'),
	(1914, 'Dublin Airport', 'Dubli', 'Ireland', 'DUB', 'EIDW', CAST(53.421299000 AS Decimal(12, 9)), CAST(-6.270070000 AS Decimal(12, 9)), 242, 0, 'Europe/Dubli'),
	(1915, 'Mohammed V International Airport', 'Casablanca', 'Morocco', 'CM', 'GMM', CAST(33.367500305 AS Decimal(12, 9)), CAST(-7.589970112 AS Decimal(12, 9)), 656, 0, 'Africa/Casablanca'),
	(1916, 'Barcelona International Airport', 'Barcelona', 'Spai', 'BC', 'LEBL', CAST(41.297100000 AS Decimal(12, 9)), CAST(2.078460000 AS Decimal(12, 9)), 12, 1, 'Europe/Madrid'),
	(1917, 'Lyon Saint-Exupéry Airport', 'Lyo', 'France', 'LYS', 'LFLL', CAST(45.725556000 AS Decimal(12, 9)), CAST(5.081111000 AS Decimal(12, 9)), 821, 1, 'Europe/Paris'),
	(1918, 'Charles de Gaulle International Airport', 'Paris', 'France', 'CDG', 'LFPG', CAST(49.012798000 AS Decimal(12, 9)), CAST(2.550000000 AS Decimal(12, 9)), 392, 1, 'Europe/Paris'),
	(1919, 'Ben Gurion International Airport', 'Tel-aviv', 'Israel', 'TLV', 'LLBG', CAST(32.011398315 AS Decimal(12, 9)), CAST(34.886699677 AS Decimal(12, 9)), 135, 2, 'Asia/Jerusalem'),
	(1920, 'Humberto Delgado Airport (Lisbonn Portela Airport)', 'Lisbon', 'Portugal', 'LIS', 'LPPT', CAST(38.781300000 AS Decimal(12, 9)), CAST(-9.135920000 AS Decimal(12, 9)), 374, 0, 'Europe/Lisbon'),
	(1921, 'Zürich Airport', 'Zurich', 'Switzerland', 'ZRH', 'LSZH', CAST(47.464699000 AS Decimal(12, 9)), CAST(8.549170000 AS Decimal(12, 9)), 1416, 1, 'Europe/Zurich'),
	(1922, 'Punta Cana International Airport', 'Punta Cana', 'Dominican Republic', 'PUJ', 'MDPC', CAST(18.567399979 AS Decimal(12, 9)), CAST(-68.363403320 AS Decimal(12, 9)), 47, -4, 'America/Santo_Domingo'),
	(1923, 'Licenciado Gustavo Díaz Ordaz International Airport', 'Puerto Vallarta', 'Mexico', 'PVR', 'MMPR', CAST(20.680099487 AS Decimal(12, 9)), CAST(-105.253997803 AS Decimal(12, 9)), 23, -6, 'America/Mexico_City'),
	(1924, 'Cancún International Airport', 'Cancu', 'Mexico', 'CU', 'MMU', CAST(21.036500931 AS Decimal(12, 9)), CAST(-86.877098084 AS Decimal(12, 9)), 22, -5, 'America/Cancu'),
	(1925, 'Daniel Oduber Quiros International Airport', 'Liberia', 'Costa Rica', 'LIR', 'MRLB', CAST(10.593300000 AS Decimal(12, 9)), CAST(-85.544403000 AS Decimal(12, 9)), 270, -6, 'America/Costa_Rica'),
	(1926, 'Juan Santamaria International Airport', 'San Jose', 'Costa Rica', 'SJO', 'MROC', CAST(9.993860245 AS Decimal(12, 9)), CAST(-84.208801270 AS Decimal(12, 9)), 3021, -6, 'America/Costa_Rica'),
	(1927, 'Juan Gualberto Gomez International Airport', 'Varadero', 'Cuba', 'VRA', 'MUVR', CAST(23.034400940 AS Decimal(12, 9)), CAST(-81.435302734 AS Decimal(12, 9)), 210, -5, 'America/Havana'),
	(1928, 'Lynden Pindling International Airport', 'Nassau', 'Bahamas', 'NAS', 'MY', CAST(25.038999558 AS Decimal(12, 9)), CAST(-77.466201782 AS Decimal(12, 9)), 16, -5, 'America/Nassau'),
	(1929, 'Narita International Airport', 'Tokyo', 'Japa', 'NRT', 'RJAA', CAST(35.764701843 AS Decimal(12, 9)), CAST(140.386001587 AS Decimal(12, 9)), 141, 9, 'Asia/Tokyo'),
	(1930, 'Indira Gandhi International Airport', 'Delhi', 'India', 'DEL', 'VIDP', CAST(28.566500000 AS Decimal(12, 9)), CAST(77.103104000 AS Decimal(12, 9)), 777, 6, 'Asia/Calcutta'),
	(1931, 'General Edward Lawrence Logan International Airport', 'Bosto', 'United States', 'BOS', 'KBOS', CAST(42.364299770 AS Decimal(12, 9)), CAST(-71.005203250 AS Decimal(12, 9)), 20, -5, 'America/New_York'),
	(1932, 'Kahului Airport', 'Kahului', 'United States', 'OGG', 'PHOG', CAST(20.898600000 AS Decimal(12, 9)), CAST(-156.429993000 AS Decimal(12, 9)), 54, -10, 'Pacific/Honolulu'),
	(1933, 'San Francisco International Airport', 'San Francisco', 'United States', 'SFO', 'KSFO', CAST(37.618999481 AS Decimal(12, 9)), CAST(-122.375000000 AS Decimal(12, 9)), 13, -8, 'America/Los_Angeles'),
	(1934, 'Newark Liberty International Airport', 'Newark', 'United States', 'EWR', 'KEWR', CAST(40.692501068 AS Decimal(12, 9)), CAST(-74.168701172 AS Decimal(12, 9)), 18, -5, 'America/New_York'),
	(1935, 'George Bush Intercontinental Houston Airport', 'Housto', 'United States', 'IAH', 'KIAH', CAST(29.984399796 AS Decimal(12, 9)), CAST(-95.341400146 AS Decimal(12, 9)), 97, -6, 'America/Chicago'),
	(1936, 'Miami International Airport', 'Miami', 'United States', 'MIA', 'KMIA', CAST(25.793199539 AS Decimal(12, 9)), CAST(-80.290603638 AS Decimal(12, 9)), 8, -5, 'America/New_York'),
	(1937, 'Seattle Tacoma International Airport', 'Seattle', 'United States', 'SEA', 'KSEA', CAST(47.449001000 AS Decimal(12, 9)), CAST(-122.308998000 AS Decimal(12, 9)), 433, -8, 'America/Los_Angeles'),
	(1938, 'Hartsfield Jackson Atlanta International Airport', 'Atlanta', 'United States', 'ATL', 'KATL', CAST(33.636700000 AS Decimal(12, 9)), CAST(-84.428101000 AS Decimal(12, 9)), 1026, -5, 'America/New_York'),
	(1939, 'Nashville International Airport', 'Nashville', 'United States', 'BNA', 'KBNA', CAST(36.124500275 AS Decimal(12, 9)), CAST(-86.678199768 AS Decimal(12, 9)), 599, -6, 'America/Chicago'),
	(1940, 'Portland International Airport', 'Portland', 'United States', 'PDX', 'KPDX', CAST(45.588699340 AS Decimal(12, 9)), CAST(-122.597999600 AS Decimal(12, 9)), 31, -8, 'America/Los_Angeles'),
	(1941, 'Daniel K Inouye International Airport', 'Honolulu', 'United States', 'HNL', 'PHNL', CAST(21.320620000 AS Decimal(12, 9)), CAST(-157.924228000 AS Decimal(12, 9)), 13, -10, 'Pacific/Honolulu'),
	(1942, 'San Diego International Airport', 'San Diego', 'United States', 'SA', 'KSA', CAST(32.733600617 AS Decimal(12, 9)), CAST(-117.190002441 AS Decimal(12, 9)), 17, -8, 'America/Los_Angeles'),
	(1943, 'Denver International Airport', 'Denver', 'United States', 'DE', 'KDE', CAST(39.861698151 AS Decimal(12, 9)), CAST(-104.672996521 AS Decimal(12, 9)), 5431, -7, 'America/Denver'),
	(1944, 'Ted Stevens Anchorage International Airport', 'Anchorage', 'United States', 'ANC', 'PANC', CAST(61.174400330 AS Decimal(12, 9)), CAST(-149.996002197 AS Decimal(12, 9)), 152, -9, 'America/Anchorage'),
	(1945, 'John F Kennedy International Airport', 'New York', 'United States', 'JFK', 'KJFK', CAST(40.639801030 AS Decimal(12, 9)), CAST(-73.778900150 AS Decimal(12, 9)), 13, -5, 'America/New_York'),
	(1946, 'Chicago ONullHare International Airport', 'Chicago', 'United States', 'ORD', 'KORD', CAST(41.978600000 AS Decimal(12, 9)), CAST(-87.904800000 AS Decimal(12, 9)), 672, -6, 'America/Chicago'),
	(1947, 'McCarran International Airport', 'Las Vegas', 'United States', 'LAS', 'KLAS', CAST(36.080101010 AS Decimal(12, 9)), CAST(-115.152000400 AS Decimal(12, 9)), 2181, -8, 'America/Los_Angeles'),
	(1948, 'Orlando International Airport', 'Orlando', 'United States', 'MCO', 'KMCO', CAST(28.429399490 AS Decimal(12, 9)), CAST(-81.308998108 AS Decimal(12, 9)), 96, -5, 'America/New_York'),
	(1949, 'Incheon International Airport', 'Seoul', 'South Korea', 'IC', 'RKSI', CAST(37.469100952 AS Decimal(12, 9)), CAST(126.450996399 AS Decimal(12, 9)), 23, 9, 'Asia/Seoul'),
	(1950, 'Glacier Park International Airport', 'Kalispell', 'United States', 'FCA', 'KGPI', CAST(48.310501099 AS Decimal(12, 9)), CAST(-114.255996704 AS Decimal(12, 9)), 2977, -7, 'America/Denver'),
	(1951, 'The Pas Airport', 'The Pas', 'Canada', 'YQD', 'CYQD', CAST(53.971401215 AS Decimal(12, 9)), CAST(-101.091003418 AS Decimal(12, 9)), 887, -6, 'America/Winnipeg'),
	(1952, 'Hintonn/Jasper-Hintonn Airport', 'Hinton', 'Canada', 'YJP', 'CEC4', CAST(53.319198608 AS Decimal(12, 9)), CAST(-117.752998352 AS Decimal(12, 9)), 4006, -7, '')
Go
Set Identity_Insert Airports Off
Go

Insert Into Airlines
	(AirlineCode, Name)
Values
	('ACA', 'Air Canada "Air Canada" (Canada)'),
	('AK' , 'Alkan Air "Alkan Air" (Canada)'),
	('AKT', 'Canadian North "Arctic" (Canada)'),
	('ANT', 'Air North Charter "Air North" (Canada)'),
	('ASP', 'AirSprint (Canada)'),
	('CAV', 'Calm Air "Calm Air" (Canada)'),
	('CWA', 'CanWestAir "Can West" (Canada)'),
	('GLR', 'Central Mountain "Glacier" (Canada)'),
	('PCO', 'Pacific Coastal Airlines "Pasco" (Canada)'),
	('PVL', 'PAL Airlines "Provincial" (St. Johns/NL)'),
	('SWG', 'Sunwing "Sunwing" (Canada)'),
	('TI' , 'Air Tindi "Tindi" (Canada)'),
	('VAL', 'Voyageur Airways "Voyageur" (Canada)'),
	('WJA', 'WestJet "WestJet" (Calgary/Alberta)'),
	('WSW', 'Swoop "Swoop" (Calgary/Alberta)')
Go
Insert Into Payments
	(PaymentConfirmationNumber, Timestamp, Amount, PaymentType)
Values
	('0e57cf94-92f6-4379-96bb-8d5a193ccf45', Cast('2022-09-09T00:00:00' as DateTime), 18401.00, 'PayPal'),
	('19d2303f-d8af-448a-bb44-9758d23aa8b4', Cast('2022-09-04T00:00:00' as DateTime), 8402.00, 'PayPal'),
	('1fe34798-ce17-4099-a269-3da1d892f62d', Cast('2022-09-20T00:00:00' as DateTime), 38403.00, 'CREDIT'),
	('205ee30e-b48a-4d7d-847d-2398c475df51', Cast('2022-08-14T00:00:00' as DateTime), 8404.00, 'PayPal'),
	('229c4531-bd57-4694-8bca-4b3a496e8e45', Cast('2022-09-17T00:00:00' as DateTime), 88405.00, 'Bitcoin'),
	('26636673-703e-41fc-ae73-5537c27aae8f', Cast('2022-09-22T00:00:00' as DateTime), 8406.00, 'CREDIT'),
	('2c18bc3c-69df-4cd8-bcfe-4b38cca62212', Cast('2022-08-27T00:00:00' as DateTime), 8407.00, 'CREDIT'),
	('37802429-4832-4c6b-9236-eb9b5fba924c', Cast('2022-09-18T00:00:00' as DateTime), 48408.00, 'CREDIT'),
	('5158e8ac-3273-495e-8f4c-b63a2f6d95fa', Cast('2022-08-19T00:00:00' as DateTime), 9840.00, 'Bitcoin'),
	('56411fd2-6f1b-493e-b8da-3dbd01d4ab34', Cast('2022-08-09T00:00:00' as DateTime), 11840.00, 'Bitcoin'),
	('5cac5fc5-990d-466b-b2bb-f537098a607d', Cast('2022-08-13T00:00:00' as DateTime), 3840.00, 'Bitcoin'),
	('5dd7f356-987c-425d-afed-76e19875cca7', Cast('2022-09-21T00:00:00' as DateTime), 87540.00, 'Bitcoin'),
	('6b162c3b-6a21-49b2-92e8-e27d4f9cd07a', Cast('2022-09-16T00:00:00' as DateTime), 8480.00, 'Bitcoin'),
	('6c37e68c-ef04-47a3-b77a-c74f298cd2e9', Cast('2022-09-11T00:00:00' as DateTime), 82840.00, 'Bitcoin'),
	('6dcf8429-11d1-4151-ab8c-cc079d234fbf', Cast('2022-08-18T00:00:00' as DateTime), 8440.00, 'Bitcoin'),
	('75d53058-3e38-4463-ad88-c0d19e3ff1cb', Cast('2022-09-18T00:00:00' as DateTime), 84207.00, 'CREDIT'),
	('776a7b7f-f0b4-4f80-b3c5-50c3a597bc10', Cast('2022-08-05T00:00:00' as DateTime), 8840.00, 'CREDIT'),
	('781aa8bc-e4f0-4fad-b82c-f238c69ccb93', Cast('2022-09-19T00:00:00' as DateTime), 84740.00, 'Bitcoin'),
	('7b33b45a-f4d4-4096-a934-b96524818df9', Cast('2022-08-30T00:00:00' as DateTime), 8402.00, 'CREDIT'),
	('7c20e0ad-d9fb-4fd4-a424-a833b902d584', Cast('2022-09-18T00:00:00' as DateTime), 18940.00, 'PayPal'),
	('7d0e4b8f-d1c6-4a84-b8ba-269f1e555251', Cast('2022-08-05T00:00:00' as DateTime), 8140.00, 'CREDIT'),
	('83eb02f8-f2fb-4fcb-980f-5c1f4943b913', Cast('2022-08-12T00:00:00' as DateTime), 84050.00, 'Bitcoin'),
	('84a1b2a9-c0f4-4b7d-919e-7d02673f4de5', Cast('2022-08-25T00:00:00' as DateTime), 8740.00, 'Bitcoin'),
	('878178d9-6478-4523-a151-384794e60f65', Cast('2022-08-22T00:00:00' as DateTime), 89140.00, 'CREDIT'),
	('8fd1a861-33c8-47e5-bd67-170705743047', Cast('2022-09-17T00:00:00' as DateTime), 8040.00, 'Bitcoin'),
	('93a3028d-6e8b-43ae-9567-d78dc1343382', Cast('2022-09-19T00:00:00' as DateTime), 83340.00, 'Bitcoin'),
	('958842a9-4cb6-46a8-b77d-d2ad3c60fa33', Cast('2022-08-07T00:00:00' as DateTime), 8340.00, 'PayPal'),
	('97c0bb36-9b7d-4fd1-8d16-48ab9c01afbb', Cast('2022-09-22T00:00:00' as DateTime), 8470.00, 'CREDIT'),
	('98afca08-4d31-4053-a321-e4ba26923392', Cast('2022-08-01T00:00:00' as DateTime), 840.00, 'CREDIT'),
	('99bd0fd8-8487-4d0c-8fee-387c6d7e43e5', Cast('2022-08-12T00:00:00' as DateTime), 84805.00, 'Bitcoin'),
	('9d287f2a-817b-423f-b3ae-cd05d59891e5', Cast('2022-08-02T00:00:00' as DateTime), 8406.00, 'PayPal'),
	('ad37c8d9-a2d8-4ed9-a552-f24e298145a8', Cast('2022-08-15T00:00:00' as DateTime), 84308.00, 'CREDIT'),
	('aebaf8da-d74a-4eb4-a513-11c4b2e6e44a', Cast('2022-09-14T00:00:00' as DateTime), 8401.00, 'Bitcoin'),
	('afa3d54e-e11e-423b-9b71-f5316b2e7c7d', Cast('2022-09-09T00:00:00' as DateTime), 18740.00, 'PayPal'),
	('bb134ee2-e82c-42ab-bf7d-48bdf26ca983', Cast('2022-08-08T00:00:00' as DateTime), 2840.00, 'Bitcoin'),
	('bd2e9ae2-e0b9-404a-a338-d00f10fc37a3', Cast('2022-08-07T00:00:00' as DateTime), 38540.00, 'PayPal'),
	('bfa9f89d-7014-4498-9757-03f455b3d085', Cast('2022-08-24T00:00:00' as DateTime), 4840.00, 'Bitcoin'),
	('c06507b2-80a6-4941-8ae7-a2f88d843c48', Cast('2022-08-29T00:00:00' as DateTime), 58480.00, 'CREDIT'),
	('c380cd57-d703-47e4-adb6-1c64e21d495e', Cast('2022-09-28T00:00:00' as DateTime), 6840.00, 'Bitcoin'),
	('c5070d6a-290c-4d0d-bec6-ead009b4150d', Cast('2022-09-21T00:00:00' as DateTime), 7840.00, 'CREDIT'),
	('c893991e-b000-4cc1-b040-bf2d344c235f', Cast('2022-08-16T00:00:00' as DateTime), 88540.00, 'PayPal'),
	('cce74171-091c-4bac-9887-d93694bcc2b5', Cast('2022-09-04T00:00:00' as DateTime), 9840.00, 'PayPal'),
	('d10c171c-58b1-40d7-a565-547ece88617e', Cast('2022-09-10T00:00:00' as DateTime), 81440.00, 'CREDIT'),
	('dcda475b-10e1-421c-8419-dddb1bea9196', Cast('2022-08-20T00:00:00' as DateTime), 8430.00, 'PayPal'),
	('de132d76-d7c8-4fb9-a360-22bd1166a2de', Cast('2022-09-14T00:00:00' as DateTime), 84260.00, 'PayPal'),
	('e38862ce-8126-48c0-a130-72a214e528af', Cast('2022-08-17T00:00:00' as DateTime), 8480.00, 'CREDIT'),
	('e74ac951-7130-42dd-a2d2-d64d900b3b1f', Cast('2022-09-24T00:00:00' as DateTime), 82140.00, 'PayPal'),
	('ecbc74cc-143b-4998-bca2-9d8ef0a4c363', Cast('2022-08-31T00:00:00' as DateTime), 8460.00, 'Bitcoin'),
	('f18f3a22-38d8-4230-95a4-19a2a2970deb', Cast('2022-09-07T00:00:00' as DateTime), 84101.00, 'Bitcoin'),
	('f3ad81d0-5bf5-4205-8586-13430116c87c', Cast('2022-08-26T00:00:00' as DateTime), 8410.00, 'PayPal')
Go

Insert Into Flights
	(FlightCode, FlightNumber, Date, DepartureAirport, Departure, ArrivalAirport, Arrival, FlightDuration, Cancelled, IsFull, AirlineCode)
Values
	('ACA1072-24DEC-1953', 'ACA1072',  Cast('2022-12-24' as Date), 1943, Cast('19:53:00' as Time), 1899, Cast('2022-12-25T00:59:00' as DateTime),  Cast('03:06:00' as Time), 'N', 'N', 'ACA'),
	('ACA120-15DEC-1629', 'ACA120',  Cast('2022-12-15' as Date), 1028, Cast('16:29:00' as Time), 1171, Cast('2022-12-15T23:22:00' as DateTime),  Cast('03:53:00' as Time), 'N', 'N', 'ACA'),
	('ACA1208-24DEC-2116', 'ACA1208',  Cast('2022-12-24' as Date), 1899, Cast('21:16:00' as Time), 1936, Cast('2022-12-25T00:20:00' as DateTime),  Cast('03:04:00' as Time), 'N', 'N', 'ACA'),
	('ACA122-24DEC-1733', 'ACA122',  Cast('2022-12-24' as Date), 1134, Cast('17:33:00' as Time), 1171, Cast('2022-12-25T00:30:00' as DateTime),  Cast('03:57:00' as Time), 'N', 'N', 'ACA'),
	('ACA155-22DEC-2043', 'ACA155',  Cast('2022-12-22' as Date), 1171, Cast('20:43:00' as Time), 1156, Cast('2022-12-22T22:11:00' as DateTime),  Cast('03:28:00' as Time), 'N', 'N', 'ACA'),
	('ACA175-15DEC-1940', 'ACA175',  Cast('2022-12-15' as Date), 1171, Cast('19:40:00' as Time), 1028, Cast('2022-12-15T21:18:00' as DateTime),  Cast('03:38:00' as Time), 'N', 'N', 'ACA'),
	('ACA21-24DEC-1703', 'ACA21',  Cast('2022-12-24' as Date), 1171, Cast('17:03:00' as Time), 1929, Cast('2022-12-25T19:39:00' as DateTime),  Cast('13:36:00' as Time), 'N', 'N', 'ACA'),
	('ACA268-22DEC-1955', 'ACA268',  Cast('2022-12-22' as Date), 1138, Cast('19:55:00' as Time), 1171, Cast('2022-12-22T22:55:00' as DateTime),  Cast('02:00:00' as Time), 'N', 'N', 'ACA'),
	('ACA3-24DEC-1412', 'ACA3',  Cast('2022-12-24' as Date), 1134, Cast('14:12:00' as Time), 1929, Cast('2022-12-25T15:40:00' as DateTime),  Cast('09:28:00' as Time), 'N', 'N', 'ACA'),
	('ACA427-24DEC-2140', 'ACA427',  Cast('2022-12-24' as Date), 1899, Cast('21:40:00' as Time), 1171, Cast('2022-12-24T22:38:00' as DateTime),  Cast('00:58:00' as Time), 'N', 'N', 'ACA'),
	('ACA428-24DEC-2214', 'ACA428',  Cast('2022-12-24' as Date), 1171, Cast('22:14:00' as Time), 1899, Cast('2022-12-24T23:05:00' as DateTime),  Cast('00:51:00' as Time), 'N', 'N', 'ACA'),
	('ACA466-24DEC-2149', 'ACA466',  Cast('2022-12-24' as Date), 1171, Cast('21:49:00' as Time), 1896, Cast('2022-12-24T22:25:00' as DateTime),  Cast('00:36:00' as Time), 'N', 'N', 'ACA'),
	('ACA527-24DEC-1914', 'ACA527',  Cast('2022-12-24' as Date), 1899, Cast('19:14:00' as Time), 1942, Cast('2022-12-24T21:17:00' as DateTime),  Cast('05:03:00' as Time), 'N', 'N', 'ACA'),
	('ACA557-26DEC-1737', 'ACA557',  Cast('2022-12-26' as Date), 1533, Cast('17:37:00' as Time), 1903, Cast('2022-12-26T19:52:00' as DateTime),  Cast('02:15:00' as Time), 'N', 'N', 'ACA'),
	('ACA562-24DEC-1742', 'ACA562',  Cast('2022-12-24' as Date), 1134, Cast('17:42:00' as Time), 1933, Cast('2022-12-24T19:23:00' as DateTime),  Cast('01:41:00' as Time), 'N', 'N', 'ACA'),
	('ACA61-24DEC-1652', 'ACA61',  Cast('2022-12-24' as Date), 1171, Cast('16:52:00' as Time), 1949, Cast('2022-12-25T22:49:00' as DateTime),  Cast('16:57:00' as Time), 'N', 'N', 'ACA'),
	('ACA72-24DEC-2008', 'ACA72',  Cast('2022-12-24' as Date), 1899, Cast('20:08:00' as Time), 1915, Cast('2022-12-25T07:37:00' as DateTime),  Cast('06:29:00' as Time), 'N', 'N', 'ACA'),
	('ACA820-24DEC-2103', 'ACA820',  Cast('2022-12-24' as Date), 1171, Cast('21:03:00' as Time), 1916, Cast('2022-12-25T10:26:00' as DateTime),  Cast('07:23:00' as Time), 'N', 'N', 'ACA'),
	('ACA832-24DEC-1917', 'ACA832',  Cast('2022-12-24' as Date), 1899, Cast('19:17:00' as Time), 1910, Cast('2022-12-25T07:26:00' as DateTime),  Cast('06:09:00' as Time), 'N', 'N', 'ACA'),
	('ACA844-24DEC-2157', 'ACA844',  Cast('2022-12-24' as Date), 1899, Cast('21:57:00' as Time), 1911, Cast('2022-12-25T10:34:00' as DateTime),  Cast('06:37:00' as Time), 'N', 'N', 'ACA'),
	('ACA850-24DEC-1921', 'ACA850',  Cast('2022-12-24' as Date), 1156, Cast('19:21:00' as Time), 1913, Cast('2022-12-25T10:02:00' as DateTime),  Cast('02:41:00' as Time), 'N', 'N', 'ACA'),
	('ACA864-24DEC-2120', 'ACA864',  Cast('2022-12-24' as Date), 1899, Cast('21:20:00' as Time), 1913, Cast('2022-12-25T08:03:00' as DateTime),  Cast('00:43:00' as Time), 'N', 'N', 'ACA'),
	('ACA874-24DEC-2104', 'ACA874',  Cast('2022-12-24' as Date), 1899, Cast('21:04:00' as Time), 1918, Cast('2022-12-25T09:20:00' as DateTime),  Cast('06:16:00' as Time), 'N', 'N', 'ACA'),
	('ASP508-04DEC-1905', 'ASP508',  Cast('2022-12-04' as Date), 1138, Cast('19:05:00' as Time), 1156, Cast('2022-12-04T20:17:00' as DateTime),  Cast('02:12:00' as Time), 'N', 'N', 'ASP'),
	('ASP508-25DEC-1906', 'ASP508',  Cast('2022-12-25' as Date), 1903, Cast('19:06:00' as Time), 1156, Cast('2022-12-25T20:18:00' as DateTime),  Cast('02:12:00' as Time), 'N', 'N', 'ASP'),
	('ASP675-02DEC-1846', 'ASP675',  Cast('2022-12-02' as Date), 1906, Cast('18:46:00' as Time), 1156, Cast('2022-12-02T21:12:00' as DateTime),  Cast('01:26:00' as Time), 'N', 'N', 'ASP'),
	('SWG378-02DEC-1842', 'SWG378',  Cast('2022-12-02' as Date), 1899, Cast('18:42:00' as Time), 1927, Cast('2022-12-02T22:04:00' as DateTime),  Cast('04:22:00' as Time), 'N', 'N', 'SWG'),
	('SWG378-04DEC-1844', 'SWG378',  Cast('2022-12-04' as Date), 1899, Cast('18:44:00' as Time), 1927, Cast('2022-12-04T22:06:00' as DateTime),  Cast('04:22:00' as Time), 'N', 'N', 'SWG'),
	('SWG378-05DEC-1845', 'SWG378',  Cast('2022-12-05' as Date), 1899, Cast('18:45:00' as Time), 1927, Cast('2022-12-05T22:07:00' as DateTime),  Cast('04:22:00' as Time), 'N', 'N', 'SWG'),
	('SWG379-02DEC-2149', 'SWG379',  Cast('2022-12-02' as Date), 1927, Cast('21:49:00' as Time), 1899, Cast('2022-12-03T00:55:00' as DateTime),  Cast('02:06:00' as Time), 'N', 'N', 'SWG'),
	('SWG379-03DEC-2150', 'SWG379',  Cast('2022-12-03' as Date), 1927, Cast('21:50:00' as Time), 1899, Cast('2022-12-04T00:56:00' as DateTime),  Cast('02:06:00' as Time), 'N', 'N', 'SWG'),
	('SWG447-01DEC-2205', 'SWG447',  Cast('2022-12-01' as Date), 1922, Cast('22:05:00' as Time), 1897, Cast('2022-12-02T02:21:00' as DateTime),  Cast('11:16:00' as Time), 'N', 'N', 'SWG'),
	('SWG447-02DEC-2207', 'SWG447',  Cast('2022-12-02' as Date), 1922, Cast('22:07:00' as Time), 1897, Cast('2022-12-03T02:23:00' as DateTime),  Cast('11:16:00' as Time), 'N', 'N', 'SWG'),
	('SWG447-03DEC-2208', 'SWG447',  Cast('2022-12-03' as Date), 1922, Cast('22:08:00' as Time), 1897, Cast('2022-12-04T02:24:00' as DateTime),  Cast('11:16:00' as Time), 'N', 'N', 'SWG'),
	('SWG447-04DEC-2209', 'SWG447',  Cast('2022-12-04' as Date), 1922, Cast('22:09:00' as Time), 1897, Cast('2022-12-05T02:25:00' as DateTime),  Cast('11:16:00' as Time), 'N', 'N', 'SWG'),
	('SWG447-05DEC-2210', 'SWG447',  Cast('2022-12-05' as Date), 1922, Cast('22:10:00' as Time), 1897, Cast('2022-12-06T02:26:00' as DateTime),  Cast('11:16:00' as Time), 'N', 'N', 'SWG'),
	('SWG675-02DEC-1848', 'SWG675',  Cast('2022-12-02' as Date), 1927, Cast('18:48:00' as Time), 1134, Cast('2022-12-02T21:46:00' as DateTime),  Cast('04:58:00' as Time), 'N', 'N', 'SWG'),
	('SWG725-31DEC-1557', 'SWG725',  Cast('2022-12-31' as Date), 1925, Cast('15:57:00' as Time), 1171, Cast('2022-12-31T22:47:00' as DateTime),  Cast('04:50:00' as Time), 'N', 'N', 'SWG'),
	('SWG725-02DEC-1559', 'SWG725',  Cast('2022-12-02' as Date), 1925, Cast('15:59:00' as Time), 1171, Cast('2022-12-02T22:49:00' as DateTime),  Cast('04:50:00' as Time), 'N', 'N', 'SWG'),
	('SWG725-25DEC-1602', 'SWG725',  Cast('2022-12-25' as Date), 1925, Cast('16:02:00' as Time), 1171, Cast('2022-12-25T22:52:00' as DateTime),  Cast('04:50:00' as Time), 'N', 'N', 'SWG'),
	('SWG803-05DEC-2104', 'SWG803',  Cast('2022-12-05' as Date), 1171, Cast('21:04:00' as Time), 1134, Cast('2022-12-05T22:25:00' as DateTime),  Cast('04:21:00' as Time), 'N', 'N', 'SWG')
Go

Insert Into Bookings
	(ConfirmationNumber, FlightCode, PaymentConfirmationNumber, FirstName, MiddleName, LastName, PhoneNumber, AlternatePhoneNumber, EmailAddress, StreetAddress, City, Region, Country, PassengerCount)
Values
	('D74A-4EB4-A', 'SWG379-03DEC-2150', 'aebaf8da-d74a-4eb4-a513-11c4b2e6e44a', 'Bhaskar', '', 'Vaasse', '1-780-758-7398', Null, 'B.Vaassen@zmail.co', '2508 50 Street NW', 'Varadero', Null, 'Cuba', 0),
	('987C-425D-A', 'ASP675-02DEC-1846', '5dd7f356-987c-425d-afed-76e19875cca7', 'Kimo', '', 'Zema', '1-639-782-3569', Null, 'K.Zema@zmail.co', '1179 Summerside Drive SW', 'Victoria', Null, 'Canada', 0),
	('3273-495E-8', 'ACA175-15DEC-1940', '5158e8ac-3273-495e-8f4c-b63a2f6d95fa', 'Loraine', '', 'Stranger', '1-474-590-7006', Null, 'L.Stranger@zmail.co', '4225 Mcmullen Place SW', 'Kalispell', Null, 'United States', 0),
	('B48A-4D7D-8', 'SWG447-05DEC-2210', '205ee30e-b48a-4d7d-847d-2398c475df51', 'Daryl', '', 'Lineweaver', '1-368-754-7283', Null, 'D.Lineweaver@zmail.co', '4505 211a Street NW', 'Punta Cana', Null, 'Dominican Republic', 0),
	('11D1-4151-A', 'ACA1208-24DEC-2116', '6dcf8429-11d1-4151-ab8c-cc079d234fbf', 'Kathary', '', 'Nittler', '1-780-986-1704', Null, 'K.Nittler@zmail.co', '13004 39 Street NW', 'Kalispell', Null, 'United States', 0),
	('D9FB-4FD4-A', 'ACA832-24DEC-1917', '7c20e0ad-d9fb-4fd4-a424-a833b902d584', 'Cleisthenes', '', 'Minggia', '1-368-758-6839', Null, 'C.Minggia@zmail.co', '3824 47 Street NW', 'Kalispell', Null, 'United States', 0),
	('E11E-423B-9', 'ACA844-24DEC-2157', 'afa3d54e-e11e-423b-9b71-f5316b2e7c7d', 'Sad', '', 'Oriel', '1-403-594-8806', Null, 'S.Oriel@zmail.co', '11410 166 Avenue NW', 'Kalispell', Null, 'United States', 0),
	('8126-48C0-A', 'ASP508-25DEC-1906', 'e38862ce-8126-48c0-a130-72a214e528af', 'Alexius', '', 'Ansari', '1-474-984-9906', Null, 'A.Ansari@zmail.co', '8008 Shaske Drive NW', 'Winnipeg', Null, 'Canada', 0),
	('38D8-4230-9', 'SWG803-05DEC-2104', 'f18f3a22-38d8-4230-95a4-19a2a2970deb', 'Jeane', '', 'Marzetti', '1-825-759-3415', Null, 'J.Marzetti@zmail.co', '11123 70 Avenue NW', 'Toronto', Null, 'Canada', 0),
	('EF04-47A3-B', 'ACA864-24DEC-2120', '6c37e68c-ef04-47a3-b77a-c74f298cd2e9', 'Janet', '', 'Voccola', '1-825-408-6430', Null, 'J.Voccola@zmail.co', '10648 67 Avenue NW', 'Kalispell', Null, 'United States', 0),
	('3E38-4463-A', 'ACA21-24DEC-1703', '75d53058-3e38-4463-ad88-c0d19e3ff1cb', 'Sonny', '', 'Mincks', '1-474-400-7691', Null, 'S.Mincks@zmail.co', '16116 43 Street NW', 'Kalispell', Null, 'United States', 2),
	('6478-4523-A', 'SWG675-02DEC-1848', '878178d9-6478-4523-a151-384794e60f65', 'Venceslav', '', 'Corkill', '1-780-402-5812', Null, 'V.Corkill@zmail.co', ' ', 'Varadero', Null, 'Cuba', 0),
	('BD57-4694-8', 'SWG725-02DEC-1559', '229c4531-bd57-4694-8bca-4b3a496e8e45', 'Eilís', '', 'Dender', '1-639-778-8845', Null, 'E.Dender@zmail.co', '9730 106 Street NW', 'Liberia', Null, 'Costa Rica', 0),
	('6E8B-43AE-9', 'ACA428-24DEC-2214', '93a3028d-6e8b-43ae-9567-d78dc1343382', 'Maile', '', 'Ex', '1-403-410-7481', Null, 'M.Ex@zmail.co', '10731 156 Street NW', 'Kalispell', Null, 'United States', 0),
	('C0F4-4B7D-9', 'ASP508-04DEC-1905', '84a1b2a9-c0f4-4b7d-919e-7d02673f4de5', 'Rahim', '', 'Gandia', '1-639-557-3177', Null, 'R.Gandia@zmail.co', '772 Abbottsfield Road NW', 'Winnipeg', Null, 'Canada', 0),
	('D703-47E4-A', 'SWG378-05DEC-1845', 'c380cd57-d703-47e4-adb6-1c64e21d495e', 'Paulo', '', 'Marcil', '1-825-920-6515', Null, 'P.Marcil@zmail.co', '12841 65 Street NW', 'Montreal', Null, 'Canada', 0),
	('6A21-49B2-9', 'ACA427-24DEC-2140', '6b162c3b-6a21-49b2-92e8-e27d4f9cd07a', 'Nkechi', '', 'Delaroca', '1-403-989-4524', Null, 'N.Delaroca@zmail.co', '7511 36a Avenue NW', 'Kalispell', Null, 'United States', 0),
	('E4F0-4FAD-B', 'ACA850-24DEC-1921', '781aa8bc-e4f0-4fad-b82c-f238c69ccb93', 'Audrie', '', 'Shoup', '1-403-930-5333', Null, 'A.Shoup@zmail.co', ' ', 'Kalispell', Null, 'United States', 0),
	('4CB6-46A8-B', 'ACA3-24DEC-1412', '958842a9-4cb6-46a8-b77d-d2ad3c60fa33', 'Anan (2)', '', 'Pizzano', '1-780-490-1519', Null, 'A.Pizzano@zmail.co', '801 Bothwell DR', 'Kalispell', Null, 'United States', 0),
	('F0B4-4F80-B', 'ASP508-25DEC-1906', '776a7b7f-f0b4-4f80-b3c5-50c3a597bc10', 'Antonia', '', 'Unthank', '1-474-710-1272', Null, 'A.Unthank@zmail.co', '105 Great Oaks', 'Winnipeg', Null, 'Canada', 0),
	('091C-4BAC-9', 'ACA1072-24DEC-1953', 'cce74171-091c-4bac-9887-d93694bcc2b5', 'Uschi', '', 'Gottsacker', '1-474-446-3656', Null, 'U.Gottsacker@zmail.co', '17208 126 Street NW', 'Kalispell', Null, 'United States', 0),
	('7130-42DD-A', 'ACA466-24DEC-2149', 'e74ac951-7130-42dd-a2d2-d64d900b3b1f', 'Augusti', '', 'Forkell', '1-236-454-2936', Null, 'A.Forkell@zmail.co', '10423 20 Avenue NW', 'Kalispell', Null, 'United States', 0),
	('817B-423F-B', 'ACA527-24DEC-1914', '9d287f2a-817b-423f-b3ae-cd05d59891e5', 'Kaitly', '', 'Paparone', '1-474-590-5100', Null, 'K.Paparone@zmail.co', '7607 172 Street NW', 'Kalispell', Null, 'United States', 0),
	('E82C-42AB-B', 'SWG378-02DEC-1842', 'bb134ee2-e82c-42ab-bf7d-48bdf26ca983', 'Isis', '', 'Crivellone', '1-368-408-1394', Null, 'I.Crivellone@zmail.co', '1720 Garnett Point NW', 'Montreal', Null, 'Canada', 0),
	('10E1-421C-8', 'ACA120-15DEC-1629', 'dcda475b-10e1-421c-8419-dddb1bea9196', 'Shehrevar', '', 'Zulic', '1-639-778-9346', Null, 'S.Zulic@zmail.co', '373 53431 Rng RD 221 Rng RD', 'Kalispell', Null, 'United States', 3),
	('CE17-4099-A', 'SWG447-01DEC-2205', '1fe34798-ce17-4099-a269-3da1d892f62d', 'Zhe', '', 'Givler', '1-825-416-8917', Null, 'Z.Givler@zmail.co', '4377 38 Street NW', 'Punta Cana', Null, 'Dominican Republic', 0),
	('990D-466B-B', 'ACA562-24DEC-1742', '5cac5fc5-990d-466b-b2bb-f537098a607d', 'Ursula', '', 'Dellea', '1-403-756-1861', Null, 'U.Dellea@zmail.co', '9651 70 Avenue NW', 'Kalispell', Null, 'United States', 0),
	('A2D8-4ED9-A', 'ACA61-24DEC-1652', 'ad37c8d9-a2d8-4ed9-a552-f24e298145a8', 'Chrysanta', '', 'Adesina', '1-587-929-1143', Null, 'C.Adesina@zmail.co', '8520 18 Avenue SW', 'Kalispell', Null, 'United States', 0),
	('92F6-4379-9', 'ACA557-26DEC-1737', '0e57cf94-92f6-4379-96bb-8d5a193ccf45', 'Ananda', '', 'Mecias', '1-780-924-2415', Null, 'A.Mecias@zmail.co', '1382 Cunningham Drive SW', 'Kalispell', Null, 'United States', 0),
	('4D31-4053-A', 'ACA3-24DEC-1412', '98afca08-4d31-4053-a321-e4ba26923392', 'Nettie', '', 'Elkinto', '1-825-410-8855', Null, 'N.Elkinton@zmail.co', '10741 93 Street NW', 'Kalispell', Null, 'United States', 0),
	('9B7D-4FD1-8', 'SWG803-05DEC-2104', '97c0bb36-9b7d-4fd1-8d16-48ab9c01afbb', 'Karp', '', 'Lenzmeier', '1-825-598-2351', Null, 'K.Lenzmeier@zmail.co', '1510 Watt Drive SW', 'Toronto', Null, 'Canada', 0),
	('143B-4998-B', 'ACA122-24DEC-1733', 'ecbc74cc-143b-4998-bca2-9d8ef0a4c363', 'Terrell', '', 'Bussone', '1-825-990-6011', Null, 'T.Bussone@zmail.co', '9931 88 Avenue NW', 'Kalispell', Null, 'United States', 0),
	('6F1B-493E-B', 'SWG447-04DEC-2209', '56411fd2-6f1b-493e-b8da-3dbd01d4ab34', 'Phineas', '', 'Tannler', '1-474-401-8333', Null, 'P.Tannler@zmail.co', '10345 159 Street NW', 'Punta Cana', Null, 'Dominican Republic', 0),
	('8487-4D0C-8', 'SWG447-05DEC-2210', '99bd0fd8-8487-4d0c-8fee-387c6d7e43e5', 'Becky', '', 'Chiaradio', '1-825-459-3944', Null, 'B.Chiaradio@zmail.co', '12904 Hudson Way NW', 'Punta Cana', Null, 'Dominican Republic', 0),
	('290C-4D0D-B', 'ACA155-22DEC-2043', 'c5070d6a-290c-4d0d-bec6-ead009b4150d', 'Babar', '', 'Polatsek', '1-474-938-6247', Null, 'B.Polatsek@zmail.co', '3710 Allan Drive SW', 'Kalispell', Null, 'United States', 1),
	('5BF5-4205-8', 'SWG725-25DEC-1602', 'f3ad81d0-5bf5-4205-8586-13430116c87c', 'Kleme', '', 'Roofner', '1-639-523-7751', Null, 'K.Roofner@zmail.co', '1905 Lemieux Court NW', 'Liberia', Null, 'Costa Rica', 0),
	('80A6-4941-8', 'ACA527-24DEC-1914', 'c06507b2-80a6-4941-8ae7-a2f88d843c48', 'Loga', '', 'Fites', '1-780-401-5760', Null, 'L.Fites@zmail.co', '10545 Saskatchewan Drive NW', 'Kalispell', Null, 'United States', 0),
	('703E-41FC-A', 'SWG447-02DEC-2207', '26636673-703e-41fc-ae73-5537c27aae8f', 'Hayder', '', 'Letto', '1-403-459-3421', Null, 'H.Letton@zmail.co', '14105 80 Street NW', 'Punta Cana', Null, 'Dominican Republic', 0),
	('69DF-4CD8-B', 'SWG447-03DEC-2208', '2c18bc3c-69df-4cd8-bcfe-4b38cca62212', 'Jabbar', '', 'Greenstone', '1-403-983-3856', Null, 'J.Greenstone@zmail.co', '9440 Scona Road NW', 'Punta Cana', Null, 'Dominican Republic', 0),
	('B000-4CC1-B', 'ACA72-24DEC-2008', 'c893991e-b000-4cc1-b040-bf2d344c235f', 'Yarde', '', 'Kienbaum', '1-236-458-8704', Null, 'Y.Kienbaum@zmail.co', '7816 106 Avenue NW', 'Kalispell', Null, 'United States', 0),
	('D8AF-448A-B', 'ACA820-24DEC-2103', '19d2303f-d8af-448a-bb44-9758d23aa8b4', 'Brynne', '', 'Richardt', '1-639-879-6907', Null, 'B.Richardt@zmail.co', '10604 107 Street NW', 'Kalispell', Null, 'United States', 0),
	('D7C8-4FB9-A', 'SWG378-04DEC-1844', 'de132d76-d7c8-4fb9-a360-22bd1166a2de', 'Manoel', '', 'Valinoti', '1-825-357-8653', Null, 'M.Valinoti@zmail.co', '10345 118 Street NW', 'Montreal', Null, 'Canada', 0),
	('E0B9-404A-A', 'ACA844-24DEC-2157', 'bd2e9ae2-e0b9-404a-a338-d00f10fc37a3', 'Bobbie', '', 'Seixas', '1-368-346-1703', Null, 'B.Seixas@zmail.co', '4448 33a Avenue NW', 'Kalispell', Null, 'United States', 0),
	('7014-4498-9', 'SWG725-31DEC-1557', 'bfa9f89d-7014-4498-9757-03f455b3d085', 'Ted', '', 'Eckardt', '1-587-930-5279', Null, 'T.Eckardt@zmail.co', '76 Kiniski Crescent NW', 'Liberia', Null, 'Costa Rica', 0),
	('4832-4C6B-9', 'ACA268-22DEC-1955', '37802429-4832-4c6b-9236-eb9b5fba924c', 'Sea', '', 'Ostos', '1-587-599-7289', Null, 'S.Ostos@zmail.co', '104 Lorelei Close NW', 'Kalispell', Null, 'United States', 0),
	('33C8-47E5-B', 'SWG447-01DEC-2205', '8fd1a861-33c8-47e5-bd67-170705743047', 'Diederick', '', 'Kernick', '1-639-930-9411', Null, 'D.Kernick@zmail.co', '11 Deacon DR', 'Punta Cana', Null, 'Dominican Republic', 0),
	('D1C6-4A84-B', 'ASP508-25DEC-1906', '7d0e4b8f-d1c6-4a84-b8ba-269f1e555251', 'Karrie', '', 'Munli', '1-403-525-6026', Null, 'K.Munlin@zmail.co', '16212 92 Street NW', 'Winnipeg', Null, 'Canada', 0),
	('F2FB-4FCB-9', 'SWG447-01DEC-2205', '83eb02f8-f2fb-4fcb-980f-5c1f4943b913', 'Dorethea', '', 'Karikari', '1-780-937-5575', Null, 'D.Karikari@zmail.co', '5828 175 Avenue NW', 'Punta Cana', Null, 'Dominican Republic', 0),
	('58B1-40D7-A', 'SWG379-02DEC-2149', 'd10c171c-58b1-40d7-a565-547ece88617e', 'Raelene', '', 'Bremseth', '1-825-855-9381', Null, 'R.Bremseth@zmail.co', ' ', 'Varadero', Null, 'Cuba', 0),
	('F4D4-4096-A', 'ACA874-24DEC-2104', '7b33b45a-f4d4-4096-a934-b96524818df9', 'Micheline', '', 'Casarella', '1-639-592-8802', Null, 'M.Casarella@zmail.co', '11619 69 Street NW', 'Kalispell', Null, 'United States', 4)
Go

Insert Into Passengers
	(ConfirmationNumber, CustomerId, FirstName, MiddleName, LastName, PhoneNumber, DateOfBirth)
Values
	('290C-4D0D-B', 1, 'Jolee', '', 'Niemela', '1-587-881-5936', 'Jun 8, 1996'),        
	('3E38-4463-A', 1, 'Indigo', 'Thadeus', 'Tharp', '1-474-337-7977', 'April 1, 1966'),
	('3E38-4463-A', 2, 'Mary', '', 'Tharp', NULL, 'Feb 28, 1970'),
	('10E1-421C-8', 1, 'Gautam', '', 'Vankleek', '1-587-710-6652', 'Feb 28, 2000'),
	('10E1-421C-8', 2, 'Del', '', 'Vankleek', NULL,'Aug 2, 2010'),
	('10E1-421C-8', 3, 'Corvina', '', 'Vankleek', NULL,'Mar 13, 2000'),
	('F4D4-4096-A', 1, 'Falk', '', 'Ell', '1-236-407-1742','Jan 31, 1985'),
	('F4D4-4096-A', 2, 'Miles', '', 'Ell', NULL,'Nov 5, 1980'),
	('F4D4-4096-A', 3, 'Howard', '', 'Ell', NULL,'Dec 7, 1952'),
	('F4D4-4096-A', 4, 'Colton', '', 'Ell', NULL,'May 19, 1982')		
Go

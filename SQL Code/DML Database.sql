drop table tracks
drop table album

Create Table Album
(
AlbumID int identity (1,1) not null constraint pk_album primary key  clustered,
Title varchar (100) not null,
Rating char(1) not null 
constraint ck_ratingrange check(Rating between 0 and 5)
constraint df_0rating default 0,
Artist varchar (100) null,
SuggestedPrice smallmoney null
)

Create Table Tracks
(
TrackID tinyint not null,
AlbumID int not null 
constraint fk_TracksToAlbum references Album(AlbumID),
Title varchar (50) not null,
Length tinyint null,
constraint pk_Tracks primary key clustered (TrackID, AlbumID)
)

--INSERT
Insert into Album
values(1, 'Greatest Hits', '5', 'ABBA', 10)
--fails. you cannot insert a value into an identity field, which is AlbumID in this case
--ignore the identity field in your inserts
Insert into Album
values('Greatest Hits', '5', 'ABBA', 10)
--above code works BUT, never do it this way

--This way is much better
--Always list the columns
Insert into Album(title, rating, artist, SuggestedPrice)
values('Greatest Hits 2', '5', 'ABBA', 12)


Insert into Album(title, rating, artist, SuggestedPrice)
values('Greatest Hits 2', '5', 'ABBA')
--must have the same number of values as columns

Insert into Album(title, rating, artist)
values('Greatest Hits 2', '5', 'ABBA', 12)
--must have the same number of columns as values

--Nulls
-- you can put the word "null" in the nullable column
Insert into Album(title, rating, artist, SuggestedPrice)
values('Greatest Hits 2', '5', 'ABBA', null)
--OR you can omit the column and value
Insert into Album(title, rating, artist)
values('Greatest Hits 2', '5', 'ABBA')

--Default
--can use the keyword default
Insert into Album(title, rating, artist, SuggestedPrice)
values('Greatest Hits 2', default, 'ABBA', 12)
--OR you can omit the column and value
Insert into Album(title, artist, SuggestedPrice)
values('Greatest Hits 2', 'ABBA', 12)

--Subqueries
--Remember, you can use a subquery anywhere you need a value
--Add an album with the same price as the average price of all the other albums
Insert into Album(title, rating, artist, SuggestedPrice) values ('Greatest Hits 2', default, 'ABBA', (Select avg(SuggestedPrice) from Album ))

--Why does this fail
--because subquery returns more than one value
Insert into Album(title, rating, artist, SuggestedPrice) values ('Greatest Hits 2', default, 'ABBA', (Select SuggestedPrice from Album ))
--when a subquery is used as a value, it MUST return only one value
--you can use as many subqueries as you need

--insert a new album with the following
--Title the same as album 1, rating the same as the highest rating in the table, any artist you want, suggestedprice the same as the lowest price
Insert into Album(title, rating, artist, SuggestedPrice) values 
((Select title from album where AlbumID = 1),
(Select max(rating) from album),
'Michael Jackson',
(Select min(SuggestedPrice) from album))


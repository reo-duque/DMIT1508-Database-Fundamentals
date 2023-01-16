drop table Activity
drop table Grade
drop table Course
drop table Student
drop table Club

create table Student
(
	StudentId int not null
		constraint PK_Student primary key clustered,
	StudentFirstName varchar(40) not null,
	StudentLastName varchar(40) not null,
	GenderCode char(1) not null
		constraint CK_GenderCode Check(GenderCode like '[MFX]'),
	Address varchar(30) null,
	Birthdate datetime null,
	PostalCode char(6) null
		constraint CK_PostalCode Check(PostalCode like '[A-Z][0-9][A-Z][0-9][A-Z][0-9]'),
	AvgMark decimal(4,1) null 
		constraint CK_AvgMark Check(AvgMark between 0 and 100) ,
	NoOfCourses smallint null default 0
		constraint CK_NoOfCourses check(NoOfCourses >= 0),
)

create table Course
(
	CourseId char(6) not null
		constraint PK_Course primary key clustered,
	CourseName varchar(40) not null,
	Hours smallint null
		constraint CK_Hours Check(Hours > 0),
	NoOfStudents smallint null
		constraint CK_NoOfStudents Check(NoOfStudents >= 0)
)

create table Club
(
	ClubId int not null
		constraint PK_Club primary key clustered,
	ClubName varchar(50) not null
)

create table Grade
(
	StudentId int not null
		constraint FK_GradeToStudent references Student(StudentId),
	CourseId char(6) not null
		constraint FK_GradeToCourse references Course(CourseId),
	Mark smallint null default 0
		constraint CK_Mark Check(Mark between 0 and 100),
	constraint PK_Grade primary key clustered (StudentId,CourseId)
)

create table Activity
(
	StudentId int not null
		constraint FK_ActivityToStudent references Student(StudentId),
	ClubId int not null
		constraint FK_ActivityToClub references Club(ClubId),
	constraint PK_Activity primary key clustered (StudentId,ClubId)
)



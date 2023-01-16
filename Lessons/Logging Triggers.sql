--Logging Trigger
--Create a Trigger to add a record to a logging table whenever a coursecost is changed

Create Table CourseChanges
(
LogID int identity(1,1) not null constraint pk_CourseChanges primary key,
ChangeDateTime datetime not null constraint df_Date default getdate(),
OldCourseCost money not null,
NewCourseCost money not null,
CourseID char(7) not null
)
go

Alter Trigger TR_Course_Update
on Course
For Update
as
If @@RowCount > 0 and Update(CourseCost)
	Begin
	Insert into CourseChanges(OldCourseCost, NewCourseCost, CourseID)
	Select deleted.coursecost, inserted.coursecost, inserted.courseID from Inserted Inner Join Deleted on Inserted.CourseID = Deleted.CourseID where Inserted.CourseCost != Deleted.CourseCost
	End
Return
go

update course
Set CourseCost=460
update course
Set CourseCost = 1810 where CourseID = 'dmit101'

Select * from course
Select * from coursechanges
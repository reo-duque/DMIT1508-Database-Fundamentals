
drop table projectitem
drop table project
drop table item
drop table staff
drop table client
drop table itemtype
drop table projecttype
drop table stafftype
Create Table StaffType
( 
StaffTypeID int not null constraint pk_StaffType primary key clustered,
StaffTypeDescription varchar(50) not null
)

Create Table itemType
(
ItemTypeID int not null constraint pk_ItemType primary key clustered,
ItemTypeDescription varchar(50) not null
)

Create Table ProjectType
(
ProjectTypeCode int not null constraint pk_ProjectType primary key clustered,
ProjectTypeDescription varchar(50) not null
)

Create Table Client
(
ClientID integer identity(1,1) not null constraint pk_Client primary key clustered,
Organization varchar(50) not null,
ClientFirstName varchar(50) not null,
ClientLastName varchar(50) not null,
Phone varchar(10) not null,
Email varchar(50) not null,
Address varchar(100) not null,
City varchar(50) not null,
Province char(2) not null,
PC  char(6) not null,
)

Create Table Staff
(
StaffID int not null constraint pk_Staff primary key clustered,
StaffFirstName varchar(50) not null,
StaffLastName varchar(50) not null,
Phone varchar(10) not null,
Wage smallmoney not null 
constraint df_wage default 9.5
constraint ck_wage check(Wage >0),
HireDate datetime not null,
StaffTypeID int not null constraint fk_StaffToStaffType references StaffType(StaffTypeID),
constraint ck_hiredate check(HireDate >= getdate())
)

Create Table Item
(
ItemID integer identity (1,1)  not null constraint pk_Item primary key clustered,
ItemDescription varchar(100) not null,
PricePerDay money not null,
ItemTypeID int not null constraint fk_ItemToItemType references ItemType(ItemTypeID)
)

Create Table Project 
(
ProjectId int not null identity (1,1) constraint pk_Project primary key clustered,
ProjectDescription varchar(100) not null,
InDate datetime not null,
OutDate datetime not null,
Estimate money not null constraint df_Estimate default 0,
ProjectTypeCode int not null constraint fk_ProjectToProjectType references ProjectType(ProjectTypeCode),
ClientID int not null constraint fk_ProjectToClient references Client(ClientID),
SubTotal money not null,
GST money not null,
Total money not null,
StaffID int not null constraint fk_ProjectToStaff references Staff(StaffID),
constraint ck_dates check (InDate >=OutDate),
constraint ck_total check (Total > Subtotal)
)

Create Table ProjectItem
(
ItemID int not null constraint fk_ProjectItemToItem references Item(ItemID),
ProjectID int not null constraint fk_ProjectItemToProject references Project(ProjectID),
CheckInNotes varchar(200) not null,
CheckOutNotes varchar(200) not null,
DateOut datetime not null,
DateIn datetime not null,
ExtPrice money not null,
Historicalprice money not null,
Days smallint not null constraint ck_Days check (days>0),
Constraint pk_Projectitem Primary Key clustered (ItemID,ProjectID) ,
constraint ck_dateIn check (DateIn >= DateOut)
)

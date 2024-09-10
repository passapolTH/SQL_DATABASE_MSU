/*  drop table ******************************
drop table enroll
drop table section
drop table subject
drop table student
drop table lecturer

*/
--******** STUDENT
create table STUDENT(
	sid		varchar(10),
	name	varchar(50),
	major	varchar(20),
	GPA		numeric(3,2),
	birthday date,
constraint std_pk primary key(sid),
constraint std_gpa check (GPA between 0.0 and 4.0))

-- *********SUBJECT
create table SUBJECT(
	sid				varchar(10),
	name			varchar(30),
	credit			int,
	prerequisite	varchar(10),
constraint sub_pk primary key(sid),
constraint sub_fk_pre foreign key(prerequisite) references SUBJECT(sid),
constraint sub_check_name check (name is not null))

--**************LECTURER
create table LECTURER(
	lid		varchar(10),
	name	varchar(30),
	salary	int,
	major	varchar(30),
constraint lec_pk primary key(lid))

--***************SECTION

create table SECTION(
	secid	int identity(1,1),
	subid	varchar(10),
	lecid	varchar(10),
	term	varchar(6),
constraint sec_pk primary key(secid),
constraint sec_fk_sub foreign key(subid) references SUBJECT(sid) on delete cascade,
constraint sec_fk_lec foreign key(lecid) references LECTURER(lid) on delete cascade,
constraint sec_uk unique (subid, lecid, term))

-- **************ENROLL
	
create table ENROLL(
	secid	int,
	stdid	varchar(10),
	grade	char,
constraint enroll_pk primary key(secid,stdid),
constraint enroll_fk_sec foreign key(secid) references SECTION(secid) on delete cascade,
constraint enroll_fk_std foreign key(stdid) references STUDENT(sid) on delete cascade,
constraint enroll_grade check (grade in ('A','B','C','D','F')))




/*********************************************************/
/************** insert data statement *******************/
/*********************************************************/


-- *************** STUDENT

set dateformat dmy  -- set date format to day month year

insert into STUDENT values('60001','Rukawa',  'CS',	3.75,	'13-5-2004')
insert into STUDENT values('60002','Sakuragi','CS',	2.85,	'15-01-2004')
insert into STUDENT values('60003','Mitsui',  'CS',	3.98,	'25-06-2003')
insert into STUDENT values('60004', Null,	'CS',	1.55,	'8-12-2003')
insert into STUDENT values('60005', Null,	'PY',	2.78,	'2-09-2004')
insert into STUDENT values('60006','Ryota',	'PY',	2.85,	'9-04-2005')
insert into STUDENT values('60007','L',		'Art',	3.98,	'31-01-2005')
insert into STUDENT values('60008','Kira',	'Art',	3.05,	'25-02-2006')
insert into STUDENT values('60009','Killua', 'Thai',	2.78,	'23-03-2003')
insert into STUDENT values('60010','Gon',	'PY',	1.50,	'20-2-2002')
insert into STUDENT values('70022','Sendoh', null,	3.98,	null)
insert into STUDENT values('70033', null ,	null,	3.50,	null)

insert into SUBJECT values('CS001','Programming',	3, null)
insert into SUBJECT values('CS002','OOP',			3, 'CS001')
insert into SUBJECT values('CS003','Web Programming',2, 'CS001')
insert into SUBJECT values('CS004','Database',		3, 'CS001')
insert into SUBJECT values('CS005','Graphics',		3, 'CS002')
insert into SUBJECT values('CS006','Mobile Apps',	2, 'CS002')
insert into SUBJECT values('CS007','Robotics',		4, 'CS002')
insert into SUBJECT values('CS008','AI',			3, 'CS002')
insert into SUBJECT values('CS009','Project',		6, 'CS004')
insert into SUBJECT values('MA001','Mathematics 1',	3, null)
insert into SUBJECT values('MA002','Discrete Math',	4, 'MA001')
insert into SUBJECT values('TH001','Thai',			1, null)
insert into SUBJECT values('EN001','English 1',		2, null)
insert into SUBJECT values('EN002','Reading 1',		3, 'EN001')
insert into SUBJECT values('EN003','Conversation',	3, 'EN001')

-- *************** LECTURER 
insert into LECTURER values('t01','Peter Parker',	40000,	'CS')
insert into LECTURER values('t02','Steve Roger',	50000,	'CS')
insert into LECTURER values('t03','Edward Norton',	55000,	'MIS')
insert into LECTURER values('t04','Post Malone',	30000,	'TH')
insert into LECTURER values('t05','Iron Man',		65000,	'MIS')
insert into LECTURER values('t06','Neytiri',	42000,	'English')
insert into LECTURER values('t07','Prymania',	50000,	'English')
insert into LECTURER values('t08','Brian OCornner',	30000,	'English')
insert into LECTURER values('t09','Batman',			30000,	'English')
insert into LECTURER values('t10','Wolverine',		37000,	'Xmen')

insert into SECTION(subid,lecid,term) values ('CS001','t01','1-2019')
insert into SECTION(subid,lecid,term) values ('CS004','t01','1-2019')
insert into SECTION(subid,lecid,term) values ('CS005','t01','1-2019')
insert into SECTION(subid,lecid,term) values ('CS003','t02','1-2019')
insert into SECTION(subid,lecid,term) values ('CS006','t02','1-2019')
insert into SECTION(subid,lecid,term) values ('CS002','t01','2-2019')
insert into SECTION(subid,lecid,term) values ('CS003','t01','2-2019')
insert into SECTION(subid,lecid,term) values ('CS004','t03','2-2019')
insert into SECTION(subid,lecid,term) values ('CS007','t05','2-2019')
insert into SECTION(subid,lecid,term) values ('CS008','t01','2-2019')

insert into SECTION(subid,lecid,term) values ('CS001','t01','1-2020')
insert into SECTION(subid,lecid,term) values ('CS004','t01','1-2020')
insert into SECTION(subid,lecid,term) values ('CS005','t02','1-2020')

insert into SECTION(subid,lecid,term) values ('CS008','t02','2-2020')
insert into SECTION(subid,lecid,term) values ('CS001','t01','2-2020')
insert into SECTION(subid,lecid,term) values ('CS002','t01','2-2020')
insert into SECTION(subid,lecid,term) values ('CS005','t01','2-2020')
insert into SECTION(subid,lecid,term) values ('MA001','t03','2-2020')
insert into SECTION(subid,lecid,term) values ('MA002','t05','2-2020')

insert into SECTION(subid,lecid,term) values ('CS004','t01','3-2020')
insert into SECTION(subid,lecid,term) values ('CS004','t03','3-2020')
insert into SECTION(subid,lecid,term) values ('CS004','t05','3-2020')

insert into SECTION(subid,lecid,term) values ('MA002','t05','2-2021')

insert into SECTION(subid,lecid,term) values ('CS001','t02','1-2021')
insert into SECTION(subid,lecid,term) values ('CS006','t03','1-2021')
insert into SECTION(subid,lecid,term) values ('CS007','t02','1-2021')
insert into SECTION(subid,lecid,term) values ('MA001','t05','1-2021')
insert into SECTION(subid,lecid,term) values ('CS009','t02','1-2021')
insert into SECTION(subid,lecid,term) values ('CS002','t02','1-2021')
insert into SECTION(subid,lecid,term) values ('CS002','t04','1-2021')
insert into SECTION(subid,lecid,term) values ('EN001','t06','1-2022')

-- *************** ENROLL 

insert into ENROLL values(1,60001,'A')
insert into ENROLL values(1,60002,'B')
insert into ENROLL values(1,60005,'C')
insert into ENROLL values(1,60006,'F')
insert into ENROLL values(1,60010,'F')

insert into ENROLL values(2,60001,'C')
insert into ENROLL values(2,60002,'A')
insert into ENROLL values(2,60005,'D')
insert into ENROLL values(2,60010,'F')

insert into ENROLL values(4,60004,'F')

insert into ENROLL values(5,60005,'C')
insert into ENROLL values(5,60006,'A')
insert into ENROLL values(5,60003,'F')
insert into ENROLL values(5,60004,'B')

insert into ENROLL values(6,60001,'B')
insert into ENROLL values(6,60002,'F')
insert into ENROLL values(6,60003,'B')
insert into ENROLL values(6,60007,'A')

insert into ENROLL values(7,60005,'B')
insert into ENROLL values(7,60007,'A')

insert into ENROLL values(8,60001,'A')
insert into ENROLL values(8,60007,'B')

insert into ENROLL values(12,60002,'A')
insert into ENROLL values(12,60004,'A')
insert into ENROLL values(12,60005,'B')
insert into ENROLL values(12,60006,'F')

insert into ENROLL values(13,60004,'A')
insert into ENROLL values(13,60006,'F')

insert into ENROLL values(14,60010,'B')

insert into ENROLL values(15,60001,'A')
insert into ENROLL values(15,60004,'A')
insert into ENROLL values(15,60003,'B')
insert into ENROLL values(15,60010,'F')

insert into ENROLL values(19,60001,'B')
insert into ENROLL values(19,60002,'B')
insert into ENROLL values(19,60003,'A')
insert into ENROLL values(19,60007,'A')
insert into ENROLL values(19,60005,'A')

insert into ENROLL values(21,60006,'A')
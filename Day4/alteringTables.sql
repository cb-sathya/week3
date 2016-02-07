-- sql statements to alter the structure of the existing table



-- 1)Add columns 'created_at' and 'updated_at' to the tables marks, students and medals 

--	 students table 
	alter table students add column created_at datetime, add column updated_at datetime;

--	marks table 
	alter table marks add column created_at datetime, add column updated_at datetime;

--	medals table
	alter table medals add column created_at datetime, add column updated_at datetime;

	

-- 2)Replace the null values in quarterly, half_yearly and annual columns with 0 and make those columns as not nullable 
update marks set quarterly=coalesce(quarterly,0), half_yearly=coalesce(half_yearly,0),annual=coalesce(annual,0) where annual is null or half_yearly is null or quarterly is null;



-- 3)While inserting the value of updated_at & created_at should be the current time 

--	students table 
	alter table students modify column created_at timestamp not null default current_timestamp ,modify column updated_at timestamp not null 	default current_timestamp;

--	marks table 
	alter table marks modify column created_at timestamp not null default current_timestamp ,modify column updated_at timestamp not null 	default current_timestamp;

--	medals table 
	alter table medals modify column created_at timestamp not null default current_timestamp ,modify column updated_at timestamp not null 	default current_timestamp;


-- 4)While updating the value of updated_at alone should be the time of update 

-- 	students table 
 	alter table students modify column updated_at timestamp not null default current_timestamp on update current_timestamp;
 	
--	marks table 
	alter table marks modify column updated_at timestamp not null default current_timestamp on update current_timestamp;

-- 	medals table 
	alter table medals modify column updated_at timestamp not null default current_timestamp on update current_timestamp;








--	Queries: 

 
--	1) create a table students_summary with the below columns
--------->student_id
--------->student_name
--------->year
--------->percentage (got in annual exams)
--------->no_of_medals_received	
--

create table students_summary (student_id bigint(19) not null ,student_name varchar(100),year int(11),percentage float(5,2),no_of_medals_received int);


-- 	2) Derive the values from the tables(students, marks and medals) and insert into the above table using insert with select statement */
insert into students_summary (student_id,student_name,year,percentage,no_of_medals_received) 
	select derived1.student_id,derived1.name,derived1.year,derived1.percentage,coalesce(derived2.no_of_medals_received,0)as no_of_medals_received 
	from (select student_id,name,year,((sum(annual)/500)*100) as percentage from marks 
		inner join students on student_id=students.id group by student_id,year)as derived1 
	left join (select student_id,year,count(medal_won)as no_of_medals_received from medals 
	group by student_id,year) as derived2 
	on derived1.student_id=derived2.student_id and derived1.year=derived2.year;






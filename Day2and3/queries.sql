/* SQL queries for the questions */


/*FOR STUDENT TABLE:*/

/*1) Select all the students*/
select * from students;

/*2)Select all the students whose name starts with "H"*/
select * from students where name like "H%";

/*3)Select all the students whose name has the alphabet “a”*/
select * from students where name like "%a%";

/*4)Select all the students and list the results sorted in alphabetical order(a-z)*/
select * from students order by name;

/*5)List the first “2” students with the results sorted in the alphabetical order(a-z)*/
select * from students order by name limit 0,2;

/*6)List the next “2” students(3rd and 4th) when they are sorted in the alphabetical order*/
select * from students order by name limit 2,2;






/*FOR MARKS TABLE:*/

/*1)Select the students who has not appeared in the annual exams.
--		Format: All columns of the “marks” table*/ 
select * from marks where annual is null;


/*2)Select the students who has not appeared in the annual exams during the year “2005”.
--		Format: student_id, subject_id, year*/
select student_id,subject_id,year from marks where annual is null and year =2005;


/*3)Select the students who has appeared in one of the exams - quarterly, half_yearly or annual.
--		Format: student_id, subject_id, year*/
select student_id,subject_id,year from marks where quarterly is not null or half_yearly is not null or annual is not null;


/*4)Select the students who has scored more than 90 in all the exams - quarterly, half_yearly and annual.
--		Format: student_id, subject_id, year, quarterly, half_yearly, annual*/
select student_id, subject_id, year, quarterly, half_yearly, annual from marks where quarterly>90 and half_yearly>90 and annual>90;


/*5)List the average marks(in quarterly, half_yearly & annual) for each subject scored for the year.
--		Format: student_id, subject_id, average, year*/
select student_id,subject_id,((coalesce(quarterly,0)+coalesce(half_yearly,0)+coalesce(annual=0))/3) as average,year from marks;


/*6)List the average marks(in quarterly, half_yearly & annual) for each subject scored for the years 2003 & 2004
--		Format: student_id, subject_id, average, year*/
select student_id,subject_id,((coalesce(quarterly,0)+coalesce(half_yearly,0)+coalesce(annual=0))/3) as average,year from marks where year in (2003,2004);





















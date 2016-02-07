-- creating innerjoin and executing queries


-- Executing queries on the view


-- 1)List the students who didn’t appear for any exams.
--	Format: name
select students.name from marks inner join students on marks.student_id=students.id where annual=0 and quarterly=0 and half_yearly=0;




-- 2)Find the total marks scored by each students in the annual exams. If the student hasn’t appeared for any annual exam, he should still be listed with total marks scored as “0”.
--	Format: name, marks, year

-- ordered by name
select name,SUM(annual) as marks,year from marks 
inner join students on marks.student_id=students.id 
group by year,name 
order by name;

-- ordered by year
select name,SUM(annual) as marks,year from marks 
inner join students on marks.student_id=students.id 
group by year,name 
order by year;




-- 3)List the students with the total marks scored in quarterly from all the subjects they had appeared during the year 2003
--	Format: name, total, grade
select name,SUM(quarterly) as total,grade from marks 
inner join students on marks.student_id=students.id 
where year=2003 
group by student_id,grade;



-- 4)List the 9th and 10th grade students who received more than 3 medals.
--	Format: name, grade, no_of_medals
select name,grade,count(medal_won) as no_of_medals from  students 
inner join medals on students.id=medals.student_id 
where grade in (9,10) 
group by medals.student_id,grade having count(medal_won)>3;



-- 5)List the students who got less than 2 medals. This should also include the students who has not won any medals.
--	Format: name, grade, no_of_medals
select name,ifnull(grade,"in all grades") as grades,count(medal_won) as no_of_medals from  students 
left join medals on students.id=medals.student_id 
group by students.id,grade 
having count(medal_won)<2;



-- 6)List the students who has not yet received any medals but scored more than 90 marks in all the subjects in the annual exam for that year.
--	Format: name, year
select students.name,marks.year from students 
left join medals on students.id = medals.student_id 
left join marks on marks.student_id = students.id 
group by students.id,medals.id,marks.year having sum(if(annual>90,0,1)) = 0 and count(medals.id) = 0;



-- 7)List the records from the medals table for the students who had won more than 3 medals.
--	Format: name, game_id, medal_won, year, grade
select name,game_id,medal_won,year,grade from medals 
inner join students on students.id=medals.student_id 
where students.id in (select student_id from medals 
						group by student_id 
						having count(medal_won)>=3);



-- 8)List the number of medals and percentage of marks(based on total for the 5 subjects) scored in each year.
--	Format: name, medals, quarterly_per, half_yearly_per, annual_per, year, grade
select students.name,ifnull(derived_medals.medals,0) as medals,avg(ifnull(quarterly,0)) as quarterly_per,avg(ifnull(half_yearly,0)) as half_yearly_per,avg(ifnull(annual,0)) as annual_per,marks.year,marks.grade from marks 
inner join students on marks.student_id=students.id 
left join (select student_id,count(medal_won)as medals,year,grade from medals 
			group by student_id,year,grade) as derived_medals 
on marks.student_id=derived_medals.student_id AND (derived_medals.year = marks.year OR derived_medals.year IS NULL)
group by marks.student_id,marks.year,marks.grade,derived_medals.medals;



-- 9)Lets assign some rating for the total marks scored - S(450-500), A(400-449), B(350-399), C(300-349), D(250,299), E(200-249), F(below 200). List the students with the grade obtained in each year for each exam(quarterly, half-yearly and annual)
--	Format: name, quarterly_rating, half_yearly_rating, annual_rating, year, grade

drop function if exists setRating;
delimiter //
create function setRating(total int) returns char
begin
declare grade char;
if(total>=450)then
set grade='S';
elseif(total>=400)then
set grade='A';
elseif(total>=350)then
set grade='B';
elseif(total>=300)then
set grade='C';
elseif(total>=250)then
set grade='D';
elseif(total>=200)then
set grade='E';
elseif(total<200)then
set grade='F';
end if;
return (grade);
end //
delimiter ;



select name,setRating(sum(coalesce(quarterly,0))) as quarterly_rating,setRating(sum(coalesce(half_yearly,0))) as half_yearly_rating,setRating(sum(coalesce(annual,0))) as annual_rating,year,grade from marks 
inner join students on marks.student_id=students.id 
group by student_id,year,grade;


































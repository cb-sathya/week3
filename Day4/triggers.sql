-- creating and using triggers



-- 1) Add a column average to the table marks

	alter table marks add column average float(5,2) not null after grade;

	update marks set average=((quarterly+half_yearly+annual)/3);

-- 2) Write a trigger to calculate the average marks for the subject whenever any insert/update happens in the columns quarterly, half_yearly and annual in the table 'marks'
	delimiter //
	drop trigger if exists average_trigger ;
	create trigger average_trigger 
    before update on marks 
    for each row
    begin
    set new.average=((new.annual+new.half_yearly+new.quarterly)/3);
    end; //

	drop trigger if exists average_trigger_1 ;
	create trigger average_trigger_1 
    before insert on marks 
    for each row
    begin
    set new.average=((new.annual+new.half_yearly+new.quarterly)/3);
    end; //
	delimiter ;

--  3)Rename the column name from medal_won to medal_received in the table medals 

-- Add a column medal_received to the table medals 
alter table medals add column medal_received varchar(10) after medal_won;

-- Write a trigger to copy the values to both the columns(medal_won and medal_received) whenever any of these columns inserted/updated 
	delimiter //
	drop trigger if exists medals_update_trigger;
	create trigger medals_update_trigger
	before update on medals
	for each row
	begin
	if(new.medal_won <=> old.medal_won) then
	set new.medal_received=new.medal_won;
	elseif(new.medal_received <> old.medal_received) then
	set new.medal_won=new.medal_received;
	end if;
	end;//

	drop trigger if exists medals_insert_trigger;
	create trigger medals_insert_trigger
	before insert on medals
	for each row
	begin
	if(new.medal_won <=> null) then
	set new.medal_received=new.medal_won;
	elseif(new.medal_received is not null) then
	set new.medal_won=new.medal_received; 
	end if;
	end;//
	delimiter ;
	 
	

-- Drop the column medal_won 
	alter table medals drop column medal_won;








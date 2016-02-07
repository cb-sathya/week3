
-- Queries for reservation system


-- 1) To get a list of all trains
select TrainName from Trains;


-- 2)To get the list of all train routes in the database 
select derived.RouteId,derived.OriginStationName,StationCode as DestinationStationName,derived.DistanceInKms 
from (select RouteId,StationCode as OriginStationName,DestinationStationId,DistanceInKms 
		from Routes 
		inner join Stations on OriginStationId=StationId) as derived 
inner join Stations on DestinationStationId=Stations.StationId 
order by RouteId;



-- 3)Total number of seats in the each train 
select TrainName,SUM(NoOfSeats) as TotalSeatsAvailable from TrainCoaches 
inner join Trains on TrainCoaches.TrainNo=Trains.TrainNo 
group by TrainCoaches.TrainNo;


-- 4)List of all routes goes to Bangalore 
-- Only origin and destination stations with distance
select derived.RouteId,derived.OriginStationName,StationCode as DestinationStationName,derived.DistanceInKms 
from (select RouteId,StationCode as OriginStationName,DestinationStationId,DistanceInKms from Routes 
		inner join Stations on OriginStationId=StationId where DestinationStationId=13) as derived  
inner join Stations  on DestinationStationId=Stations.StationId 
order by RouteId;


-- train name,origin station,destination station,arrival and departure time,duration,distance
-- select derived.RouteId,TrainName,derived.ArrivalTime,derived.DepartureTime,derived.DurationInMins,derived.DistanceInKms,derived.OriginStationName,derived.DestinationStationName from (select derived1.RouteId,TrainNo,ArrivalTime,DepartureTime,DurationInMins,DistanceInKms,derived1.OriginStationName,derived1.DestinationStationName from TrainRouteMaps inner join (select derived2.RouteId,derived2.OriginStationName,StationCode as DestinationStationName,derived2.DistanceInKms from (select Routes.RouteId,StationCode as OriginStationName,Routes.DestinationStationId,Routes.DistanceInKms from Routes inner join Stations on Routes.OriginStationId=StationId) as derived2 inner join Stations on derived2.DestinationStationId=Stations.StationId order by RouteId)as derived1 on TrainRouteMaps.RouteId=derived1.RouteId) as derived inner join Trains on derived.TrainNo=Trains.TrainNo where derived.DestinationStationName="SBC";




-- 5)List of all routes starting from bangalore, calcutta and chennai 
-- Only origin and destination stations with distance
select derived.RouteId,derived.OriginStationName,StationCode as DestinationStationName,derived.DistanceInKms 
from (select RouteId,StationCode as OriginStationName,DestinationStationId,DistanceInKms from Routes 
		inner join Stations on OriginStationId=StationId) as derived  
inner join Stations on DestinationStationId=Stations.StationId 
where OriginStationName in("MAS","SBC") 
order by RouteId;



-- train name,origin station,destination station,arrival and departure time,duration,distance
-- select derived.RouteId,TrainName,derived.ArrivalTime,derived.DepartureTime,derived.DurationInMins,derived.DistanceInKms,derived.OriginStationName,derived.DestinationStationName from (select derived1.RouteId,TrainNo,ArrivalTime,DepartureTime,DurationInMins,DistanceInKms,derived1.OriginStationName,derived1.DestinationStationName from TrainRouteMaps inner join (select derived2.RouteId,derived2.OriginStationName,StationCode as DestinationStationName,derived2.DistanceInKms  from (select Routes.RouteId,StationCode as OriginStationName,Routes.DestinationStationId,Routes.DistanceInKms from Routes inner join Stations on Routes.OriginStationId=StationId) as derived2  inner join Stations  on derived2.DestinationStationId=Stations.StationId  order by RouteId)as derived1 on TrainRouteMaps.RouteId=derived1.RouteId) as derived inner join Trains on derived.TrainNo=Trains.TrainNo where derived.OriginStationName="SBC" or derived.OriginStationName="MAS" order by RouteId;


-- 6)List of all the bookings booked between 1st Jan 2005 and 31st Dec 2005
select BookingRefNo,RouteId,TrainName,CoachCode,DateOfJourney,DateOfBooking,NoOfTickets from Bookings 
inner join Trains on Bookings.TrainNo=Trains.TrainNo 
where DateOfBooking>"2005-01-01" and DateOfBooking<"2005-12-31";



-- 7)List of all trains whose name begins with B
select * from Trains where TrainName like ("B%");


-- 8)List of all bookings where DOB is not null 
select BookingRefNo,RouteId,TrainName,CoachCode,DateOfJourney,DateOfBooking,NoOfTickets from Bookings 
inner join Trains on Bookings.TrainNo=Trains.TrainNo 
where DateOfBooking is not null;


-- 9)List of all bookings for the booked in 2006, DOJ in 2007 
select BookingRefNo,RouteId,TrainName,CoachCode,DateOfJourney,DateOfBooking,NoOfTickets from Bookings 
inner join Trains on Bookings.TrainNo=Trains.TrainNo 
where year(DateOfJourney)=2007 and year(DateOfBooking)=2006;


-- 10)Total number of coaches in the all the trains 
select TrainName,count(CoachCode)as TotalCoaches from TrainCoaches 
inner join Tr ains on Trains.TrainNo=TrainCoaches.TrainNo 
group by Trains.TrainNo;


-- 11)Total number of bookings in the database for the train no 16198 
select BookingRefNo,RouteId,TrainName,CoachCode,DateOfJourney,DateOfBooking,count(NoOfTickets) from Bookings 
inner join Trains on Bookings.TrainNo=Trains.TrainNo 
where Bookings.TrainNo=16198 
group by BookingRefNo;


-- 12)Total no of tickets column 'total' , booked for train no. 14198 
select TrainName,sum(NoOfTickets) as TotalTickets from Bookings 
inner join Trains on Bookings.TrainNo=Trains.TrainNo where Bookings.TrainNo =14198 
group by TrainName;

-- 13)Minimum distance route */
select RouteId,DistanceInKms from Routes 
where OriginStationId=12 and DestinationStationId=13 
order by DistanceInKms limit 0,1;

-- 14)Total number of tickets booked for each train in the database 
select TrainName,sum(NoOfTickets) as TotalTickets from Bookings 
inner join Trains on Bookings.TrainNo=Trains.TrainNo 
group by TrainName;



-- 15)cost for 50 kms for each coach 
select CoachCode,(CostPerKm*50) as CostPer50Km from Coaches;


-- 16)List the train name and departure time for the trains starting from Bangalore
select TrainName,DepartureTime 
from (select TrainNo,DepartureTime from TrainRouteMaps 
		inner join Routes on TrainRouteMaps.RouteId=Routes.RouteId where OriginStationId=13)as derived 
inner join Trains on derived.TrainNo=Trains.TrainNo;


-- 17)List the trains for which the total no of tickets booked is greater than 500 
select TrainNo,sum(NoOfTickets)as total_tickets from Bookings 
group by TrainNo having sum(NoOfTickets)>500;



-- 18)List the trains for which the total no of tickets booked is lesser than 50 
select TrainNo,sum(NoOfTickets)as total_tickets from Bookings 
group by TrainNo having sum(NoOfTickets)<50;



-- 19)List the bookings along with train name, origin station, destination station and coach code after the date of journey ’25th Feb 2015’ 
select TrainName,derived1.OriginStationName,derived1.DestinationStationName,derived1.CoachCode 
from(select derived2.TrainNo,derived2.OriginStationName,Stations.StationCode as DestinationStationName,derived2.CoachCode 
		from (select derived3.TrainNo,Stations.StationCode as OriginStationName,derived3.DestinationStationId,derived3.CoachCode 
			from(select Bookings.TrainNo,Routes.OriginStationId,Routes.DestinationStationId,Bookings.CoachCode from Bookings 
				inner join Routes on Bookings.RouteId=Routes.RouteId where Bookings.DateOfJourney>"2015-02-25") as derived3 
		inner join Stations on derived3.OriginStationId=Stations.StationId)as derived2 
	inner join Stations on derived2.DestinationStationId=Stations.StationId)as derived1 
inner join Trains on derived1.TrainNo=Trains.TrainNo;


-- 20)List the trains via the route Mysore - Chennai  
select Trains.TrainName 
from (select TrainRouteMaps.TrainNo,Routes.OriginStationId,routes.DestinationStationId from TrainRouteMaps 
		inner join Routes on TrainRouteMaps.RouteId=Routes.RouteId)as derived 
inner join Trains on derived.TrainNo=Trains.TrainNo 
where derived.OriginStationId in(12,14) and derived.DestinationStationId in(12,14);


-- 21)List the trains for which are booked till now 
select Trains.TrainName,sum(NoOfTickets) as TotalTicketsBooked from Bookings 
inner join Trains on Bookings.TrainNo=Trains.TrainNo 
where dateOfBooking<curdate()
group by Bookings.TrainNo;














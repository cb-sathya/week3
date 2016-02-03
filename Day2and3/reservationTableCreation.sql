/*
Creating tables for reservation system 
*/



/*Coaches table*/
create table Coaches(CoachCode varchar(10) not null,CostPerKm float(7,2) not null,constraint pk_Coaches primary key(CoachCode));


/*Users table*/
create table Users(UserId int not null,LoginId int not null,LPassword varchar(20) not null,constraint pk_Users primary key(UserId));


/*Trains table*/
create table Trains(TrainNo int(20) not null,TrainName varchar(20) not null,constraint pk_Trains primary key (TrainNo));


/*Stations table*/
create table Stations(StationId int not null,StationCode varchar(5) not null,constraint pk_Stations primary key(StationId));


/*TrainCoaches table*/
create table TrainCoaches(TrainNo int not null,CoachCode varchar(20) not null,NoOfSeats int not null,constraint fk1_TrainCoaches foreign key(TrainNo) references Trains(TrainNo),constraint fk2_TrainCoaches foreign key(CoachCode) references Coaches(CoachCode));


/*Routes table*/
create table Routes(RouteId int not null,OriginStationId int not null,DestinationStationId int not null,DistanceInKms int not null,constraint pk_Routes primary key(RouteId),constraint fk1_Routes foreign key(OriginStationId) references Stations(StationId),constraint fk2_Routes foreign key(DestinationStationId)references Stations(StationId));


/*TrainRouteMaps table*/
create table TrainRouteMaps(RouteId int not null,TrainNo int  not null,ArrivalTime Time not null,DepartureTime Time not null,DurationInMins int not null,constraint pk_TrainRouteMaps primary key(RouteId,TrainNo),constraint fk1_TrainRouteMaps foreign key(RouteId) references Routes(RouteId),constraint fk2_TrainRouteMaps foreign key(TrainNo) references Trains(TrainNo));


/*Bookings table*/
create table Bookings(BookingRefNo int not null,RouteId int not null,TrainNo int not null,CoachCode varchar(10) not null,DateOfJourney Date not null,DateOfBooking Date,NoOfTickets int not null,constraint pk_Bookings primary key(BookingRefNo),constraint fk1_Bookings foreign key(RouteId) references TrainRouteMaps(RouteId),constraint fk2_Bookings foreign key(TrainNo) references TrainRouteMaps(TrainNo),constraint fk3_Bookings foreign key(CoachCode) references Coaches(CoachCode));

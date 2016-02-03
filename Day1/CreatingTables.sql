/* 
creating tables for the entities given:
Service Station - id, name, address, contact
employees - id, name, age, contact
customers - id, name, age, contact, emp_id  (employee can also be a customer)
vehicles - id, type(Car, Bike, Bus), brand, color, service_charge
invoices - id, name_of_owner, vehicle, amount_total, employee_assigned
*/

/* ServiceStation */
create table service_station(id int not null auto_increment,name varchar(20) not null,address varchar(20) not null,contact varchar(20), constraint pk_service_station primary key(id));

/*Employees*/
create table employees (id int not null auto_increment,name varchar(20) not null,age varchar(2),contact varchar(10), constraint pk_employees primary key(id));

/*Customers*/
create table customers (id int not null auto_increment,name varchar(20) not null,age varchar(2),contact varchar(10),emp_id int, constraint pk_customers primary key(id),constraint foreign key(emp_id) references employees(id));

/*Vehicles*/
create table vehicles (id int not null auto_increment,type enum ("car","bike","bus") not null,brand varchar(20),color varchar(20),service_charge float(10,2),constraint pk_vehicles primary key(id));

/*invoices*/
create table invoices (id int not null auto_increment,id_of_owner int not null,vehicle_id int not null,amount_total float(10,2) not null, id_of_employee_assigned int not null, constraint pk_invoices primary key(id),constraint fk1_invoices foreign key(id_of_owner) references customers(id),constraint fk2_invoices foreign key(id_of_employee_assigned) references employees(id));

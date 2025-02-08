create database medical
use medical

create table Patients(
patient_id int primary key,
patient_name varchar(20),
patient_lastname varchar(20),
patient_DOB date)

create table Doctors(
doctor_id int primary key,
doctor_name varchar(20),
doctor_lastname varchar(20),
doctor_specialization varchar(20))

create table Appointment(
appointment_id int primary key,
patient_id int foreign key references Patients(patient_id),
doctor_id int foreign key references Doctors(doctor_id),
appointment_date datetime,
appointment_status varchar(20) check (appointment_status in('Scheduled', 'Closed', 'Cancelled')))

create table Treatment(
appointment_id int unique,
foreign key(appointment_id) references Appointment(appointment_id),
treatment_name varchar(20),
treatment_cost int)

---insert some values to test
insert into Patients(patient_id,patient_name, patient_lastname) values
(1, 'Claude', 'Baker'),(2, 'Emilia', 'Gomez'),(3,'Lawrence', 'Middleton'),(4,'Sophia', 'Hensley')
insert into Doctors(doctor_id, doctor_name, doctor_lastname) values
(10, 'Alexandra', 'Mills'), (11,'Michael', 'Wheeler'), (12, 'Marva', 'Lewis')
insert into Treatment(appointment_id, treatment_cost) values
(1, 500), (2, 1000), (3, 100)

---procedure that receives as imput a patient, a doctor, a datetime and a status. If there is no match in Appointments, it creates it. If there is a match, it updates datetime and status.
create procedure create_appt @apptid int, @patientid int, @doctorid int, @appttime datetime, @stat varchar(20)
AS
BEGIN
	if(exists(select * from Appointment a where a.appointment_id = @apptid))
		update Appointment
		set appointment_date = @appttime, appointment_status = @stat
		where appointment_id = @apptid
	else
		insert into Appointment(appointment_id,patient_id, doctor_id, appointment_date, appointment_status) VALUES(@apptid, @patientid, @doctorid, @appttime, @stat)
END

exec create_appt 3, 2, 11, '2025-01-02T10:00:00', 'Scheduled'

select * from Appointment

---view that shows the patients with the most expensive treatment
create view show_patients
AS
	select a.patient_id, t.treatment_cost from Appointment a inner join Treatment t on a.appointment_id=t.appointment_id
	group by t.treatment_cost, a.patient_id having max(t.treatment_cost)=(select max(treatment_cost)from Treatment)

select * from show_patients

---function that lists doctos who have handled at least N appointments, N being given by user
create function list_doctors(@N int)
returns table as
	return(select d.doctor_id, d.doctor_name, count(d.doctor_id) total from Doctors d inner join Appointment a on d.doctor_id=a.doctor_id
	group by d.doctor_id, d.doctor_name having count(d.doctor_id)>=@N and @N >= 1)

select * from list_doctors(2)

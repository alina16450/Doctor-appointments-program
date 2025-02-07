# Doctor-appointments-program
A simple sql database that allows the creation of appointments for patients, as well as keeping track of treatments.
There are 4 tables: Patients, Doctors, Appointments, Treatments
For every doctor and every patient there is an appointment, so there are two 1-many relationships between appointment-patient and appointment-doctor.
Every appointment has a treatment assoaciated, with the information of how the issue is being handled. A 1-1 relationship.

There is a stored procedure implemented which receives as imput a doctor, patient, datetime and an appointment status. If it finds the appointment already exists, it updates the datetime and status. If not, it creates a new 
appointment with that information.

There is a view implemented which displays the patients with  the most expensive treatments.

There is also a function which lists the doctors that have handled at least N appointments, where N is given when the function is called. 

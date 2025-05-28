CREATE table register (
    student_id numeric,
    student_name varchar(50),
    last_name varchar(50),
    enrollment_date date
) partition by range(enrollment_date);

create table register_2024 partition of register
for values from ('2024-01-01') to ('2024-12-31');

create table register_2023 partition of register
for values from ('2023-01-01') to ('2023-12-31');

create table register_2025 partition of register
for values from ('2025-01-01') to ('2025-12-31');

insert into register
(student_id, student_name, last_name, enrollment_date)
values (1, 'Visu', 'Checa', '2023-09-10');

select * from register;
select * from register_2023;
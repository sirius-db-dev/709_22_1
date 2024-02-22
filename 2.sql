--Krivenko Artem

drop table if exists school, grou cascade;

create table school (
	id int primary key,
	name_school text,
	address text
);

create table grou (
	id int primary key,
	name_groups text,
	training_program text,
	startt int,
	school_id int references school(id)
);

insert into school(id, name_school, address)
values (1, '№1', 'Sirius'),
	   (2, '№2', 'Sochi'),
	   (3, '№3', 'Adler');
	   
insert into grou(id, name_groups, training_program, startt, school_id)
values (1, '1a', 'there is a task1', 2023, 1),
	   (2, '2b', 'there is a task2', 2021, 1),
	   (3, '3g', 'there is a task3', 2013, 2),
	   (4, '4b', 'there is a task4', 2031, 2),
	   (5, '5a', 'there is a task5', 2012, 3),
	   (6, '8b', 'there is a task6', 2032, 3);
	   
select school.name_school, school.address,
coalesce(json_agg(json_build_object('name_groups', grou.name_groups, 'training_program', grou.training_program, 'startt', grou.startt))
filter(where grou.school_id notnull), '[]')
from school
left join grou on grou.school_id = school.id
group by school.id;

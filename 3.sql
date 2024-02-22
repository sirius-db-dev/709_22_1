--Krivenko Artem

drop table if exists teams, employees cascade;

create table teams (
	id int primary key,
	name_teams text,
	date_of_creation date
);

create table employees (
	id int primary key,
	first_name text,
	last_name text,
	job_title text,
	teams_id int references teams(id)
);

insert into teams(id, name_teams, date_of_creation)
values (1, '№1', '2024-04-19'),
	   (2, '№2', '2023-03-18'),
	   (3, '№3', '2022-02-17');
	   
insert into employees(id, first_name, last_name, job_title, teams_id)
values (1, 'Artem', 'Krivenko', 'a', 1),
	   (2, 'Anton', 'Otroshenko', 'b', 1),
	   (3, 'Artem', 'Nehoroshev', 'c', 2),
	   (4, 'Vlad', 'Osipov', 'd', 2),
	   (5, 'Misha', 'Noskov', 'e', 3),
	   (6, 'Danil', 'Ozornin', 'f', 3);
	   
select teams.name_teams, teams.date_of_creation,
coalesce(json_agg(json_build_object('first_name', employees.first_name, 'last_name', employees.last_name, 'job_title', employees.job_title))
filter(where employees.teams_id notnull), '[]')
from teams
left join employees on employees.teams_id = teams.id
group by teams.id;

drop table employers;
drop table teams;

create table if not exists employers(
id int primary key generated always as identity,
first_name text,
last_name text,
position_company text
);

create table if not exists teams (
team_id int primary key generated always as identity,
title text,
create_date date,
employer_id int references employers
);

insert into employers(first_name, last_name, position_company)
values('Alexey', 'Bondar', 'Magic Wand'),
('Artyom', 'Grigoryan', 'Fullstack Developer'),
('Mdshka', 'Mdshka', 'True NeuroBioDev'),
('Anastasiya', 'Zorina', 'Backend Developer'),
('Egor', 'Khilkov', 'DevOps')

select * from employers;

insert into teams(title, create_date, employer_id)
values('VK', '2006-10-10', 6),
('Sirius University', '2017-12-01', 2),
('Stars Coffee', '2022-07-07', 4);


select * from teams;

select *
from employers 
		left join teams on employers.id = teams.employer_id;

select
  emp.id,
  emp.first_name,
  emp.last_name,
  coalesce(json_agg(json_build_object(
    'id', teams.team_id, 'employer_id', teams.employer_id, 'create_date', teams.create_date, 'title', teams.title))
      filter (where teams.employer_id is not null), '[]')
        as teams
from employers emp
left join teams teams on emp.id = teams.employer_id
group by emp.id;


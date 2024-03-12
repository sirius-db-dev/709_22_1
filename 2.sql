--Кривенко Артём
create extension if not exists "uuid-ossp";

drop table if exists projects, teams, projects_to_teams cascade;

create table projects(
    id   uuid primary key default uuid_generate_v4(),
    name_projects text,
    start_date date,
    status text
);

create table teams(
    id   uuid primary key default uuid_generate_v4(),
    name_teams text,
    creation_date date
);

create table projects_to_teams(
    projects_id uuid references projects,
    teams_id  uuid references teams,
    primary key (projects_id, teams_id)
);

insert into projects(name_projects, start_date, status)
values ('qqq', '2002-02-02', 'www'),
       ('aaa', '2001-01-01', 'sss'),
       ('zzz', '2003-03-03', 'xxx');

insert into teams(name_teams, creation_date)
values ('A', '2004-04-04'),
       ('B', '2005-05-05'),
       ('V', '2006-06-06');

insert into projects_to_teams(projects_id, teams_id)
values
    ((select id from projects where name_projects = 'qqq'),
     (select id from teams where name_teams = 'A')),
    ((select id from projects where name_projects = 'qqq'),
     (select id from teams where name_teams = 'B')),
    ((select id from projects where name_projects = 'aaa'),
     (select id from teams where name_teams = 'A')),
    ((select id from projects where name_projects = 'aaa'),
     (select id from teams where name_teams = 'B')),
    ((select id from projects where name_projects = 'zzz'),
     (select id from teams where name_teams = 'V')),
    ((select id from projects where name_projects = 'zzz'),
     (select id from teams where name_teams = 'B'));

select projects.id, projects.name_projects, projects.start_date, projects.status,
coalesce(jsonb_agg(jsonb_build_object('id', teams.id, 'name_teams', teams.name_teams, 'creation_date', teams.creation_date))
filter (where teams.id is not null), '[]')
from projects
left join projects_to_teams on projects.id = projects_to_teams.projects_id
left join teams on teams.id = projects_to_teams.teams_id
group by projects.id;

select teams.id, teams.name_teams, teams.creation_date,
coalesce(jsonb_agg(jsonb_build_object('id', projects.id, 'name_projects', projects.name_projects, 'start_date', projects.start_date, 'status', projects.status))
filter (where projects.id is not null), '[]')
from teams
left join projects_to_teams on teams.id = projects_to_teams.teams_id
left join projects on projects.id = projects_to_teams.projects_id
group by teams.id;

drop table if exists projects, teams, project_team cascade;

create table projects (
    id uuid primary key default uuid_generate_v4(),
    name text,
    start_date date,
    status text
);

create table teams (
    id uuid primary key default uuid_generate_v4(),
    name text,
    creation_date date
);

create table project_team (
    project_id uuid references projects,
    team_id uuid references teams
);

insert into projects (name, start_date, status)
values
('nixbsd', '2023-02-05', 'alive'),
('wayland', '2012-05-12', 'worked on');

insert into teams (name, creation_date)
values
('Robs', '2023-02-04'),
('Wayland foundation', '2012-03-23'),
('Me', '2006-04-23');

insert into project_team (project_id, team_id)
values (
    (select p.id from projects as p where p.name = 'nixbsd'),
    (select t.id from teams as t where t.name = 'Robs')
),
(
    (select p.id from projects as p where p.name = 'wayland'),
    (select t.id from teams as t where t.name = 'Wayland foundation')
);

select
    t.id,
    t.name,
    t.creation_date,
    coalesce(json_agg(json_build_object(
        'id', p.id, 'name', p.name,
        'start_date', p.start_date, 'status', p.status
    ))
    filter (where p.id is not null), '[]') as projects
from teams as t
left join project_team as pt on t.id = pt.team_id
left join projects as p on pt.project_id = p.id
group by t.id;

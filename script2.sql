create extension if not exists "uuid-ossp";

drop table if exists repository, developer, repository_to_developer cascade;

create table repository
(
  id uuid primary key default uuid_generate_v4(),
  title text,
  description text,
  stars integer
);

create table developer
(
  id uuid primary key default uuid_generate_v4(),
  nickname text
);


create table repository_to_developer
(
  repository_id uuid references repository(id),
  developer_id uuid references developer(id)
);


insert into repository (title, description, stars)
values
('Repo 1', 'Descriprion 1', 5),
('Repo 2', 'Descriprion 2', 6),
('Repo 3', 'Descriprion 3', 7),
('Repo 4', 'Descriprion 4', 8);


insert into developer (nickname)
values
('John'),
('Mary'),
('Bob');


insert into repository_to_developer (repository_id, developer_id)
values
    ((select id from repository where title = 'Repo 1'),
      (select id from developer where nickname = 'John')),
    ((select id from repository where title = 'Repo 2'),
      (select id from developer where nickname = 'Mary')),
    ((select id from repository where title = 'Repo 3'),
      (select id from developer where nickname = 'Mary'));


select
  r.id,
  r.title,
  r.description,
  r.stars,
  coalesce(jsonb_agg(jsonb_build_object(
  'id', d.id, 'nickname', d.nickname))
  filter (where d.id is not null), '[]') as courier
from repository r
left join repository_to_developer rd on r.id = rd.repository_id
left join developer d on d.id = rd.developer_id
group by r.id;

select
  d.id,
  d.nickname,
  coalesce(jsonb_agg(jsonb_build_object(
  'id', r.id, 'title', r.title, 'description', r.description, 'stars', r.stars))
  filter (where r.id is not null), '[]') as delivery
from developer d
left join repository_to_developer rd on d.id = rd.developer_id
left join repository r on r.id = rd.repository_id
group by d.id;

-- Active: 1708455166224@@127.0.0.1@38746

create EXTENSION if not exists "uuid-ossp";

drop table if exists repository, tikets;

create table repository
(
    id uuid PRIMARY key DEFAULT uuid_generate_v4(),
    name TEXT,
    description text,
    stars int
);


create table tikets
(
    id uuid PRIMARY key DEFAULT uuid_generate_v4(),
    repository_id uuid REFERENCES repository(id),
    name text,
    description text,
    status text
);

insert into repository (name, description, stars)
values
    ('First_repos', 'cool', '5'),
    ('Second_repos', 'well done', '4'),
    ('Third_repos', 'horror', '2'),
    ('Fouth_repos', 'i dont know', '6');

insert into tikets (repository_id, name, description, status)
VALUES
    ((select id from repository where name='First_repos'), 'Cat', 'beautiful', 'OK'),
    ((select id from repository where name='First_repos'), 'Dog', 'cool', 'OK'),
    ((select id from repository where name='Second_repos'), 'Rabbit', 'klass', 'OK'),
    ((select id from repository where name='Second_repos'), 'Bird', 'super', 'OK'),
    ((select id from repository where name='Third_repos'), 'Rat', 'bad', 'BAD'),
    ((select id from repository where name='Third_repos'), 'Mouse', 'very bad', 'BAD');

SELECT
    r.id,
    r.name,
    r.description,
    r.stars,
    COALESCE(json_agg(json_build_object('id', t.id, 'repository_id', t.repository_id, 'name', t.name, 'description', t.description, 'status', t.status))
    filter (where t.id is not null), '[]') as tikets

from repository r
left join tikets t on r.id=t.repository_id
group by r.id;


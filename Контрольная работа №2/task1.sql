create extension if not exists "uuid-ossp";

create table repos (
    id uuid primary key default uuid_generate_v4(),
    name text,
    description text,
    stars int
);

create table devs (
    id uuid primary key default uuid_generate_v4(),
    nickname text
);

create table repos_devs (
    repository_id uuid references repos(id),
    developer_id uuid references devs(id),
    primary key (repository_id, developer_id)
);


INSERT INTO repos (name, description, stars)
VALUES
    ('R1', 'D1', 1),
    ('R2', 'D2', 2),
    ('R3', 'D3', 3);

INSERT INTO devs (nickname)
VALUES
    ('Dr1'),
    ('Dr2'),
    ('Dr3');

INSERT INTO repos_devs (repository_id, developer_id)
VALUES
    ((select id from repos where name='R1'), (select id from devs where nickname='Dr1')),
    ((select id from repos where name='R1'), (select id from devs where nickname='Dr2')),
    ((select id from repos where name='R2'), (select id from devs where nickname='Dr2')),
    ((select id from repos where name='R3'), (select id from devs where nickname='Dr3'));

SELECT r.id,
       r.name,
       r.description,
       r.stars,
       json_agg(json_build_object(
           'id', d.id,
           'nickname', d.nickname
       ))
FROM repos r
LEFT JOIN repos_devs rd ON r.id = rd.repository_id
LEFT JOIN devs d ON rd.developer_id = d.id
GROUP BY r.id;

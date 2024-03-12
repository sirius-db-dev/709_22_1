-- Active: 1708455166224@@127.0.0.1@38746

create EXTENSION if not exists "uuid-ossp";

drop table if exists festival, shows;

create table festival
(
    id uuid PRIMARY key DEFAULT uuid_generate_v4(),
    name TEXT,
    day date,
    place text
);


create table shows
(
    id uuid PRIMARY key DEFAULT uuid_generate_v4(),
    festival_id uuid REFERENCES festival(id),
    name TEXT,
    day date,
    genre text
);

insert into festival (name, day, place)
values
    ('Rock-Festival', '2024.05.25', 'Krasnodar'),
    ('Cat-Festival', '2023.11.20', 'Sochi'),
    ('Dog-Festival', '2022.10.05', 'Moscow'),
    ('New-Festival', '2022.12.23', 'Berlin');

insert into shows (festival_id, name, day, genre)
VALUES
    ((select id from festival where name='Rock-Festival'), 'Rammstein', '2024.05.25', 'rock'),
    ((select id from festival where name='Rock-Festival'), 'Queen', '2024.05.30', 'rock'),
    ((select id from festival where name='Cat-Festival'), 'Dansing cat', '2023.11.20', 'dance'),
    ((select id from festival where name='Cat-Festival'), 'Singing cat', '2023.12.20', 'sing'),
    ((select id from festival where name='Dog-Festival'), 'Playing dog', '2022.10.05', 'games'),
    ((select id from festival where name='Dog-Festival'), 'Happy dog', '2022.11.23', 'happy');

SELECT
    f.id,
    f.name,
    f.day,
    COALESCE(json_agg(json_build_object('id', s.id, 'festival_id', s.festival_id, 'name', s.name, 'day', s.day, 'genre', s.genre))
    filter (where s.id is not null), '[]') as shows

from festival f
left join shows s on f.id=s.festival_id
group by f.id;


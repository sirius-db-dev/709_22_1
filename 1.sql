--Кривенко Артём
create extension if not exists "uuid-ossp";

drop table if exists music, musicians, music_to_musicians cascade;

create table music(
    id   uuid primary key default uuid_generate_v4(),
    title text,
    genre text,
    duration int
);

create table musicians(
    id   uuid primary key default uuid_generate_v4(),
    first_name text,
    last_name text,
    year_of_birth date
);

create table music_to_musicians(
    music_id uuid references music,
    musicians_id  uuid references musicians,
    primary key (music_id, musicians_id)
);

insert into music(title, genre, duration)
values ('qqq', 'www', 123),
       ('aaa', 'sss', 456),
       ('zzz', 'xxx', 124);

insert into musicians(first_name, last_name, year_of_birth)
values ('Artem', 'Krivenko', '2007-03-07'),
       ('Anton', 'Otroshenko', '2006-02-08'),
       ('Vlad', 'Osipov', '2006-11-20');

insert into music_to_musicians(music_id, musicians_id)
values
    ((select id from music where title = 'qqq'),
     (select id from musicians where last_name = 'Krivenko')),
    ((select id from music where title = 'qqq'),
     (select id from musicians where last_name = 'Otroshenko')),
    ((select id from music where title = 'aaa'),
     (select id from musicians where last_name = 'Krivenko')),
    ((select id from music where title = 'aaa'),
     (select id from musicians where last_name = 'Otroshenko')),
    ((select id from music where title = 'zzz'),
     (select id from musicians where last_name = 'Osipov')),
    ((select id from music where title = 'zzz'),
     (select id from musicians where last_name = 'Otroshenko'));

select music.id, music.title, music.genre, music.duration,
coalesce(jsonb_agg(jsonb_build_object('id', musicians.id, 'first_name', musicians.first_name, 'last_name', musicians.last_name, 'year_of_birth', musicians.year_of_birth))
filter (where musicians.id is not null), '[]')
from music
left join music_to_musicians on music.id = music_to_musicians.music_id
left join musicians on musicians.id = music_to_musicians.musicians_id
group by music.id;

select musicians.id, musicians.first_name, musicians.last_name, musicians.year_of_birth,
coalesce(jsonb_agg(jsonb_build_object('id', music.id, 'title', music.title, 'genre', music.genre, 'duration', music.duration))
filter (where music.id is not null), '[]')
from musicians
left join music_to_musicians on musicians.id = music_to_musicians.musicians_id
left join music on music.id = music_to_musicians.music_id
group by musicians.id;

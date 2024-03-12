create extension if not exists "uuid-ossp";

drop table if exists pmusicians, musics, musics_to_musicians cascade;


create table pmusicians
(
  id uuid primary key default uuid_generate_v4(),
  first_name text,
  last_name text,
  year_of_birth text
);

create table musics
(
  id uuid primary key default uuid_generate_v4(),
  name_music text,
  genre text,
  second_time int
);

create table musics_to_musicians
(
  musics_id uuid references musics,
  pmusicians_id uuid references pmusicians,
  primary key(musics_id, pmusicians_id)
);

insert into musics(name_music, genre, second_time)
values ('Du hust', 'rock', 3),
    ('Yoyoy', 'rap', 2),
    ('Lalala', 'hip-hop', 5);

insert into pmusicians(first_name, last_name, year_of_birth)
values ('Till', 'Linderman', '1940'),
    ('Clown', 'Dog', '1830'),
    ('Vlad', 'Mops', '2004'),
    ('Will', 'Gram', '3000');
  
insert into musics_to_musicians(musics_id, pmusicians_id)
values ((select id from musics where name_music = 'Du hust'),
    (select id from pmusicians where first_name = 'Till')),
  ((select id from musics where name_music = 'Du hust'),
    (select id from pmusicians where first_name = 'Will')),
  ((select id from musics where name_music = 'Du hust'),
    (select id from pmusicians where first_name = 'Clown')),
  ((select id from musics where name_music = 'Yoyoy'),
    (select id from pmusicians where first_name = 'Will')),
  ((select id from musics where name_music = 'Yoyoy'),
    (select id from pmusicians where first_name = 'Clown'));


select
  m.id,
  m.name_music,
  m.genre,
  m.second_time,
  coalesce(jsonb_agg(jsonb_build_object(
  'id', p.id, 'first_name', p.first_name, 'last_name', p.last_name,
  'year_of_birth', p.year_of_birth))
  filter (where p.id is not null), '[]') as pmusicians

from musics m 
left join musics_to_musicians mp on m.id = mp.musics_id
left join pmusicians p on p.id = mp.pmusicians_id
group by m.id;

select 
    p.id,
    p.first_name,
    p.last_name,
    p.year_of_birth,
    coalesce(jsonb_agg(jsonb_build_object('id', m.id, 'name_music', m.name_music, 'genre', m.genre, 'second_time', m.second_time))
    filter (where m.id is not null), '[]') as musics
  
from pmusicians p
left join musics_to_musicians mp on p.id = mp.pmusicians_id
left join musics m on m.id = mp.musics_id
group by p.id;

create extension if not exists "uuid-ossp";

drop table if exists humans, festivals, human_to_festival cascade;

create table humans
(
    id uuid primary key default uuid_generate_v4(),
    hm_first_name text,
    hm_last_name text,
    hm_date date
);

create table festivals
(
    id uuid primary key default uuid_generate_v4(),
    fs_name text,
    fs_area text,
    fs_date date
);

create table human_to_festival
(
    human_id uuid references humans,
    festival_id  uuid references festivals,
    primary key (human_id, festival_id)
);

insert into humans(hm_first_name, hm_last_name, hm_date)
values ('Антон', 'Отрощенко', '1999-02-09'),
       ('Никита', 'Лобода', '1965-05-13'),
       ('Артем', 'Кривенко', '1976-04-05'),
       ('Влад', 'Аргун', '1987-01-23'),
       ('Михаил', 'Носков', '1986-11-20');


insert into festivals(fs_name, fs_area, fs_date)
VALUES ('Фестиваль молодежи', 'Сочи', '2024-08-23'),
       ('Фестиваль влюбленных', 'Москва', '2023-04-20'),
       ('Фестиваль 9 мая', 'Казань', '2024-05-09'),
       ('Фестиваль ученых', 'Армавир', '2021-04-12');

insert into human_to_festival(human_id, festival_id)
values
    ((select id from humans where hm_last_name = 'Отрощенко'),
     (select id from festivals where fs_name = 'Фестиваль молодежи')),
    ((select id from humans where hm_last_name = 'Отрощенко'),
     (select id from festivals where fs_name = 'Фестиваль влюбленных')),
    ((select id from humans where hm_last_name = 'Лобода'),
     (select id from festivals where fs_name = 'Фестиваль молодежи')),
    ((select id from humans where hm_last_name = 'Лобода'),
     (select id from festivals where fs_name = 'Фестиваль влюбленных')),
    ((select id from humans where hm_last_name = 'Носков'),
     (select id from festivals where fs_name = 'Фестиваль 9 мая')),
    ((select id from humans where hm_last_name = 'Кривенко'),
     (select id from festivals where fs_name = 'Фестиваль ученых')),
    ((select id from humans where hm_last_name = 'Аргун'),
     (select id from festivals where fs_name = 'Фестиваль 9 мая')),
    ((select id from humans where hm_last_name = 'Носков'),
     (select id from festivals where fs_name = 'Фестиваль ученых'));


select
  hm.id,
  hm.hm_first_name,
  hm.hm_last_name,
  hm.hm_date,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', fs.id, 'name', fs.fs_name, 'area', fs.fs_area, 'date', fs.fs_date))
      filter (where fs.id is not null), '[]') as festivals
from humans hm
left join human_to_festival fn on hm.id = fn.human_id
left join festivals fs on fs.id = fn.festival_id
group by hm.id;


select
  fs.id,
  fs.fs_name,
  fs.fs_area,
  fs.fs_date,
  coalesce(json_agg(json_build_object(
    'id', hm.id, 'first_name', hm.hm_first_name, 
    'last_name', hm.hm_last_name, 'date', hm.hm_date))
      filter (where hm.id is not null), '[]') as humans
from festivals fs
left join human_to_festival fn on fs.id = fn.festival_id
left join humans hm on hm.id = fn.human_id
group by fs.id;



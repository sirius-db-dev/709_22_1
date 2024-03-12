create extension if not exists "uuid-ossp";

drop table if exists humans, measurs, human_to_measure cascade;

create table humans
(
    id uuid primary key default uuid_generate_v4(),
    hm_first_name text,
    hm_last_name text,
    hm_date date
);

create table measurs
(
    id uuid primary key default uuid_generate_v4(),
    ms_name text,
    ms_area text,
    ms_date date
);

create table human_to_measure
(
    human_id uuid references humans,
    measure_id  uuid references measurs,
    primary key (human_id, measure_id)
);

insert into humans(hm_first_name, hm_last_name, hm_date)
values ('Антон', 'Отрощенко', '1999-02-09'),
       ('Никита', 'Лобода', '1965-05-13'),
       ('Артем', 'Кривенко', '1976-04-05'),
       ('Влад', 'Аргун', '1987-01-23'),
       ('Михаил', 'Носков', '1986-11-20');


insert into measurs(ms_name, ms_area, ms_date)
VALUES ('Щербаков', 'Сочи', '2024-08-23'),
       ('Тимати', 'Москва', '2023-04-20'),
       ('Клава Кока', 'Казань', '2024-04-20'),
       ('Баста', 'Армавир', '2021-04-12');

insert into human_to_measure(human_id, measure_id)
values
    ((select id from humans where hm_last_name = 'Отрощенко'),
     (select id from measurs where ms_name = 'Щербаков')),
    ((select id from humans where hm_last_name = 'Отрощенко'),
     (select id from measurs where ms_name = 'Тимати')),
    ((select id from humans where hm_last_name = 'Лобода'),
     (select id from measurs where ms_name = 'Щербаков')),
    ((select id from humans where hm_last_name = 'Лобода'),
     (select id from measurs where ms_name = 'Тимати')),
    ((select id from humans where hm_last_name = 'Носков'),
     (select id from measurs where ms_name = 'Клава Кока')),
    ((select id from humans where hm_last_name = 'Кривенко'),
     (select id from measurs where ms_name = 'Баста')),
    ((select id from humans where hm_last_name = 'Аргун'),
     (select id from measurs where ms_name = 'Клава Кока')),
    ((select id from humans where hm_last_name = 'Носков'),
     (select id from measurs where ms_name = 'Баста'));


select
  hm.id,
  hm.hm_first_name,
  hm.hm_last_name,
  hm.hm_date,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', ms.id, 'name', ms.ms_name, 'area', ms.ms_area, 'date', ms.ms_date))
      filter (where ms.id is not null), '[]') as measurs
from humans hm
left join human_to_measure mn on hm.id = mn.human_id
left join measurs ms on ms.id = mn.measure_id
group by hm.id;


select
  ms.id,
  ms.ms_name,
  ms.ms_area,
  ms.ms_date,
  coalesce(json_agg(json_build_object(
    'id', hm.id, 'first_name', hm.hm_first_name, 
    'last_name', hm.hm_last_name, 'date', hm.hm_date))
      filter (where hm.id is not null), '[]') as humans
from measurs ms
left join human_to_measure mn on ms.id = mn.measure_id
left join humans hm on hm.id = mn.human_id
group by ms.id;




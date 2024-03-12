-- 3. Агрегаторы и таксисты:
-- в агрегаторе может работать много таксистов
-- таксист может работать в нескольких агрегаторах
-- агрегатор - название, телефон
-- таксист - имя, фамилия, телефон, автомобиль
create extension if not exists "uuid-ossp";

drop table if exists aggregators, taxi_drivers, aggregator_to_taxi_driver;

create table if not exists aggregators
(
    id uuid primary key default uuid_generate_v4(),
    title text,
    phone text
);

create table if not exists taxi_drivers
(
    id uuid primary key default uuid_generate_v4(),
    name text,
    surname text,
    phone text,
    car text
);

create table if not exists aggregator_to_taxi_driver
(
    aggregator_id uuid references aggregators,
    taxi_driver_id uuid references taxi_drivers,
    primary key (aggregator_id, taxi_driver_id)
);

insert into aggregators (title, phone) values
('Яндекс Такси', '81234567890'),
('У Петровича', '88005553535'),
('No name', '88888888888');

insert into taxi_drivers (name, surname, phone, car) values
('Василий', 'Петрович', '80000000000', 'ВАЗ 2107'),
('Иван', 'Иванов', '80000000000', 'Chevrolet Corvette Z06'),
('Пётр', 'Петров', '80000000000', 'Mclaren Senna');

insert into aggregator_to_taxi_driver (aggregator_id, taxi_driver_id) values
((select id from aggregators where title = 'Яндекс Такси'),
 (select id from taxi_drivers where name = 'Василий' and surname = 'Петрович')),
((select id from aggregators where title = 'Яндекс Такси'),
 (select id from taxi_drivers where name = 'Иван' and surname = 'Иванов')),
((select id from aggregators where title = 'Яндекс Такси'),
 (select id from taxi_drivers where name = 'Пётр' and surname = 'Петров')),
((select id from aggregators where title = 'У Петровича'),
 (select id from taxi_drivers where name = 'Василий' and surname = 'Петрович'));

select
    a.title,
    a.phone,
    coalesce(jsonb_agg(jsonb_build_object(
        'name', t.name, 'surname', t.surname, 'phone', t.phone, 'car', t.car
        )) filter (where t.id is not null), '[]'
    ) as drivers
from aggregators a
left join aggregator_to_taxi_driver at on a.id = at.aggregator_id
left join taxi_drivers t on t.id = at.taxi_driver_id
group by a.id;

select
    t.name,
    t.surname,
    t.phone,
    t.car,
    coalesce(jsonb_agg(jsonb_build_object(
        'title', a.title, 'phone', a.phone
        )) filter (where a.id is not null), '[]'
    ) as aggregators
from taxi_drivers t
left join aggregator_to_taxi_driver at on t.id = at.taxi_driver_id
left join aggregators a on a.id = at.aggregator_id
group by t.id;

create extension if not exists "uuid-ossp";

drop table if exists clients, appeals, appeals_to_clients cascade;


create table clients
(
  id uuid primary key default uuid_generate_v4(),
  first_name text,
  last_name text,
  phone text
);

create table appeals
(
  id uuid primary key default uuid_generate_v4(),
  num int,
  day_time text,
  client_status text
);

create table appeals_to_clients
(
  appeals_id uuid references appeals,
  clients_id uuid references clients,
  primary key(appeals_id, clients_id)
);

insert into appeals(num, day_time, client_status)
values (1, '2022-03-21', 'expectation'),
    (2, '2022-08-03', 'ready'),
    (3, '2023-12-12', 'rejected');

insert into clients(first_name, last_name, phone)
values ('John', 'Smith', '89891363748'),
    ('Fedor', 'Eremin', '898924994958'),
    ('Who', 'Everybody', '89485939455'),
    ('Will', 'Gram', '88005553535');
  
insert into appeals_to_clients(appeals_id, clients_id)
values ((select id from appeals where client_status = 'expectation'),
    (select id from clients where first_name = 'John')),
  ((select id from appeals where client_status = 'expectation'),
    (select id from clients where first_name = 'Fedor')),
  ((select id from appeals where client_status = 'ready'),
    (select id from clients where first_name = 'Who')),
  ((select id from appeals where client_status = 'ready'),
    (select id from clients where first_name = 'Fedor')),
  ((select id from appeals where client_status = 'ready'),
    (select id from clients where first_name = 'John'));


select
  a.id,
  a.num,
  a.day_time,
  a.client_status,
  coalesce(jsonb_agg(jsonb_build_object(
  'id', c.id, 'first_name', c.first_name, 'last_name', c.last_name,
  'phone', c.phone))
  filter (where c.id is not null), '[]') as client

from appeals a 
left join appeals_to_clients ac on a.id = ac.appeals_id
left join clients c on c.id = ac.clients_id
group by a.id;

select 
    c.id,
    c.first_name,
    c.last_name,
    c.phone,
    coalesce(jsonb_agg(jsonb_build_object('id', a.id, 'num', a.num, 'day_time', a.day_time, 'client_status', a.client_status))
    filter (where a.id is not null), '[]') as client
  
from clients c
left join appeals_to_clients ac on c.id = ac.clients_id
left join appeals a on a.id = ac.appeals_id
group by c.id;

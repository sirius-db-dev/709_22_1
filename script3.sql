create extension if not exists "uuid-ossp";

drop table if exists provider, shop, provider_to_shop cascade;


create table provider
(
  id uuid primary key default uuid_generate_v4(),
  name text,
  phone_number text
);

create table shop
(
  id uuid primary key default uuid_generate_v4(),
  name text,
  location text
);

create table provider_to_shop
(
  provider_id uuid references provider(id),
  shop_id uuid references shop(id),
  primary key(provider_id, shop_id)
);

insert into provider(name, phone_number)
values
('Provider 1', '89891363748'),
('Provider 2', '898924994958'),
('Provider 3', '89891363748'),
('Provider 4', '898924994958');


insert into shop(name, location)
values 
('Shop 1', 'Location 1'),
('Shop 2', 'Location 2'),
('Shop 3', 'Location 3'),
('Shop 4', 'Location 4');

insert into provider_to_shop(provider_id, shop_id)
values 
  ((select id from provider where name = 'Provider 1'),
    (select id from shop where name = 'Shop 1')),
  ((select id from provider where name = 'Provider 2'),
    (select id from shop where name = 'Shop 2')),
  ((select id from provider where name = 'Provider 3'),
    (select id from shop where name = 'Shop 4'));


select
  p.id,
  p.name,
  p.phone_number,
  coalesce(jsonb_agg(jsonb_build_object(
  'id', s.id, 'name', s.name, 'location', s.location))
  filter (where s.id is not null), '[]') as shop
from provider p
left join provider_to_shop ps on p.id = ps.provider_id
left join shop s on s.id = ps.shop_id
group by p.id;


select
  s.id,
  s.name,
  s.location,
  coalesce(jsonb_agg(jsonb_build_object(
  'id', p.id, 'name', p.name, 'phone_number', p.phone_number))
  filter (where p.id is not null), '[]') as provider
from shop s
left join provider_to_shop ps on s.id = ps.shop_id
left join provider p on p.id = ps.provider_id
group by s.id;

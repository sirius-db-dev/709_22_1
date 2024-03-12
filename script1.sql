create extension if not exists "uuid-ossp";
drop table if exists delivery, courier, delivery_to_courier cascade;

create table delivery
(
  id uuid primary key default uuid_generate_v4(),
  title text,
  phone_number text
);
create table courier
(
  id uuid primary key default uuid_generate_v4(),
  last_name text,
  first_name text,
  vehicle text,
  phone_number text,
  bag_volume numeric
);


create table delivery_to_courier
(
  delivery_id uuid references delivery(id),
  courier_id uuid references courier(id)
);


insert into delivery (title, phone_number)
values
('Delivery 1', '1234567890'),
('Delivery 2', '1234567891'),
('Delivery 3', '1234567892'),
('Delivery 4', '1234567893');


insert into courier (first_name, last_name, phone_number, vehicle, bag_volume)
values
('John', 'Doe', '1234567890', 'car', 0.5),
('Mary', 'Jane', '1234567891', 'bus', 0.5),
('Bob', 'Bully', '1234567892', 'skate', 1);


insert into delivery_to_courier (delivery_id, courier_id)
values
    ((select id from delivery where title = 'Delivery 1'),
      (select id from courier where first_name = 'John')),
    ((select id from delivery where title = 'Delivery 2'),
      (select id from courier where first_name = 'Mary')),
    ((select id from delivery where title = 'Delivery 3'),
      (select id from courier where first_name = 'Mary'));


select
  d.id,
  d.title,
  d.phone_number,
  coalesce(jsonb_agg(jsonb_build_object(
  'id', c.id, 'first_name', c.first_name, 'last_name', c.last_name,
  'vehicle', c.vehicle))
  filter (where c.id is not null), '[]') as courier
from delivery d
left join delivery_to_courier dc on d.id = dc.delivery_id
left join courier c on c.id = dc.courier_id
group by d.id;

select
  c.id,
  c.last_name,
  c.first_name,
  c.phone_number,
  c.bag_volume,
  c.vehicle,
  coalesce(jsonb_agg(jsonb_build_object(
  'id', d.id, 'title', d.title, 'phone_number', d.phone_number))
  filter (where d.id is not null), '[]') as delivery
from courier c
left join delivery_to_courier dc on c.id = dc.courier_id
left join delivery d on d.id = dc.delivery_id
group by c.id;

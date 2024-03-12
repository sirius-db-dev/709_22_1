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
  first_name text,
  last_name text,
  phone_number text,
  vehicle text,
  bag_volume numeric
);


create table delivery_to_courier
(
  delivery_id uuid references delivery(id),
  courier_id uuid references courier(id)
);


insert into delivery (title, phone_number)
values
('First_Delivery', '898929484'),
('Second_Delivery', '893938485'),
('Third_Delivery', '759594738'),
('Fouth_Delivery', '8943930505');


insert into courier (first_name, last_name, phone_number, vehicle, bag_volume)
values
('Max', 'Smith', '89439459', 'bike', 0.4),
('Clown', 'Cat', '585895955', 'wings', 0.9),
('Black', 'Dog', '30445595995', 'car', 0.5);


insert into delivery_to_courier (delivery_id, courier_id)
values
    ((select id from delivery where title = 'First_Delivery'),
      (select id from courier where first_name = 'Max')),
    ((select id from delivery where title = 'Second_Delivery'),
      (select id from courier where first_name = 'Clown')),
    ((select id from delivery where title = 'Third_Delivery'),
      (select id from courier where first_name = 'Clown'));


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
  c.first_name,
  c.last_name,
  c.phone_number,
  c.vehicle,
  c.bag_volume,
  coalesce(jsonb_agg(jsonb_build_object(
  'id', d.id, 'title', d.title, 'phone_number', d.phone_number))
  filter (where d.id is not null), '[]') as delivery

from courier c
left join delivery_to_courier dc on c.id = dc.courier_id
left join delivery d on d.id = dc.delivery_id
group by c.id;

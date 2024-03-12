create extension if not exists "uuid-ossp";
drop table if exists delivery, courier;

create table courier (
	id uuid primary key default uuid_generate_v4(),
	name text,
	last_name text,
	phone text,
	vehicle text,
	bag_size float 
);

create table delivery (
	id uuid primary key default uuid_generate_v4(),
	title text,
	phone text
);


create table courier_to_delivery (
	courier_id uuid references courier,
	delivery_id uuid references delivery,
	primary key (courier_id, delivery_id)
);


insert into courier(name, last_name, phone, vehicle, bag_size) 
values
('Матвей', 'Озорнин', '8800553535', 'ноги', 4.9),
('Михаил', 'Носков', '7777777777', 'велосипед', 1.0),
('Марко', 'Арсенович', '+79164485679', 'ролики', 2.5);

insert into delivery(title, phone) 
values
('Бургеры', '+89139280848'),
('Пицца', '+7(842) 376 24-73'),
('Ролы', '+7(802) 376 25-43');

insert into courier_to_delivery(courier_id, delivery_id)
values
    ((select id from courier where last_name = 'Озорнин'),
     (select id from delivery where title = 'Бургеры')),
    ((select id from courier where last_name = 'Озорнин'),
     (select id from delivery where title = 'Пицца')),
    ((select id from courier where last_name = 'Арсенович'),
     (select id from delivery where title = 'Пицца')),
    ((select id from courier where last_name = 'Носков'),
     (select id from delivery where title = 'Бургеры'));
     
select
  a.id,
  a.name,
  a.last_name,
  a.phone,
  a.vehicle,
  a.bag_size,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id, 'title', f.title, 'phone number', f.phone))
      filter (where f.id is not null), '[]') as delivery
from courier a
left join courier_to_delivery af on a.id = af.courier_id
left join delivery f on f.id = af.delivery_id
group by a.id;

select
  a.id,
  a.title,
  a.phone,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id, 'first name', f.name, 'last name', f.last_name, 'phone number', f.phone, 'vehicle', f.vehicle, 'bag size', f.bag_size))
      filter (where f.id is not null), '[]') as courier
from delivery a
left join courier_to_delivery af on a.id = af.delivery_id
left join courier f on f.id = af.courier_id
group by a.id;

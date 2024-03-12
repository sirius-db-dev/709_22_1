create extension if not exists "uuid-ossp";
drop table if exists aggregator, driver;

create table driver (
	id uuid primary key default uuid_generate_v4(),
	name text,
	last_name text,
	phone text,
	vehicle text
);

create table aggregator (
	id uuid primary key default uuid_generate_v4(),
	title text,
	phone text
);


create table driver_to_aggregator (
	driver_id uuid references driver,
	aggregator_id uuid references aggregator,
	primary key (driver_id, aggregator_id)
);


insert into driver(name, last_name, phone, vehicle) 
values
('Матвей', 'Озорнин', '8800553535', 'ноги'),
('Михаил', 'Носков', '7777777777', 'велосипед'),
('Марко', 'Арсенович', '+79164485679', 'ролики');

insert into aggregator(title, phone) 
values
('Яндекс', '+89139280848'),
('Максим', '+7(842) 376 24-73'),
('Драйв', '+7(802) 376 25-43');

insert into driver_to_aggregator(driver_id, aggregator_id)
values
    ((select id from driver where last_name = 'Озорнин'),
     (select id from aggregator where title = 'Яндекс')),
    ((select id from driver where last_name = 'Озорнин'),
     (select id from aggregator where title = 'Максим')),
    ((select id from driver where last_name = 'Арсенович'),
     (select id from aggregator where title = 'Максим')),
    ((select id from driver where last_name = 'Носков'),
     (select id from aggregator where title = 'Яндекс'));
     
select
  a.id,
  a.name,
  a.last_name,
  a.phone,
  a.vehicle,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id, 'title', f.title, 'phone number', f.phone))
      filter (where f.id is not null), '[]') as aggregator
from driver a
left join driver_to_aggregator af on a.id = af.driver_id
left join aggregator f on f.id = af.aggregator_id
group by a.id;

select
  a.id,
  a.title,
  a.phone,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id, 'first name', f.name, 'last name', f.last_name, 'phone number', f.phone, 'vehicle', f.vehicle))
      filter (where f.id is not null), '[]') as driver
from aggregator a
left join driver_to_aggregator af on a.id = af.aggregator_id
left join driver f on f.id = af.driver_id
group by a.id;

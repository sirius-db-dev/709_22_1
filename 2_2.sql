create extension if not exists "uuid-ossp";
drop table if exists orders, courier, order_to_courier cascade;

create table orders
(
	id uuid primary key default uuid_generate_v4(),
	title text,
	phone text
);

create table courier
(
	id uuid primary key default uuid_generate_v4(),
	first_name text,
	last_name text,
	transport text,
	summa int	
);

create table order_to_courier
(
	order_id uuid references orders,
	courier_id uuid references courier,
	primary key(order_id, courier_id)
);

insert into orders(title, phone)
values('samokat', '+79195193919'),
		('dodo', '+79195138804'),
		('well', '+79229525711');
	
insert into courier(first_name, last_name, transport, summa)
values ('nastik', 'zorina', 'avto', 190042),
		('katya', 'zorina', 'samokat', 178905),
		('vera', 'tokareva', 'на своих двух', 1937302);
	
insert into order_to_courier(order_id, courier_id)
values ((select id from orders where title = 'samokat'),
    (select id from courier where first_name = 'nastik')),
  ((select id from orders where title = 'samokat'),
    (select id from courier where first_name = 'katya')),
  ((select id from orders where title = 'samokat'),
    (select id from courier where first_name = 'vera')),
  ((select id from orders where title = 'dodo'),
    (select id from courier where first_name = 'nastik')),
  ((select id from orders where title = 'dodo'),
    (select id from courier where first_name = 'katya'));

select
  o.id,
  o.title,
  o.phone,
  coalesce(jsonb_agg(jsonb_build_object(
  'id', co.id, 'first_name', co.first_name, 'last_name', co.last_name,
  'transport', co.transport, 'summa', co.summa ))
  filter (where co.id is not null), '[]') as courier
  
from orders o
left join order_to_courier oc on o.id = oc.order_id
left join courier co on co.id = oc.courier_id
group by o.id;

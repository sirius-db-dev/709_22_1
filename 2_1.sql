create extension if not exists "uuid-ossp";
drop table if exists aggregator, taksist, aggregator_to_taksist cascade;

create table aggregator
(
	id uuid primary key default uuid_generate_v4(),
	title text,
	phone text
);

create table taksist
(
	id uuid primary key default uuid_generate_v4(),
	first_name text,
	last_name text,
	phone text,
	avto text	
);

create table aggregator_to_taksist
(
	aggregator_id uuid references aggregator,
	taksist_id uuid references taksist,
	primary key(aggregator_id, taksist_id)
);

insert into aggregator(title, phone)
values('yandex_taksi', '+79195193919'),
		('uber', '+79195138804'),
		('well', '+79229525711');
	
insert into taksist(first_name, last_name, phone, avto)
values ('nastik', 'zorina', '+79195193919', 'bmv'),
		('katya', 'zorina', '+79195138804', 'mazda'),
		('vera', 'tokareva', '+79195240918', 'mers');
	
insert into aggregator_to_taksist(aggregator_id, taksist_id)
values ((select id from aggregator where title = 'yandex_taksi'),
    (select id from taksist where first_name = 'nastik')),
  ((select id from aggregator where title = 'yandex_taksi'),
    (select id from taksist where first_name = 'katya')),
  ((select id from aggregator where title = 'yandex_taksi'),
    (select id from taksist where first_name = 'vera')),
  ((select id from aggregator where title = 'uber'),
    (select id from taksist where first_name = 'nastik')),
  ((select id from aggregator where title = 'uber'),
    (select id from taksist where first_name = 'katya'));

select
  a.id,
  a.title,
  a.phone,
  coalesce(jsonb_agg(jsonb_build_object(
  'id', t.id, 'first_name', t.first_name, 'last_name', t.last_name,
  'phone', t.phone, 'avto', t.avto))
  filter (where t.id is not null), '[]') as taksist
  
from aggregator a
left join aggregator_to_taksist at on a.id = at.aggregator_id
left join taksist t on t.id = at.taksist_id
group by a.id;
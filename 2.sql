drop table if exists taxists, orderes cascade;

create table if not exists taxists(
	id serial primary key,
	name_tax text,
	surname text,
	phone_naumber text,
	auto text
);

insert into taxists (name_tax, surname, phone_naumber, auto)
values ('taxist1', 'taxist1', '+79782453', 'auto1'),
		('taxist2', 'taxist2', '+79782453', 'auto2'),
		('taxist3', 'taxist3', '+79782453', 'auto3')
;

create table if not exists orderes(
	id serial primary key,
	id_taxist int references taxists(id),
	names text,
	date_order date,
	shipping_address text,
	destination_address text
);


insert into orderes(id_taxist, names, date_order, shipping_address, destination_address)
values (2, 'name1', '2024-02-22', 'shipping_address1', 'destination_address1'),
		(2, 'name1', '2024-02-22', 'shipping_address1', 'destination_address1')

;

select 
	tax.id, 
	tax.name_tax,
	tax.surname,
	tax.phone_naumber,
	tax.auto,
	coalesce (json_agg(json_build_object(
	'id', ord.id, 'names', ord.names, 'date_order', ord.date_order, 'shipping_address', ord.shipping_address, 'destination_address', ord.destination_address
	)) filter(where ord.id is not null), '[]') from taxists tax
	left join orderes ord on ord.id_taxist = tax.id
	group by tax.id;
	
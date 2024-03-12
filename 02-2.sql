create EXTENSION if not EXISTS "uuid-ossp"; 
drop table if exists shop, provider, store_suppliers CASCADE;

create table shop
(
    id uuid primary key default uuid_generate_v4(),
    name_s text,
    adres text 
);

create table provider
(
    id uuid primary key default uuid_generate_v4(),
    name_p text,
    number text
);

create table store_suppliers
(
    id_s uuid REFERENCES shop,
    id_p uuid references provider,
    primary key (id_s, id_p)
);

insert into shop(name_s, adres)
values('пятерочка', 'воскресенская 13'),
('магнит', 'морской переулок 8'),
('моремолл', 'чайковского 9');

INSERT into provider(name_p, number)
values ('шота у ашота', '8-800-555-35-35'),
('hiclick', '8-888-888-25-25'),
('faros led', '8-910-555-98-69'),
('cx world', '8-707-404-11-22');

insert into store_suppliers(id_s, id_p)
values 
((select id from shop WHERE name_s = 'моремолл'), (select id from provider where name_p = 'hiclick')),
((select id from shop WHERE name_s = 'моремолл'), (select id from provider where name_p = 'cx world')),
((select id from shop WHERE name_s = 'магнит'), (select id from provider where name_p = 'cx world'));


select  shop.id, shop.name_s, shop.adres, COALESCE(json_agg(json_build_object(
    'id', provider.id, 'name_p', provider.name_p, 'number', provider.number))
    filter(where provider.id is not NULL), '[]') as provider
    from shop
    left join store_suppliers on shop.id = store_suppliers.id_s
    left join provider on provider.id = store_suppliers.id_p
    group by shop.id

select  provider.id, provider.name_p, provider.number, COALESCE(json_agg(json_build_object(
    'id', shop.id, 'name_s', shop.name_s, 'adres', shop.adres))
    filter(where shop.id is not NULL), '[]') as shop
    from provider
    left join store_suppliers on provider.id = store_suppliers.id_p
    left join shop on shop.id = store_suppliers.id_s
    group by provider.id

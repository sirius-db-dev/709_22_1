--Кривенко Артём
create extension if not exists "uuid-ossp";

drop table if exists suppliers, stores, suppliers_to_stores cascade;

create table suppliers(
    id   uuid primary key default uuid_generate_v4(),
    name_suppliers text,
    phone text
);

create table stores(
    id   uuid primary key default uuid_generate_v4(),
    name_stores text,
    address text
);

create table suppliers_to_stores(
    suppliers_id uuid references suppliers,
    stores_id  uuid references stores,
    primary key (suppliers_id, stores_id)
);

insert into suppliers(name_suppliers, phone)
values ('Artem', '89187774321'),
       ('Anton', '89384565432'),
       ('Vlad', '89992452455');

insert into stores(name_stores, address)
values ('flowers', 'qqq'),
       ('candy', 'www'),
       ('fruit', 'eee');

insert into suppliers_to_stores(suppliers_id, stores_id)
values
    ((select id from suppliers where name_suppliers = 'Artem'),
     (select id from stores where name_stores = 'flowers')),
    ((select id from suppliers where name_suppliers = 'Artem'),
     (select id from stores where name_stores = 'candy')),
    ((select id from suppliers where name_suppliers = 'Anton'),
     (select id from stores where name_stores = 'flowers')),
    ((select id from suppliers where name_suppliers = 'Anton'),
     (select id from stores where name_stores = 'candy')),
    ((select id from suppliers where name_suppliers = 'Vlad'),
     (select id from stores where name_stores = 'fruit')),
    ((select id from suppliers where name_suppliers = 'Vlad'),
     (select id from stores where name_stores = 'candy'));

select suppliers.id, suppliers.name_suppliers, suppliers.phone,
coalesce(jsonb_agg(jsonb_build_object('id', stores.id, 'name_stores', stores.name_stores, 'address', stores.address))
filter (where stores.id is not null), '[]')
from suppliers
left join suppliers_to_stores on suppliers.id = suppliers_to_stores.suppliers_id
left join stores on stores.id = suppliers_to_stores.stores_id
group by suppliers.id;

select stores.id, stores.name_stores, stores.address,
coalesce(jsonb_agg(jsonb_build_object('id', suppliers.id, 'name_suppliers', suppliers.name_suppliers, 'phone', suppliers.phone))
filter (where suppliers.id is not null), '[]')
from stores
left join suppliers_to_stores on stores.id = suppliers_to_stores.stores_id
left join suppliers on suppliers.id = suppliers_to_stores.suppliers_id
group by stores.id;

create extension if not exists "uuid-ossp";

create table delivers (
    id uuid primary key default uuid_generate_v4(),
    name text,
    phone text
);

create table couriers (
    id uuid primary key default uuid_generate_v4(),
    first_name text,
    last_name text,
    phone text,
    vehicle text,
    bag_volume text
)

create table delivery_couriers (
    delivery_id uuid references delivers(id),
    courier_id uuid references couriers(id),
    primary key (delivery_id, courier_id)
);


INSERT INTO delivers (name, phone)
VALUES
    ('D1', '79409990101'),
    ('D2', '79409990102'),
    ('D3', '79409990103');


INSERT INTO couriers (first_name, last_name, phone, vehicle, bag_volume)
VALUES
    ('C1', 'S1', '77779843421', 'Car', 'Large'),
    ('C2', 'S2', '77779843422', 'Bicycle', 'Medium'),
    ('C3', 'S3', '77779843423', 'Motorcycle', 'Small');


INSERT INTO delivery_couriers (delivery_id, courier_id)
values
	((select id from delivers where name='D1'), (select id from couriers where first_name='C1')),
    ((select id from delivers where name='D1'), (select id from couriers where first_name='C2')),
    ((select id from delivers where name='D2'), (select id from couriers where first_name='C2')),
    ((select id from delivers where name='D2'), (select id from couriers where first_name='C3')),
    ((select id from delivers where name='D3'), (select id from couriers where first_name='C1')),
    ((select id from delivers where name='D3'), (select id from couriers where first_name='C3'));
   	

SELECT c.id,
       c.first_name,
       c.last_name,
       c.phone,
       c.vehicle,
       c.bag_volume,
       json_agg(json_build_object(
           'id', d.id,
           'name', d.name,
           'phone', d.phone
       )) AS deliveries
FROM couriers c
LEFT JOIN delivery_couriers dc ON c.id = dc.courier_id
LEFT JOIN delivers d ON dc.delivery_id = d.id
GROUP BY c.id;

### 3. Покупатели и заказы:
 - покупатель может иметь несколько заказов
 - заказ принадлежит только одному покупателю
 - покупатель - имя, фамилия, телефон
 - заказ - дата, сумма
 
create extension if not exists "uuid-ossp";

drop table if exists customers, orders;

 create table if not exists customers
 (
     id uuid primary key default uuid_generate_v4(),
     first_name text,
     last_name text,
     phone_number text
 );

create table if not exists orders
 (
     id uuid primary key default uuid_generate_v4(),
     id_customer uuid references customers,
     data_ord date,
     amount float
 );

insert into customers (first_name, last_name, phone_number)
values ('Maria', 'D', '+79173456575'),
('Ellijah', 'Artemenko', '+36454356575'),
('Lorrain', 'Ipsum', '+78154534356');

insert into orders (id_customer, data_ord, amount)
values ((select id from customers where last_name = 'D'), '2024-03-03', 8999.9),
((select id from customers where last_name = 'Artemenko'), '2024-03-20', 109999.9),
((select id from customers where last_name = 'D'), '2023-12-31', 149999.9);


 select
     cus.id,
     cus.first_name,
     cus.last_name,
     cus.phone_number,
      coalesce(json_agg(json_build_object(
             'id', ord.id, 'order date', ord.data_ord, 'amount', ord.amount))
             filter (where ord.id is not null), '[]'
     ) as orders
 from customers cus
 left join orders ord on cus.id = ord.id_customer
 group by cus.id;
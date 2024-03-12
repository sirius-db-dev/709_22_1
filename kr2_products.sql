drop table if exists distributers, products, product_to_distributor cascade;

create table products (
    id uuid primary key default uuid_generate_v4(),
    name text,
    price int,
    category text
);

create table distributers (
    id uuid primary key default uuid_generate_v4(),
    name text,
    phone text
);

create table product_to_distributor (
    product_id uuid references products,
    distributor_id uuid references distributers
);

insert into products (name, price, category)
values
('Photoshop', 250, 'software'),
('Gimp', 0, 'software');

insert into distributers (name, phone)
values
('Adobe', '+93498128301'),
('gimp.org', '+39843982900'),
('Me', '+79937657769');

insert into product_to_distributor (product_id, distributor_id)
values (
    (select p.id from products as p where p.name = 'Photoshop'),
    (select d.id from distributers as d where d.name = 'Adobe')
),
(
    (select p.id from products as p where p.name = 'Gimp'),
    (select d.id from distributers as d where d.name = 'gimp.org')
);

select
    d.id,
    d.name,
    d.phone,
    coalesce(json_agg(json_build_object(
        'id', p.id, 'name', p.name,
        'category', p.category
    ))
    filter (where p.id is not null), '[]') as products
from distributers as d
left join product_to_distributor as pd on pd.distributor_id = d.id
left join products as p on pd.product_id = p.id
group by d.id;

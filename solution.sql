-- 1
-- Вывести модели смартфонов без повторений брендов Xiaomi, HONOR, HUAWEI с ценой от 15000 до 25000
select distinct p.model
from product_uve p
join vendor_product_info_26b pv on pv.product_id = p.id
where p.brand in ('Xiaomi', 'HONOR', 'HUAWEI') and pv.price between 15000 and 25000;

-- 2
-- Вывести названия компаний (НЕ брендов), поставляющих смартфоны как с ОС Android, так и с ОС iOS
select v.name
from product_uve p
join vendor_product_info_26b pv on pv.product_id = p.id
join vendor_f1e v on pv.vendor_id = v.id
where p.os = 'Android' and p.category = 'смартфоны'
intersect
select v.name
from product_uve p
join vendor_product_info_26b pv on pv.product_id = p.id
join vendor_f1e v on pv.vendor_id = v.id
where p.os = 'iOS' and p.category = 'смартфоны';

-- 3
-- Вывести названия компаний, поставляющие часы, но не смартфоны
select v.name
from product_uve p
join vendor_product_info_26b pv on pv.product_id = p.id
join vendor_f1e v on pv.vendor_id = v.id
where p.category = 'часы'
except
select v.name
from product_uve p
join vendor_product_info_26b pv on pv.product_id = p.id
join vendor_f1e v on pv.vendor_id = v.id
where p.category = 'смартфоны';

-- 4
-- Вывести названия компаний, поставляющих ноутбуки и мониторы
-- либо имеющие транспортные средства с объемом (body_volume) от 30 и грузоподъемностью от 20
(select v.name
from product_uve p
join vendor_product_info_26b pv on pv.product_id = p.id
join vendor_f1e v on pv.vendor_id = v.id
where p.category = 'ноутбуки'
intersect
select v.name
from product_uve p
join vendor_product_info_26b pv on pv.product_id = p.id
join vendor_f1e v on pv.vendor_id = v.id
where p.category = 'мониторы')
union
select v.name
from transport_3vc t
join vendor_transport_info_0yx tv on tv.transport_id = t.id
join vendor_f1e v on tv.vendor_id = v.id
where t.body_volume >= 30 and t.lifting_capacity >= 20;

-- 5
-- Вывести минимальную и максимальную цену, средний размер экрана и суммарную стоимость (price * quantity)
-- электронных книг бренда Amazon
select min(pv.price), max(pv.price), avg(p.screen_size), sum(pv.price * pv.quantity)
from product_uve p
join vendor_product_info_26b pv on pv.product_id = p.id
where p.category = 'электронные книги' and p.brand = 'Amazon';

-- 6
-- Вывести модели электронных книг с наименьшим весом и наименьшей ценой среди электронных книг с наименьшим весом
with books_min_weight as (
    with e_books as (
    select p.model, pv.price, p.weight
    from product_uve p
    join vendor_product_info_26b pv on pv.product_id = p.id
    where p.category = 'электронные книги')
select *
from e_books
where weight = (select min(weight) from e_books))

select model
from books_min_weight
where price = (select min(price) from books_min_weight);

-- 7
-- Вывести количество различных брендов в категории электронные книги
select count(distinct brand)
from product_uve
where category = 'электронные книги';

-- 1. Вывести модели смартфонов без повторений брендов Xiaomi, HONOR, HUAWEI с ценой от 15_000 до 25_000.
SELECT DISTINCT model from product_ooz
JOIN vendor_product_info_avf on product_ooz.id = vendor_product_info_avf.product_id
WHERE (brand = 'HUAWEI' or brand = 'Xiaomi' or brand = 'HONOR') and (price >= 15000 and price <= 25000)



-- 2. Вывести названия компаний (НЕ брендов), поставляющих смартфоны как с ОС Android, так и с ОС iOS.
select DISTINCT vendor_hbe.name from product_ooz
join vendor_product_info_avf on vendor_product_info_avf.product_id = product_ooz.id
join vendor_hbe on vendor_hbe.id = vendor_product_info_avf.vendor_id
where (product_ooz.category = 'смартфоны') and (product_ooz.os = 'Android' and product_ooz.os = 'iOS')



-- 3. Вывести названия компаний, поставляющие часы, но не смартфоны.
SELECT DISTINCT vendor_hbe.name from product_ooz
JOIN vendor_product_info_avf on vendor_product_info_avf.product_id = product_ooz.id
JOIN vendor_hbe on vendor_hbe.id = vendor_product_info_avf.vendor_id
WHERE product_ooz.category = 'часы' and vendor_hbe.id not in (
    select DISTINCT vendor_hbe.id from product_ooz
    join vendor_product_info_avf on vendor_product_info_avf.product_id = product_ooz.id
    join vendor_hbe on vendor_hbe.id = vendor_product_info_avf.vendor_id
    where product_ooz.category = 'смартфоны'
);


-- 4. Вывести названия компаний, поставляющих ноутбуки и мониторы либо 
--имеющие транспортные средства с объемом(body_volume) от 30 и грузоподъемностью от 20.
select DISTINCT vendor_hbe.name from product_ooz
join vendor_product_info_avf on vendor_product_info_avf.product_id = product_ooz.id
join vendor_hbe on vendor_hbe.id = vendor_product_info_avf.vendor_id
where (product_ooz.category = 'ноутбуки' and product_ooz.category = 'мониторы')
UNION
select DISTINCT vendor_hbe.name from car_svs
join vendor_car_info_wus on vendor_car_info_wus.car_id = car_svs.id
join vendor_hbe on vendor_hbe.id = vendor_car_info_wus.vendor_id
where (car_svs.lifting_capacity >= 20 and car_svs.body_volume >= 30)





--5. Вывести минимальную и максимальную цену, 
--средний размер экрана и суммарную стоимость (price * quantity) электронных книг бренда Amazon.
select min(price), max(price), avg(screen_size), sum(price * quantity)
from product_ooz pr
join vendor_product_info_avf vp on vp.product_id = pr.id
where (category = 'электронные книги') and (brand = 'Amazon')




-- 6. Вывести модели электронных книг 
--с наименьшим весом 
--и наименьшей ценой среди электронных книг 
--с наименьшим весом.
select model from product_ooz pr
join vendor_product_info_avf vp on pr.id = vp.product_id
where weight = (
    select min(weight) from product_ooz
    where (category = 'электронные книги')
) AND price = (
    select min(price) from vendor_product_info_avf vp
    join product_ooz pr on vp.product_id = pr.id
    where weight = (
    select min(weight) from product_ooz
    where category = 'электронные книги'
    )
)


-- 7. Вывести количество различных брендов в категории электронные книги.
select count(brand) from (
    select DISTINCT brand from product_ooz
    where category = 'электронные книги' ) as brnd

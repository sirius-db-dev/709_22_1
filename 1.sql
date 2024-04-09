--Кривенко Артём


--7
select count(distinct brand) from product_knh
where category = 'электронные книги';





--6
select model from product_knh p
join supplier_product_info_woj sp on p.id = sp.product_id
where weight = 
(
select min(weight) from product_knh
where category = 'электронные книги'
) AND price = 
(
select min(price) from supplier_product_info_woj sp
join product_knh p on sp.product_id = p.id
where weight = 
    (
    select min(weight) from product_knh
    where category = 'электронные книги'
    )
);





--5
select min(price) as min_price, max(price) as max_price, avg(screen_size) as avg_screen_size, sum(price * quantity) as total_cost
from product_knh p
join supplier_product_info_woj sp on p.id = sp.product_id
where brand = 'Amazon' and category = 'электронные книги';





--4
select distinct name from supplier_n2b s
where id in 
(
select supplier_id from supplier_product_info_woj sp
join product_knh p on sp.product_id = p.id
where category in ('ноутбуки', 'мониторы')
) or id in 
(
select supplier_id from supplier_vehicle_info_nro sv
join vehicle_djy v on sv.vehicle_id = v.id
where body_volume >= 30 and lifting_capacity >= 20
);






--3
select distinct name from supplier_n2b s
where id in 
(
select supplier_id from supplier_product_info_woj s
join product_knh p on s.product_id = p.id
where category = 'часы'
)and id not in 
(
select supplier_id from supplier_product_info_woj s
join product_knh p on s.product_id = p.id
where category = 'смартфоны'
);





--2
select distinct  name from supplier_n2b s
join supplier_product_info_woj sp on s.id = sp.supplier_id
join product_knh p on p.id = sp.product_id
where os = 'Android' or os = 'iOS';





--1
select distinct model from product_knh p
join supplier_product_info_woj s on p.id = s.product_id
where brand = 'Xiaomi' or brand = 'HONOR' or brand = 'HUAWEI' and price > 15000 and price < 20000;



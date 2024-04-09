select distinct py.model
from product_ysh py
join supplier_product_info_bga spib on spib.product_id = py.id
where (brand = 'Xiaomi' or brand = 'HONOR' or brand = 'HUAWEI') and spib.price > 15000 and spib.price < 25000; 


select distinct supplier_0ju.name from product_ysh
join supplier_product_info_bga spi on spi.product_id = product_ysh.id
join supplier_0ju on supplier_0ju.id = spi.supplier_id
where os = 'Android'
intersect
select distinct supplier_0ju.name from product_ysh
join supplier_product_info_bga spi on spi.product_id = product_ysh.id
join supplier_0ju on supplier_0ju.id = spi.supplier_id
where os = 'iOS'

select distinct supplier_0ju.name from product_ysh
join supplier_product_info_bga spi on spi.product_id = product_ysh.id
join supplier_0ju on supplier_0ju.id = spi.supplier_id
where category = 'часы'
except
select distinct supplier_0ju.name from product_ysh
join supplier_product_info_bga spi on spi.product_id = product_ysh.id
join supplier_0ju on supplier_0ju.id = spi.supplier_id
where category = 'смартфоны'


select distinct supplier_0ju.name from product_ysh
join supplier_product_info_bga spi on spi.product_id = product_ysh.id
join supplier_0ju on supplier_0ju.id = spi.supplier_id
join supplier_transport_info_eyq sti on sti.supplier_id = supplier_0ju.id
join transport_pvl on transport_pvl.id = sti.transport_id
where (body_volume >= 30 and lifting_capacity >= 20) or category = 'ноутбуки' and supplier_0ju.name in (
	select distinct supplier_0ju.name from product_ysh
	join supplier_product_info_bga spi on spi.product_id = product_ysh.id
	join supplier_0ju on supplier_0ju.id = spi.supplier_id
	join supplier_transport_info_eyq sti on sti.supplier_id = supplier_0ju.id
	join transport_pvl on transport_pvl.id = sti.transport_id
	where category = 'мониторы')
	
	
select 
	min(price) min_price,
	max(price) max_price,
	avg(screen_size) avg_screen_size,
	sum(price * quantity)
from product_ysh
join supplier_product_info_bga spib on spib.product_id = product_ysh.id
where brand = 'Amazon' and category = 'электронные книги'

with books_min_weight as (
     with e_books as (
     select p.model, spib.price, p.weight
     from product_ysh p
     join supplier_product_info_bga spib on spib.product_id = p.id
     where p.category = 'электронные книги')
 select *
 from e_books
 where weight = (select min(weight) from e_books))

 select model
 from books_min_weight
 where price = (select min(price) from books_min_weight);

	
select count(distinct brand) from product_ysh
where category = 'электронные книги'
-- 1
select distinct model from product_hqa
join supplier_product_info_lt6 on product_hqa.id = supplier_product_info_lt6.product_id
where (brand = 'Xiaomi' or brand = 'HONOR' or brand = 'HUAWEI')
and (15000 < price and price < 25000);

-- 2
select distinct name from supplier_izw 
join supplier_product_info_lt6 on supplier_izw.id = supplier_product_info_lt6.supplier_id
join product_hqa on supplier_product_info_lt6.product_id = product_hqa.id
where (category = 'смартфоны') and (os = 'Android' and os = 'iOS');


-- 5
select min(price), max(price), avg(screen_size), sum(price * quantity) from product_hqa
join supplier_product_info_lt6 on product_hqa.id = supplier_product_info_lt6.product_id 
where (category = 'электронные книги') and (brand = 'Amazon');


-- 6
select model, category, weight, price from product_hqa
join supplier_product_info_lt6 on product_hqa.id = supplier_product_info_lt6.product_id 
where (category = 'электронные книги');


-- 7
select count(brand) from product_hqa
where category = 'электронные книги';

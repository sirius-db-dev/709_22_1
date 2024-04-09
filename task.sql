-- 1
SELECT DISTINCT model 
FROM product_kfg 
JOIN provider_product_info_p66 
  ON product_kfg.id = provider_product_info_p66.product_id
WHERE brand IN ('Xiaomi', 'HONOR', 'HUAWEI') 
  AND price BETWEEN 15000 AND 25000;


-- 2
SELECT DISTINCT name
FROM provider_j5u
join provider_product_info_p66
  on provider_j5u.id = provider_product_info_p66.provider_id
join product_kfg
  on provider_product_info_p66.product_id = product_kfg.id
WHERE os IN ('Android', 'iOS');


-- 3
SELECT DISTINCT name
FROM provider_j5u
JOIN provider_product_info_p66
  on provider_j5u.id = provider_product_info_p66.provider_id
JOIN product_kfg
  on provider_product_info_p66.product_id = product_kfg.id
WHERE category = 'часы' AND category <> 'смартфоны';

-- 4
SELECT DISTINCT name
FROM provider_j5u
JOIN provider_product_info_p66
  on provider_j5u.id = provider_product_info_p66.provider_id
JOIN product_kfg
  on provider_product_info_p66.product_id = product_kfg.id
JOIN provider_vehicle_info_joq 
  ON provider_j5u.id = provider_vehicle_info_joq.provider_id
JOIN vehicle_lhk ON provider_vehicle_info_joq.vehicle_id = vehicle_lhk.id
WHERE 
  (category IN ('ноутбуки', 'мониторы')) OR 
  (
    body_volume >= 30 AND lifting_capacity >= 20
  );

-- 5
select 
  min(price),
  max(price),
  avg(screen_size),
  SUM(price * quantity) as total
from provider_product_info_p66
join product_kfg
  on provider_product_info_p66.product_id = product_kfg.id
where brand = 'Amazon' and category = 'электронные книги';

-- 6
SELECT model
FROM product_kfg
WHERE weight = (SELECT MIN(weight) FROM product_kfg);

-- 7
SELECT COUNT(DISTINCT brand)
FROM product_kfg
JOIN provider_product_info_p66
  ON product_kfg.id = provider_product_info_p66.product_id
WHERE category = 'электронные книги';


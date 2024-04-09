SELECT DISTINCT model
FROM product_brg
JOIN vendor_product_info_xp2 ON product_brg.id = vendor_product_info_xp2.product_id
WHERE brand IN ('Xiaomi', 'HONOR', 'HUAWEI')
AND price BETWEEN 15000 AND 25000
AND category = 'Смартфоны';
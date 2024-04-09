SELECT MIN(vp.price) AS min_price,
       MAX(vp.price) AS max_price,
       AVG(pb.screen_size) AS avg_screen_size,
       SUM(vp.price * vp.quantity) AS total_cost
FROM product_brg pb
JOIN vendor_product_info_xp2 vp ON pb.id = vp.product_id
WHERE pb.brand = 'Amazon'
AND pb.category = 'электронные книги';
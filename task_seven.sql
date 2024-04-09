SELECT model, weight, price
FROM product_brg
JOIN vendor_product_info_xp2 ON product_brg.id = vendor_product_info_xp2.product_id
WHERE weight = (SELECT MIN(weight) FROM product_brg WHERE category = 'электронные книги')
ORDER BY weight, price
LIMIT 1;
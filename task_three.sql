SELECT DISTINCT name
FROM vendor_bzl
JOIN vendor_product_info_xp2 ON vendor_bzl.id = vendor_product_info_xp2.vendor_id
JOIN product_brg ON vendor_product_info_xp2.product_id = product_brg.id
WHERE category = 'часы';
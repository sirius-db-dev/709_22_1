SELECT DISTINCT vb.name
FROM vendor_bzl vb
JOIN vendor_product_info_xp2 vpi ON vb.id = vpi.vendor_id
JOIN product_brg pb ON vpi.product_id = pb.id
WHERE vb.id IN (SELECT vendor_id
FROM vendor_product_info_xp2
WHERE product_id IN (
SELECT id
FROM product_brg
WHERE os = 'Android')
AND vendor_id IN (
SELECT vendor_id
FROM vendor_product_info_xp2
WHERE product_id IN (
SELECT id
FROM product_brg WHERE os = 'iOS')))
AND pb.category = 'смартфоны';
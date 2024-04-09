SELECT DISTINCT vb.name
FROM vendor_bzl vb
JOIN vendor_product_info_xp2 vpi ON vb.id = vpi.vendor_id
JOIN product_brg pb ON vpi.product_id = pb.id
LEFT JOIN vendor_transport_info_d5w vti ON vb.id = vti.vendor_id
LEFT JOIN transport_hi7 th ON vti.transport_id = th.id
WHERE (pb.category IN ('ноутбуки', 'мониторы') OR th.body_volume >= 30 AND th.lifting_capacity >= 20);
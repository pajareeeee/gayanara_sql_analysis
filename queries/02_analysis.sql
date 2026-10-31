-- Gayanara E-commerce: Analisis (MySQL). Pakai view dari 01_cleaning.sql.

-- 1. Ringkasan revenue (2521 order valid, Rp1,27 miliar, AOV Rp501.920)
SELECT COUNT(*) AS order_valid, SUM(total_amount_idr) AS revenue, ROUND(AVG(total_amount_idr)) AS aov
FROM orders_clean WHERE is_valid_revenue = 1;

-- 2. Tiga bulan dengan revenue tertinggi
SELECT DATE_FORMAT(order_date_clean, '%Y-%m') AS bulan,
       ROUND(SUM(total_amount_idr) / 1000000, 1) AS revenue_juta
FROM orders_clean WHERE is_valid_revenue = 1
GROUP BY bulan ORDER BY revenue_juta DESC LIMIT 3;

-- 3. Revenue per kategori (dihitung dari subtotal item, sebelum diskon)
SELECT pc.category_clean, ROUND(SUM(i.subtotal_idr) / 1000000, 1) AS revenue_juta
FROM order_items i
JOIN orders_clean o ON i.order_id = o.order_id
JOIN products_clean pc ON i.product_id = pc.product_id
WHERE o.is_valid_revenue = 1
GROUP BY pc.category_clean ORDER BY revenue_juta DESC;

-- 4. Lima kota teratas
SELECT shipping_city, COUNT(*) AS jumlah_order, ROUND(SUM(total_amount_idr) / 1000000, 1) AS revenue_juta
FROM orders_clean WHERE is_valid_revenue = 1
GROUP BY shipping_city ORDER BY revenue_juta DESC LIMIT 5;

-- 5. Dampak promo (promo dipakai 41% order, nilai ordernya ±6% lebih kecil)
SELECT (NULLIF(TRIM(promo_code), '') IS NOT NULL) AS pakai_promo,
       COUNT(*) AS jumlah_order, ROUND(AVG(total_amount_idr)) AS rata_rata_order
FROM orders_clean WHERE is_valid_revenue = 1 GROUP BY pakai_promo;

-- 6. Total diskon (Rp31,4 juta)
SELECT ROUND(SUM(COALESCE(discount_amount_idr, 0)) / 1000000, 1) AS total_diskon_juta
FROM orders_clean WHERE is_valid_revenue = 1;

-- 7. Order gagal per kurir (rate gagal keseluruhan 16%)
SELECT courier, ROUND(100 * AVG(is_valid_revenue = 0), 1) AS persen_gagal
FROM orders_clean GROUP BY courier ORDER BY persen_gagal DESC;

-- 8. Order gagal per metode bayar
SELECT payment_method, ROUND(100 * AVG(is_valid_revenue = 0), 1) AS persen_gagal
FROM orders_clean GROUP BY payment_method ORDER BY persen_gagal DESC;
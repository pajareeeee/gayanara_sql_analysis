-- Gayanara E-commerce: Data Cleaning (MySQL)
-- Data mentah diimpor ke database `gayanara` (5 tabel dari ngulikdata.com).
-- Data mentah tidak diubah, semua cleaning dibuat sebagai VIEW.

-- 1. Standarisasi kategori produk (kategori campur bahasa dan huruf besar-kecil)
CREATE VIEW products_clean AS
SELECT p.*,
  CASE LOWER(TRIM(p.category))
    WHEN 'dress' THEN 'Dress'
    WHEN 'jacket' THEN 'Jacket'
    WHEN 'jaket' THEN 'Jacket'
    WHEN 'pants' THEN 'Pants'
    WHEN 'celana' THEN 'Pants'
    WHEN 'accessories' THEN 'Accessories'
    WHEN 'aksesoris' THEN 'Accessories'
    WHEN 'kaos' THEN 'T-Shirt'
    WHEN 't-shirt' THEN 'T-Shirt'
    WHEN 'kemeja' THEN 'Shirt'
    WHEN 'shirt' THEN 'Shirt'
  END AS category_clean
FROM products p;

-- 2. Email dipakai bersama: 3 email dipakai 2 customer berbeda.
-- Bukan duplikat (nama, kota, tanggal daftar beda), jadi hanya diberi flag.
CREATE VIEW customers_clean AS
SELECT c.*, (d.email IS NOT NULL) AS email_shared
FROM customers c
LEFT JOIN (SELECT email FROM customers GROUP BY email HAVING COUNT(*) > 1) d
  ON c.email = d.email;

-- 3. Order sebelum registrasi (795 dari 3000) diberi flag, tidak dihapus.
-- Revenue valid = status delivered, shipped, processing.
CREATE VIEW orders_clean AS
SELECT o.*,
  CAST(o.order_date AS DATE) AS order_date_clean,
  (CAST(o.order_date AS DATE) < CAST(c.registration_date AS DATE)) AS order_before_reg,
  (o.order_status IN ('delivered', 'shipped', 'processing')) AS is_valid_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

-- 4. Validasi: total_amount_idr = jumlah item - diskon (ongkir tidak termasuk).
-- Hasil: 3000 dari 3000 order cocok.
SELECT SUM(o.total_amount_idr = i.items_sum - COALESCE(o.discount_amount_idr, 0)) AS cocok,
       COUNT(*) AS total
FROM orders o
JOIN (SELECT order_id, SUM(subtotal_idr) AS items_sum FROM order_items GROUP BY order_id) i
  ON o.order_id = i.order_id;
# Gayanara E-commerce: Analisis SQL (MySQL)

Proyek portofolio data analyst kedua. Dataset yang sama dengan [proyek Python saya](https://github.com/pajareeeee/gayanara_ecommerce_analysis), tapi seluruh cleaning dan analisis dikerjakan dengan SQL (MySQL).

> Dataset simulasi "Gayanara: Toko Fashion Online" dari [Ngulik Data](https://ngulikdata.com/datasets/gayanara). Semua data bersifat fiktif.

## Isi
| File | Fungsi |
|---|---|
| `queries/01_cleaning.sql` | Membuat view bersih: standarisasi kategori, flag email dipakai bersama, flag order sebelum registrasi, definisi revenue valid, validasi total order |
| `queries/02_analysis.sql` | 8 query analisis: ringkasan revenue, bulan tertinggi, kategori, kota, dampak promo, total diskon, order gagal per kurir dan metode bayar |

## Keputusan Cleaning
- Data mentah tidak diubah, semua cleaning dibuat sebagai VIEW
- 3 email dipakai 2 customer berbeda: diberi flag, tidak dihapus
- 795 dari 3.000 order tercatat sebelum tanggal registrasi: diberi flag, tetap dipakai
- Revenue = `total_amount_idr` (net diskon, belum termasuk ongkir), hanya status delivered, shipped, processing

## Temuan Utama
- Revenue Rp1,27 miliar dari 2.521 order valid, rata-rata Rp501.920 per order
- Bulan tertinggi: Feb 2025 (Rp66,3 juta)
- Lima kategori berselisih tipis, T-Shirt paling rendah (Rp195,6 juta)
- Promo dipakai 41% order tapi nilai ordernya sekitar 6% lebih kecil
- 16% order gagal, J&T dan OVO tertinggi (selisih kecil, belum tentu penyebab)

## Cara Menjalankan
1. Unduh dataset gratis dari [halaman Ngulik Data](https://ngulikdata.com/datasets/gayanara) (perlu isi nama dan email)
2. Buat database `gayanara` di MySQL, lalu impor 5 file CSV sebagai tabel: products, customers, orders, order_items, reviews (kolom pertama = nama kolom)
3. Jalankan `queries/01_cleaning.sql`, lalu `queries/02_analysis.sql`

Diuji dengan MySQL (Laragon + phpMyAdmin).

## Skill yang Dipakai
JOIN, subquery, CASE WHEN, GROUP BY dan HAVING, agregasi, CREATE VIEW, fungsi tanggal
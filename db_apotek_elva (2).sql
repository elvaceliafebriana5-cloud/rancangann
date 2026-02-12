-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 09 Feb 2026 pada 16.38
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_apotek_elva`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `gudang_elva`
--

CREATE TABLE `gudang_elva` (
  `id_gudang_elva` int(11) NOT NULL,
  `nama_gudang_elva` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `gudang_elva`
--

INSERT INTO `gudang_elva` (`id_gudang_elva`, `nama_gudang_elva`) VALUES
(1, 'Gudang Utama'),
(2, 'Gudang Utama Barat');

-- --------------------------------------------------------

--
-- Struktur dari tabel `kategori_elva`
--

CREATE TABLE `kategori_elva` (
  `id_kategori_elva` int(11) NOT NULL,
  `nama_kategori_elva` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `kategori_elva`
--

INSERT INTO `kategori_elva` (`id_kategori_elva`, `nama_kategori_elva`) VALUES
(1, 'Obat Bebas'),
(2, 'Obat Keras'),
(3, 'Vitamin'),
(4, 'Alat Kesehatan');

-- --------------------------------------------------------

--
-- Struktur dari tabel `obat_elva`
--

CREATE TABLE `obat_elva` (
  `id_obat_elva` int(11) NOT NULL,
  `kode_obat_elva` varchar(50) DEFAULT NULL,
  `nama_obat_elva` varchar(100) DEFAULT NULL,
  `jenis_obat_elva` enum('jadi','racikan') DEFAULT NULL,
  `stok_elva` int(11) DEFAULT NULL,
  `harga_elva` int(11) DEFAULT NULL,
  `tanggal_exp_elva` date DEFAULT NULL,
  `id_gudang_elva` int(11) DEFAULT NULL,
  `kategori_id_elva` int(11) DEFAULT NULL,
  `gambar_elva` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `obat_elva`
--

INSERT INTO `obat_elva` (`id_obat_elva`, `kode_obat_elva`, `nama_obat_elva`, `jenis_obat_elva`, `stok_elva`, `harga_elva`, `tanggal_exp_elva`, `id_gudang_elva`, `kategori_id_elva`, `gambar_elva`) VALUES
(1, 'OBT001', 'Paracetamol', 'jadi', 86, 5000, '2027-02-10', 1, 1, 'paracetamol.png'),
(2, 'OBT002', 'Amoxicillin', 'jadi', 41, 12000, '2028-02-16', 1, 2, 'amoxilin.png'),
(3, 'OBT003', 'Vitamin C 1000mg', 'jadi', 139, 7000, '2027-01-20', 1, 3, 'vitamin_c.png'),
(4, 'OBT004', 'Antasida Doen', 'jadi', 88, 3500, '2026-08-10', 2, 1, 'antasida-doen.png'),
(5, 'OBT005', 'OBH Sirup 100ml', 'jadi', 58, 12000, '2026-11-30', 2, 1, 'obh-sirup.png'),
(8, 'OBT006', 'Asam Mefenamat 500mg', 'jadi', 99, 4000, '2027-03-05', 1, 2, 'Asam-Mefenamat-500mg.png'),
(9, 'OBT007', 'Cetirizine 10mg', 'jadi', 109, 3500, '2026-09-25', 1, 2, 'Cetirizine-10mg.png'),
(10, 'OBT008', 'Salbutamol Tablet', 'jadi', 84, 5000, '2026-12-10', 2, 2, 'salbutamol-tablet.png');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pasien_elva`
--

CREATE TABLE `pasien_elva` (
  `id_pasien_elva` int(11) NOT NULL,
  `nama_pasien_elva` varchar(100) DEFAULT NULL,
  `alamat_elva` text DEFAULT NULL,
  `no_hp_elva` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `pengiriman_elva`
--

CREATE TABLE `pengiriman_elva` (
  `id_pengiriman_elva` int(11) NOT NULL,
  `id_transaksi_elva` int(11) DEFAULT NULL,
  `kurir_elva` varchar(50) DEFAULT NULL,
  `no_resi_elva` varchar(50) DEFAULT NULL,
  `status_elva` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pengiriman_elva`
--

INSERT INTO `pengiriman_elva` (`id_pengiriman_elva`, `id_transaksi_elva`, `kurir_elva`, `no_resi_elva`, `status_elva`) VALUES
(1, 1, 'Reguler', 'ELVA-20260209-1', 'diproses'),
(7, 7, 'Ambil Sendiri', 'ELVA-20260209-7', 'diproses');

-- --------------------------------------------------------

--
-- Struktur dari tabel `racikan_elva`
--

CREATE TABLE `racikan_elva` (
  `id_racikan_elva` int(11) NOT NULL,
  `id_resep_elva` int(11) DEFAULT NULL,
  `id_peracik_elva` int(11) DEFAULT NULL,
  `catatan_elva` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `resep_detail_elva`
--

CREATE TABLE `resep_detail_elva` (
  `id_detail_elva` int(11) NOT NULL,
  `id_resep_elva` int(11) DEFAULT NULL,
  `id_obat_elva` int(11) DEFAULT NULL,
  `dosis_elva` varchar(50) DEFAULT NULL,
  `jumlah_elva` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `resep_elva`
--

CREATE TABLE `resep_elva` (
  `id_resep_elva` int(11) NOT NULL,
  `no_resep_elva` varchar(50) DEFAULT NULL,
  `id_pasien_elva` int(11) DEFAULT NULL,
  `id_dokter_elva` int(11) DEFAULT NULL,
  `tipe_elva` enum('online','offline') DEFAULT NULL,
  `status_elva` enum('menunggu','diproses','selesai') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `tbl_kurir_elva`
--

CREATE TABLE `tbl_kurir_elva` (
  `id_kurir_elva` int(11) NOT NULL,
  `nama_kurir_elva` int(11) NOT NULL,
  `no_tlp_kurir` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `transaksi_detail_elva`
--

CREATE TABLE `transaksi_detail_elva` (
  `id_detail_elva` int(11) NOT NULL,
  `id_transaksi_elva` int(11) DEFAULT NULL,
  `id_obat_elva` int(11) DEFAULT NULL,
  `jumlah_elva` int(11) DEFAULT NULL,
  `harga_elva` int(11) DEFAULT NULL,
  `diskon_elva` int(11) DEFAULT NULL,
  `total_elva` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `transaksi_detail_elva`
--

INSERT INTO `transaksi_detail_elva` (`id_detail_elva`, `id_transaksi_elva`, `id_obat_elva`, `jumlah_elva`, `harga_elva`, `diskon_elva`, `total_elva`) VALUES
(1, 1, 2, 2, 12000, NULL, 24000),
(2, 1, 1, 2, 5000, NULL, 10000),
(20, 7, 3, 1, 7000, NULL, 7000),
(21, 7, 2, 1, 12000, NULL, 12000),
(22, 7, 1, 1, 5000, NULL, 5000);

--
-- Trigger `transaksi_detail_elva`
--
DELIMITER $$
CREATE TRIGGER `trg_kurangi_stok_elva` AFTER INSERT ON `transaksi_detail_elva` FOR EACH ROW BEGIN
    UPDATE obat_elva
    SET stok_elva = stok_elva - NEW.jumlah_elva
    WHERE id_obat_elva = NEW.id_obat_elva;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `transaksi_elva`
--

CREATE TABLE `transaksi_elva` (
  `id_transaksi_elva` int(11) NOT NULL,
  `no_faktur_elva` varchar(50) DEFAULT NULL,
  `tanggal_elva` datetime DEFAULT NULL,
  `id_pasien_elva` int(11) DEFAULT NULL,
  `alamat_elva` text DEFAULT NULL,
  `metode_bayar_elva` varchar(20) DEFAULT NULL,
  `kurir_elva` varchar(50) DEFAULT NULL,
  `ongkir_elva` int(11) DEFAULT NULL,
  `total_elva` int(11) DEFAULT NULL,
  `tipe_elva` enum('online','offline') DEFAULT NULL,
  `status_elva` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `transaksi_elva`
--

INSERT INTO `transaksi_elva` (`id_transaksi_elva`, `no_faktur_elva`, `tanggal_elva`, `id_pasien_elva`, `alamat_elva`, `metode_bayar_elva`, `kurir_elva`, `ongkir_elva`, `total_elva`, `tipe_elva`, `status_elva`) VALUES
(1, 'INV-20260209184454', '2026-02-09 18:44:54', 1, 'jl.p', 'COD', 'Reguler', 5000, 39000, 'online', 'diproses'),
(7, 'INV-20260209213255', '2026-02-09 21:32:55', 1, '', 'COD', 'Ambil Sendiri', 0, 24000, 'online', 'diproses');

-- --------------------------------------------------------

--
-- Struktur dari tabel `users_elva`
--

CREATE TABLE `users_elva` (
  `id_user_elva` int(11) NOT NULL,
  `nama_elva` varchar(100) DEFAULT NULL,
  `username_elva` varchar(50) DEFAULT NULL,
  `password_elva` varchar(255) DEFAULT NULL,
  `role_elva` enum('admin','dokter','apoteker','gudang','peracik','kasir','pasien','customer') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `users_elva`
--

INSERT INTO `users_elva` (`id_user_elva`, `nama_elva`, `username_elva`, `password_elva`, `role_elva`) VALUES
(1, 'Elva Celia', 'elva', 'scrypt:32768:8:1$XJfr5C1xAtgec7lL$4fd6785f5c0d13cda52ec85d589fbde85cd2ce662997cab32f8184495289d5d24380abbe42509b06c868d28b5a76167af3ce69a9d0d052ebce89353cdb372c33', 'pasien');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `gudang_elva`
--
ALTER TABLE `gudang_elva`
  ADD PRIMARY KEY (`id_gudang_elva`);

--
-- Indeks untuk tabel `kategori_elva`
--
ALTER TABLE `kategori_elva`
  ADD PRIMARY KEY (`id_kategori_elva`);

--
-- Indeks untuk tabel `obat_elva`
--
ALTER TABLE `obat_elva`
  ADD PRIMARY KEY (`id_obat_elva`),
  ADD KEY `id_gudang_elva` (`id_gudang_elva`),
  ADD KEY `fk_kategori_elva` (`kategori_id_elva`);

--
-- Indeks untuk tabel `pasien_elva`
--
ALTER TABLE `pasien_elva`
  ADD PRIMARY KEY (`id_pasien_elva`);

--
-- Indeks untuk tabel `pengiriman_elva`
--
ALTER TABLE `pengiriman_elva`
  ADD PRIMARY KEY (`id_pengiriman_elva`),
  ADD KEY `id_transaksi_elva` (`id_transaksi_elva`);

--
-- Indeks untuk tabel `racikan_elva`
--
ALTER TABLE `racikan_elva`
  ADD PRIMARY KEY (`id_racikan_elva`),
  ADD KEY `id_resep_elva` (`id_resep_elva`),
  ADD KEY `id_peracik_elva` (`id_peracik_elva`);

--
-- Indeks untuk tabel `resep_detail_elva`
--
ALTER TABLE `resep_detail_elva`
  ADD PRIMARY KEY (`id_detail_elva`),
  ADD KEY `id_resep_elva` (`id_resep_elva`),
  ADD KEY `id_obat_elva` (`id_obat_elva`);

--
-- Indeks untuk tabel `resep_elva`
--
ALTER TABLE `resep_elva`
  ADD PRIMARY KEY (`id_resep_elva`),
  ADD KEY `id_pasien_elva` (`id_pasien_elva`),
  ADD KEY `id_dokter_elva` (`id_dokter_elva`);

--
-- Indeks untuk tabel `tbl_kurir_elva`
--
ALTER TABLE `tbl_kurir_elva`
  ADD PRIMARY KEY (`id_kurir_elva`),
  ADD KEY `nama_kurir_elva` (`nama_kurir_elva`);

--
-- Indeks untuk tabel `transaksi_detail_elva`
--
ALTER TABLE `transaksi_detail_elva`
  ADD PRIMARY KEY (`id_detail_elva`),
  ADD KEY `id_transaksi_elva` (`id_transaksi_elva`),
  ADD KEY `id_obat_elva` (`id_obat_elva`);

--
-- Indeks untuk tabel `transaksi_elva`
--
ALTER TABLE `transaksi_elva`
  ADD PRIMARY KEY (`id_transaksi_elva`);

--
-- Indeks untuk tabel `users_elva`
--
ALTER TABLE `users_elva`
  ADD PRIMARY KEY (`id_user_elva`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `gudang_elva`
--
ALTER TABLE `gudang_elva`
  MODIFY `id_gudang_elva` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `kategori_elva`
--
ALTER TABLE `kategori_elva`
  MODIFY `id_kategori_elva` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `obat_elva`
--
ALTER TABLE `obat_elva`
  MODIFY `id_obat_elva` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT untuk tabel `pasien_elva`
--
ALTER TABLE `pasien_elva`
  MODIFY `id_pasien_elva` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `pengiriman_elva`
--
ALTER TABLE `pengiriman_elva`
  MODIFY `id_pengiriman_elva` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `racikan_elva`
--
ALTER TABLE `racikan_elva`
  MODIFY `id_racikan_elva` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `resep_detail_elva`
--
ALTER TABLE `resep_detail_elva`
  MODIFY `id_detail_elva` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `resep_elva`
--
ALTER TABLE `resep_elva`
  MODIFY `id_resep_elva` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `transaksi_detail_elva`
--
ALTER TABLE `transaksi_detail_elva`
  MODIFY `id_detail_elva` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT untuk tabel `transaksi_elva`
--
ALTER TABLE `transaksi_elva`
  MODIFY `id_transaksi_elva` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `users_elva`
--
ALTER TABLE `users_elva`
  MODIFY `id_user_elva` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `obat_elva`
--
ALTER TABLE `obat_elva`
  ADD CONSTRAINT `fk_gudang` FOREIGN KEY (`id_gudang_elva`) REFERENCES `gudang_elva` (`id_gudang_elva`),
  ADD CONSTRAINT `fk_kategori_elva` FOREIGN KEY (`kategori_id_elva`) REFERENCES `kategori_elva` (`id_kategori_elva`),
  ADD CONSTRAINT `obat_elva_ibfk_1` FOREIGN KEY (`id_gudang_elva`) REFERENCES `gudang_elva` (`id_gudang_elva`);

--
-- Ketidakleluasaan untuk tabel `pengiriman_elva`
--
ALTER TABLE `pengiriman_elva`
  ADD CONSTRAINT `pengiriman_elva_ibfk_1` FOREIGN KEY (`id_transaksi_elva`) REFERENCES `transaksi_elva` (`id_transaksi_elva`);

--
-- Ketidakleluasaan untuk tabel `racikan_elva`
--
ALTER TABLE `racikan_elva`
  ADD CONSTRAINT `racikan_elva_ibfk_1` FOREIGN KEY (`id_resep_elva`) REFERENCES `resep_elva` (`id_resep_elva`),
  ADD CONSTRAINT `racikan_elva_ibfk_2` FOREIGN KEY (`id_peracik_elva`) REFERENCES `users_elva` (`id_user_elva`);

--
-- Ketidakleluasaan untuk tabel `resep_detail_elva`
--
ALTER TABLE `resep_detail_elva`
  ADD CONSTRAINT `resep_detail_elva_ibfk_1` FOREIGN KEY (`id_resep_elva`) REFERENCES `resep_elva` (`id_resep_elva`),
  ADD CONSTRAINT `resep_detail_elva_ibfk_2` FOREIGN KEY (`id_obat_elva`) REFERENCES `obat_elva` (`id_obat_elva`);

--
-- Ketidakleluasaan untuk tabel `resep_elva`
--
ALTER TABLE `resep_elva`
  ADD CONSTRAINT `resep_elva_ibfk_1` FOREIGN KEY (`id_pasien_elva`) REFERENCES `pasien_elva` (`id_pasien_elva`),
  ADD CONSTRAINT `resep_elva_ibfk_2` FOREIGN KEY (`id_dokter_elva`) REFERENCES `users_elva` (`id_user_elva`);

--
-- Ketidakleluasaan untuk tabel `transaksi_detail_elva`
--
ALTER TABLE `transaksi_detail_elva`
  ADD CONSTRAINT `transaksi_detail_elva_ibfk_1` FOREIGN KEY (`id_transaksi_elva`) REFERENCES `transaksi_elva` (`id_transaksi_elva`),
  ADD CONSTRAINT `transaksi_detail_elva_ibfk_2` FOREIGN KEY (`id_obat_elva`) REFERENCES `obat_elva` (`id_obat_elva`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

import 'package:flutter/material.dart';

/// Widget reusable untuk menampilkan konten tab di halaman Solusi.
/// Digunakan oleh SolutionScreen untuk menampilkan Deskripsi, Penanganan,
/// dan Penanggulangan penyakit dalam format card dengan list bernomor.
class SolutionTabContent extends StatelessWidget {
  static const Color primaryGreen = Color(0xFF136B53);

  /// Judul section (contoh: "Deskripsi Bacterial Leaf Blight")
  final String title;

  /// Ikon emoji yang tampil di samping judul (contoh: '📋', '🌿', '🛡️')
  final String icon;

  /// List item teks yang akan ditampilkan sebagai langkah-langkah
  final List<String> items;

  /// Pesan yang ditampilkan ketika [items] kosong
  final String emptyMessage;

  /// Jika true, tampilkan bullet point biasa (untuk deskripsi).
  /// Jika false, tampilkan nomor urut (untuk penanganan/penanggulangan).
  final bool useBullet;

  const SolutionTabContent({
    super.key,
    required this.title,
    required this.icon,
    required this.items,
    required this.emptyMessage,
    this.useBullet = false,
  });

  @override
  Widget build(BuildContext context) {
    // Tampilkan pesan kosong jika tidak ada data
    if (items.isEmpty) {
      return _buildEmptyState();
    }
    return _buildContentCard();
  }

  /// Tampilan ketika data kosong — card dengan ikon info dan pesan
  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.info_outline, color: Colors.grey.shade400, size: 40),
          const SizedBox(height: 12),
          Text(
            emptyMessage,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// Card utama berisi judul section dan list konten
  Widget _buildContentCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: ikon emoji + judul section
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: primaryGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // List item — bullet point atau bernomor
          ...items.asMap().entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      useBullet
                          ? _buildBullet()
                          : _buildNumberBadge(entry.key + 1),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }

  /// Bullet point kecil (●) — digunakan untuk tab Deskripsi
  Widget _buildBullet() {
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.only(right: 12, top: 6),
      decoration: BoxDecoration(
        color: primaryGreen,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  /// Badge bernomor (1, 2, 3...) — digunakan untuk tab Penanganan/Penanggulangan
  Widget _buildNumberBadge(int number) {
    return Container(
      width: 26,
      height: 26,
      margin: const EdgeInsets.only(right: 12, top: 1),
      decoration: BoxDecoration(
        color: primaryGreen,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          '$number',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

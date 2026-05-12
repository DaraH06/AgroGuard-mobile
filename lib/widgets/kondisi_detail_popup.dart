import 'package:flutter/material.dart';

/// Widget popup detail kasus penyakit — ditampilkan sebagai BottomSheet
class KondisiDetailPopup extends StatelessWidget {
  final Map<String, String> item;

  static const Color primaryGreen = Color(0xFF136B53);
  static const Color iconBgGreen = Color(0xFFD4EAE1);

  const KondisiDetailPopup({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Gambar penyakit
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              height: 180,
              color: Colors.green.shade200,
              child: item['thumbnail_url'] != null && item['thumbnail_url']!.isNotEmpty
                  ? Image.network(
                      item['thumbnail_url']!,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.grass, color: Colors.green, size: 72),
                    )
                  : const Icon(Icons.grass, color: Colors.green, size: 72),
            ),
          ),
          const SizedBox(height: 20),

          // Judul penyakit
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              item['judul'] ?? '-',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              item['hama'] ?? '-',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Detail rows
          _popupRow(Icons.location_on_rounded, 'Lokasi', item['lokasi'] ?? '-'),
          _popupRow(Icons.monitor_heart_rounded, 'Jumlah Kasus', item['kasus'] ?? '-'),
          _popupRow(Icons.calendar_today_rounded, 'Dilaporkan', item['tanggal'] ?? '-'),
          const SizedBox(height: 20),

          // Info tambahan
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: iconBgGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline_rounded, color: primaryGreen, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Data kasus ini dikumpulkan berdasarkan hasil scan pengguna AgroGuard di wilayah terkait. '
                    'Pantau terus kondisi tanaman Anda dan lakukan pencegahan sedini mungkin.',
                    style: TextStyle(
                      color: primaryGreen.withValues(alpha: 0.85),
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Tombol tutup
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Tutup',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _popupRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBgGreen,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: primaryGreen, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

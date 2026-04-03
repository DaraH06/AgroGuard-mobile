import 'package:flutter/material.dart';
import 'widgets/agroguard_header.dart';
import 'widgets/scan_toggle.dart';

class KondisiScreen extends StatefulWidget {
  const KondisiScreen({super.key});

  @override
  State<KondisiScreen> createState() => _KondisiScreenState();
}

class _KondisiScreenState extends State<KondisiScreen> {
  bool isScanActive = false;

  static const Color primaryGreen = Color(0xFF136B53);
  static const Color bgLightGreen = Color(0xFFF4FBF5);
  static const Color iconBgGreen = Color(0xFFD4EAE1);

  // Dummy data untuk list berita
  final List<Map<String, String>> _beritaList = List.generate(
    5,
    (index) => {
      'judul': 'Serangan Hama Wereng di Jawa Tengah',
      'lokasi': 'Semarang, Jawa Tengah',
      'hama': 'hama wereng coklat',
      'kasus': '254 kasus',
      'tanggal': '3 Feb 2025',
    },
  );

  void _onToggle(bool scanActive) {
    setState(() => isScanActive = scanActive);
    if (scanActive) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLightGreen,
      body: Column(
        children: [
          const AgroGuardHeader(),
          const SizedBox(height: 24),
          ScanToggle(isScanActive: isScanActive, onToggle: _onToggle),
          const SizedBox(height: 20),
          _buildInfoBanner(),
          const SizedBox(height: 16),
          Expanded(child: _buildNewsList()),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: iconBgGreen,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: primaryGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.trending_up_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pemberitahuan Penyakit & Hama',
                    style: TextStyle(
                      color: primaryGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Pantau kondisi di wilayah Anda.',
                    style: TextStyle(
                      color: primaryGreen,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: _beritaList.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = _beritaList[index];
        return _buildNewsCard(item);
      },
    );
  }

  Widget _buildNewsCard(Map<String, String> item) {
    return Container(
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
      child: Row(
        children: [
          // Dummy foto tanaman
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Container(
              width: 100,
              height: 100,
              color: Colors.green.shade200,
              child: const Icon(
                Icons.grass,
                color: Colors.green,
                size: 48,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['judul']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildDetail(Icons.location_on_outlined, item['lokasi']!),
                  _buildDetail(Icons.bug_report_outlined, item['hama']!),
                  _buildDetail(Icons.monitor_heart_outlined, item['kasus']!),
                  _buildDetail(Icons.calendar_today_outlined, item['tanggal']!),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildDetail(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        children: [
          Icon(icon, size: 12, color: Colors.grey.shade500),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 11,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

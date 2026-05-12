import 'package:flutter/material.dart';
import 'widgets/agroguard_header.dart';
import 'widgets/animated_bottom_toggle.dart';
import 'widgets/solution_tab_content.dart';
import 'kondisi_screen.dart';

/// Halaman Solusi — menampilkan deskripsi penyakit, penanganan, dan penanggulangan.
/// Muncul setelah user menekan tombol "Lihat Solusi" di ResultScreen.
/// Data deskripsi, penanganan, penanggulangan dikirim dari ResultScreen
/// yang sebelumnya didapat dari API Laravel (collection 'penyakit' di MongoDB).
class SolutionScreen extends StatefulWidget {
  /// Nama penyakit yang terdeteksi (contoh: "Bacterial Leaf Blight")
  final String namaPenyakit;

  /// List paragraf deskripsi penyakit dari database
  final List<String> deskripsi;

  /// List langkah-langkah penanganan penyakit
  final List<String> penanganan;

  /// List langkah-langkah penanggulangan/pencegahan penyakit
  final List<String> penanggulangan;

  const SolutionScreen({
    super.key,
    required this.namaPenyakit,
    this.deskripsi = const [],
    this.penanganan = const [],
    this.penanggulangan = const [],
  });

  @override
  State<SolutionScreen> createState() => _SolutionScreenState();
}

class _SolutionScreenState extends State<SolutionScreen> {
  bool isScanActive = true;

  /// Index tab yang aktif: 0 = Deskripsi, 1 = Penanganan, 2 = Pencegahan
  int _selectedTab = 0;

  static const Color primaryGreen = Color(0xFF136B53);
  static const Color bgLightGreen = Color(0xFFF4FBF5);
  static const Color cardBg = Color(0xFFEAF5EE);

  /// Callback dari AnimatedBottomToggle.
  /// - Jika toggle ke "Scan" → kembali ke HomeScreen (popUntil first route)
  /// - Jika toggle ke "Kondisi" → navigasi ke KondisiScreen tanpa animasi
  void _onToggle(bool scanActive) async {
    setState(() => isScanActive = scanActive);
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    if (scanActive) {
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              const KondisiScreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
        (route) => route.isFirst,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLightGreen,
      bottomNavigationBar: AnimatedBottomToggle(
        isScanActive: isScanActive,
        onToggle: _onToggle,
      ),
      body: Column(
        children: [
          const AgroGuardHeader(),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSolutionHeader(),
                  const SizedBox(height: 20),
                  _buildTabBar(),
                  const SizedBox(height: 20),
                  _buildTabContent(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Card header di bagian atas halaman — menampilkan ikon shield + nama penyakit
  /// dan teks petunjuk untuk mengikuti panduan solusi.
  Widget _buildSolutionHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryGreen.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: primaryGreen,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Solusi untuk ${widget.namaPenyakit}',
                  style: const TextStyle(
                    color: primaryGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Ikuti panduan di bawah untuk mengatasi masalah ini',
                  style: TextStyle(
                    color: primaryGreen,
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Tab bar dengan 3 pilihan: Deskripsi, Penanganan, Pencegahan.
  /// Tab yang aktif diberi background hijau, yang tidak aktif transparan.
  /// Menggunakan AnimatedContainer untuk transisi warna yang halus.
  Widget _buildTabBar() {
    const tabs = ['Deskripsi', 'Penanganan', 'Pencegahan'];
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isActive = _selectedTab == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isActive ? primaryGreen : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                ),
                alignment: Alignment.center,
                child: Text(
                  tabs[i],
                  style: TextStyle(
                    color: isActive
                        ? Colors.white
                        : primaryGreen.withValues(alpha: 0.6),
                    fontWeight:
                        isActive ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  /// Menampilkan konten sesuai tab yang sedang aktif.
  /// Menggunakan widget SolutionTabContent yang sudah dipisah ke file terpisah.
  /// - Tab 0: Deskripsi penyakit (bullet point)
  /// - Tab 1: Langkah penanganan (bernomor)
  /// - Tab 2: Langkah penanggulangan (bernomor)
  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return SolutionTabContent(
          title: 'Deskripsi ${widget.namaPenyakit}',
          icon: '📋',
          items: widget.deskripsi,
          emptyMessage: 'Tidak ada deskripsi penyakit.',
          useBullet: true,
        );
      case 1:
        return SolutionTabContent(
          title: 'Langkah Penanganan',
          icon: '🌿',
          items: widget.penanganan,
          emptyMessage: 'Tidak ada data penanganan.',
        );
      case 2:
        return SolutionTabContent(
          title: 'Langkah Penanggulangan',
          icon: '🛡️',
          items: widget.penanggulangan,
          emptyMessage: 'Tidak ada data penanggulangan.',
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

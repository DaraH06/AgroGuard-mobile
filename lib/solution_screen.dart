import 'package:flutter/material.dart';
import 'widgets/agroguard_header.dart';
import 'widgets/animated_bottom_toggle.dart';
import 'kondisi_screen.dart';

class SolutionScreen extends StatefulWidget {
  final String namaPenyakit;
  final List<String> penanganan;
  final List<String> penanggulangan;

  const SolutionScreen({
    super.key,
    required this.namaPenyakit,
    this.penanganan = const [],
    this.penanggulangan = const [],
  });

  @override
  State<SolutionScreen> createState() => _SolutionScreenState();
}

class _SolutionScreenState extends State<SolutionScreen> {
  bool isScanActive = true;
  int _selectedTab = 0; // 0: Penanganan, 1: Pencegahan

  static const Color primaryGreen = Color(0xFF136B53);
  static const Color bgLightGreen = Color(0xFFF4FBF5);
  static const Color cardBg = Color(0xFFEAF5EE);

  void _onToggle(bool scanActive) {
    setState(() => isScanActive = scanActive);
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

  // ── Kartu header berisi nama penyakit ───────────────────────────────────────
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

  // ── Tab bar: Penanganan / Pencegahan ────────────────────────────────────────
  Widget _buildTabBar() {
    const tabs = ['Penanganan', 'Pencegahan'];
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

  // ── Isi konten berdasarkan tab aktif ───────────────────────────────────────
  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return _buildListContent(
          items: widget.penanganan,
          icon: '🌿',
          title: 'Langkah Penanganan',
          emptyMessage: 'Tidak ada data penanganan.',
        );
      case 1:
        return _buildListContent(
          items: widget.penanggulangan,
          icon: '🛡️',
          title: 'Langkah Penanggulangan',
          emptyMessage: 'Tidak ada data penanggulangan.',
        );
      default:
        return const SizedBox.shrink();
    }
  }

  // ── Builder dinamis untuk list penanganan / penanggulangan ─────────────────
  Widget _buildListContent({
    required List<String> items,
    required String icon,
    required String title,
    required String emptyMessage,
  }) {
    if (items.isEmpty) {
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
          // Judul section
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
          // List langkah-langkah
          ...items.asMap().entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        margin: const EdgeInsets.only(right: 12, top: 1),
                        decoration: BoxDecoration(
                          color: primaryGreen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '${entry.key + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
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
}

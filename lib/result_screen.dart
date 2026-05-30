import 'package:flutter/material.dart';
import 'widgets/agroguard_header.dart';
import 'widgets/animated_bottom_toggle.dart';
import 'solution_screen.dart';
import 'kondisi_screen.dart';
import 'dart:io';

class ResultScreen extends StatefulWidget {
  final String? imagePath;
  final String? namaPenyakit;
  final String topConfidence;
  final Map<String, String> tingkatKeyakinan;
  final List<String> deskripsi;
  final List<String> penanganan;
  final List<String> penanggulangan;
  final bool isHealthy;

  const ResultScreen({
    super.key,
    this.imagePath,
    this.namaPenyakit,
    this.topConfidence = '0%',
    this.tingkatKeyakinan = const {},
    this.deskripsi = const [],
    this.penanganan = const [],
    this.penanggulangan = const [],
    this.isHealthy = false,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool isScanActive = true;

  static const Color primaryGreen = Color(0xFF136B53);
  static const Color bgLightGreen = Color(0xFFF4FBF5);
  static const Color resultCardBg = Color(0xFFEAF5EE);

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

  /// Ambil angka persentase dari string seperti "60.00%"
  String _formatPercent(String raw) {
    final cleaned = raw.replaceAll('%', '').trim();
    var value = double.tryParse(cleaned);
    if (value == null) return raw;
    if (value <= 1.0) {
      value = value * 100;
    }

    return '${value.toStringAsFixed(0)}%';
  }

  /// Angka besar dari topConfidence
  String get _bigPercent => _formatPercent(widget.topConfidence);

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
          const SizedBox(height: 24),
          _buildPhotoArea(),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildResultCard(),
                  if (widget.tingkatKeyakinan.length > 1) ...[
                    const SizedBox(height: 16),
                    _buildConfidenceBreakdown(),
                  ],
                  const SizedBox(height: 24),
                  _buildActionButtons(context),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Foto Area — tampilkan gambar asli ──────────────────────────────────────
  Widget _buildPhotoArea() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          height: 220,
          child: widget.imagePath != null
              ? Image.file(
                  File(widget.imagePath!),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildPlaceholderPhoto(),
                )
              : _buildPlaceholderPhoto(),
        ),
      ),
    );
  }

  Widget _buildPlaceholderPhoto() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.green.shade400, Colors.green.shade700],
            ),
          ),
        ),
        const Center(child: Icon(Icons.grass, size: 80, color: Colors.white54)),
      ],
    );
  }

  // ── Result Card — nama penyakit + akurasi ─────────────────────────────────
  Widget _buildResultCard() {
    final diseaseName = widget.namaPenyakit ?? 'Tidak diketahui';
    final emoji = widget.isHealthy ? '✅' : '🦠';
    final statusText = widget.isHealthy
        ? 'Tanaman terdeteksi sehat! Tidak ditemukan gejala penyakit.'
        : 'Penyakit terdeteksi pada tanaman. Lihat solusi untuk penanganan.';
    final statusColor = widget.isHealthy ? Colors.green.shade600 : primaryGreen;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: widget.isHealthy
                      ? Colors.green.shade50
                      : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      diseaseName,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'Akurasi Deteksi',
                      style: TextStyle(
                        color: statusColor.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              _bigPercent,
              style: TextStyle(
                color: statusColor,
                fontSize: 64,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: resultCardBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              statusText,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Confidence Breakdown — semua probabilitas ─────────────────────────────
  Widget _buildConfidenceBreakdown() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tingkat Keyakinan',
            style: TextStyle(
              color: primaryGreen,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 14),
          ...widget.tingkatKeyakinan.entries.map((entry) {
            final label = entry.key;
            final rawPercent = entry.value.replaceAll('%', '').trim();
            final value = double.tryParse(rawPercent) ?? 0;
            final isTop = entry == widget.tingkatKeyakinan.entries.first;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isTop ? FontWeight.w600 : FontWeight.w400,
                          color: isTop ? primaryGreen : Colors.grey.shade700,
                        ),
                      ),
                      Text(
                        _formatPercent(entry.value),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isTop ? FontWeight.w600 : FontWeight.w400,
                          color: isTop ? primaryGreen : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: value <= 1.0 ? value : value / 100,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isTop ? primaryGreen : Colors.grey.shade400,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Action Buttons ────────────────────────────────────────────────────────
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () =>
                Navigator.popUntil(context, (route) => route.isFirst),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: primaryGreen, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Scan lagi',
              style: TextStyle(
                color: primaryGreen,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ),
        // Tampilkan tombol "Lihat Solusi" hanya jika bukan Healthy
        if (!widget.isHealthy) ...[
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SolutionScreen(
                      namaPenyakit: widget.namaPenyakit ?? 'Tidak diketahui',
                      deskripsi: widget.deskripsi,
                      penanganan: widget.penanganan,
                      penanggulangan: widget.penanggulangan,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Lihat Solusi',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

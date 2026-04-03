import 'package:flutter/material.dart';
import 'widgets/agroguard_header.dart';
import 'widgets/scan_toggle.dart';
import 'widgets/agro_info_banner.dart';
import 'kondisi_screen.dart';
import 'photo_preview_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isScanActive = true;

  static const Color primaryGreen = Color(0xFF136B53);
  static const Color bgLightGreen = Color(0xFFF4FBF5);
  static const Color iconBgLightGreen = Color(0xFFCBEAD7);

  void _onToggle(bool scanActive) {
    setState(() => isScanActive = scanActive);
    if (!scanActive) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const KondisiScreen()),
      ).then((_) => setState(() => isScanActive = true));
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
          const SizedBox(height: 32),
          Expanded(child: _buildUploadSection()),
          const SizedBox(height: 24),
          const AgroInfoBanner(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildUploadSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: CustomPaint(
        painter: _DashedBorder(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: iconBgLightGreen,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: primaryGreen,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Upload Foto Tanaman',
                style: TextStyle(
                  color: primaryGreen,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Foto daun atau hama pada tanaman\npadi atau jagung',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const PhotoPreviewScreen()),
                  );
                },
                icon: const Icon(Icons.upload_outlined, color: Colors.white),
                label: const Text(
                  'Pilih Foto',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom Painter untuk garis putus-putus (dashed border)
class _DashedBorder extends CustomPainter {
  static const Color primaryGreen = Color(0xFF136B53);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryGreen.withValues(alpha: 0.4)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(20),
      ));

    for (final metric in path.computeMetrics()) {
      double d = 0;
      bool draw = true;
      while (d < metric.length) {
        final segLen = draw ? 8.0 : 6.0;
        if (draw) {
          canvas.drawPath(metric.extractPath(d, d + segLen), paint);
        }
        d += segLen;
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

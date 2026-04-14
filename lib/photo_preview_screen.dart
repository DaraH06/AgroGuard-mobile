import 'package:flutter/material.dart';
import 'widgets/agroguard_header.dart';
import 'widgets/scan_toggle.dart';
import 'widgets/agro_info_banner.dart';
import 'result_screen.dart';

class PhotoPreviewScreen extends StatefulWidget {
  const PhotoPreviewScreen({super.key});

  @override
  State<PhotoPreviewScreen> createState() => _PhotoPreviewScreenState();
}

class _PhotoPreviewScreenState extends State<PhotoPreviewScreen> {
  bool isScanActive = true;

  static const Color primaryGreen = Color(0xFF136B53);
  static const Color bgLightGreen = Color(0xFFF4FBF5);

  void _onToggle(bool scanActive) {
    setState(() => isScanActive = scanActive);
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
          const SizedBox(height: 24),
          _buildPhotoArea(),
          const SizedBox(height: 24),
          _buildActionButtons(context),
          const SizedBox(height: 24),
          const AgroInfoBanner(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildPhotoArea() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          height: 260,
          color: Colors.green.shade300,
          child: Stack(
            children: [
              // Dummy background foto tanaman
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.green.shade400,
                      Colors.green.shade700,
                    ],
                  ),
                ),
              ),
              const Center(
                child: Icon(
                  Icons.grass,
                  size: 100,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: primaryGreen, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Foto Ulang',
                style: TextStyle(
                  color: primaryGreen,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ResultScreen(),
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
                'Analisa Foto',
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
}

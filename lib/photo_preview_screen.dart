import 'package:flutter/material.dart';
import 'widgets/agroguard_header.dart';
import 'widgets/animated_bottom_toggle.dart';
import 'widgets/agro_info_banner.dart';
import 'services/upload_service.dart';
import 'models/upload_result.dart';
import 'result_screen.dart';
import 'dart:io';

class PhotoPreviewScreen extends StatefulWidget {
  final String? imagePath;
  final double? lat;
  final double? long;
  const PhotoPreviewScreen({super.key, this.imagePath, this.lat, this.long});
  @override
  State<PhotoPreviewScreen> createState() => _PhotoPreviewScreenState();
}

class _PhotoPreviewScreenState extends State<PhotoPreviewScreen> {
  bool isScanActive = true;
  bool _isUploading = false;

  static const Color primaryGreen = Color(0xFF136B53);
  static const Color bgLightGreen = Color(0xFFF4FBF5);

  void _onToggle(bool scanActive) {
    setState(() => isScanActive = scanActive);
  }

  // Upload foto ke Laravel POST /api/upload lalu navigasi ke ResultScreen
  Future<void> _doUpload() async {
    if (widget.imagePath == null) return;

    setState(() => _isUploading = true);

    try {
      final UploadResult result = await UploadService.uploadImage(widget.imagePath!);
      if (!mounted) return;
      setState(() => _isUploading = false);

      // Navigasi ke ResultScreen dengan data analisis
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            imagePath: widget.imagePath,
            namaPenyakit: result.namaPenyakit,
            topConfidence: result.topConfidence,
            tingkatKeyakinan: result.tingkatKeyakinan,
            penanganan: result.penanganan,
            penanggulangan: result.penanggulangan,
            isHealthy: result.isHealthy,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
        ),
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
          color: Colors.black12,
          child: widget.imagePath != null
              ? Image.file(
                  File(widget.imagePath!),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Text('Gagal memuat gambar'));
                  },
                )
              : Stack(
                  children: [
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
              onPressed: _isUploading ? null : () => Navigator.pop(context),
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
              onPressed: _isUploading ? null : _doUpload,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isUploading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text(
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
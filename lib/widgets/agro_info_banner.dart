import 'package:flutter/material.dart';

class AgroInfoBanner extends StatelessWidget {
  const AgroInfoBanner({super.key});

  static const Color primaryGreen = Color(0xFF136B53);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        padding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primaryGreen.withValues(alpha: 0.3)),
        ),
        child: RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            style: TextStyle(
              color: Colors.black87,
              fontSize: 12,
              height: 1.4,
            ),
            children: [
              TextSpan(
                text: 'AgroGuard ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryGreen,
                ),
              ),
              TextSpan(
                text:
                    'menggunakan AI Deteksi penyakit atau hama pada tanaman Padi dan Jagung',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

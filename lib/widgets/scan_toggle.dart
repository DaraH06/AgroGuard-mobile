import 'package:flutter/material.dart';

class ScanToggle extends StatelessWidget {
  final bool isScanActive;
  final ValueChanged<bool> onToggle;

  static const Color primaryGreen = Color(0xFF136B53);

  const ScanToggle({
    super.key,
    required this.isScanActive,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: primaryGreen, width: 1.5),
        ),
        child: Row(
          children: [
            _buildTab(
              label: 'Scan',
              icon: Icons.document_scanner_outlined,
              isActive: isScanActive,
              onTap: () => onToggle(true),
            ),
            _buildTab(
              label: 'Kondisi sekitar',
              icon: Icons.radar_outlined,
              isActive: !isScanActive,
              onTap: () => onToggle(false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab({
    required String label,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isActive ? primaryGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isActive ? Colors.white : Colors.black54,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.black54,
                    fontWeight:
                        isActive ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

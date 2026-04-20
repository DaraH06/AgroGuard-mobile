import 'package:flutter/material.dart';

class AnimatedBottomToggle extends StatefulWidget {
  final bool isScanActive;
  final ValueChanged<bool> onToggle;

  const AnimatedBottomToggle({
    super.key,
    required this.isScanActive,
    required this.onToggle,
  });

  @override
  State<AnimatedBottomToggle> createState() => _AnimatedBottomToggleState();
}

class _AnimatedBottomToggleState extends State<AnimatedBottomToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  static const Color primaryGreen = Color(0xFF136B53);
  static const Color iconBgLightGreen = Color(0xFFCBEAD7);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    if (widget.isScanActive) {
      _controller.value = 0;
    } else {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(AnimatedBottomToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isScanActive != widget.isScanActive) {
      if (widget.isScanActive) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap(bool scanActive) {
    widget.onToggle(scanActive);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              height: 52,
              decoration: BoxDecoration(
                color: iconBgLightGreen,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  // Sliding pill indicator
                  AnimatedAlign(
                    alignment: widget.isScanActive
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOutCubic,
                    child: FractionallySizedBox(
                      widthFactor: 0.5,
                      child: Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: primaryGreen,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: primaryGreen.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Labels row
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _handleTap(true),
                          behavior: HitTestBehavior.opaque,
                          child: _buildLabel(
                            icon: Icons.document_scanner_outlined,
                            label: 'Scan Penyakit',
                            isActive: widget.isScanActive,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _handleTap(false),
                          behavior: HitTestBehavior.opaque,
                          child: _buildLabel(
                            icon: Icons.bar_chart_rounded,
                            label: 'Kondisi',
                            isActive: !widget.isScanActive,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLabel({
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      style: TextStyle(
        color: isActive ? Colors.white : primaryGreen.withValues(alpha: 0.6),
        fontSize: 13,
        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Icon(
                icon,
                key: ValueKey('${icon.codePoint}_$isActive'),
                size: 16,
                color:
                    isActive ? Colors.white : primaryGreen.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(width: 6),
            Text(label),
          ],
        ),
      ),
    );
  }
}
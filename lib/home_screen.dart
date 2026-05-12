import 'package:flutter/material.dart';
import 'widgets/agroguard_header.dart';
import 'widgets/animated_bottom_toggle.dart';
import 'widgets/agro_info_banner.dart';
import 'kondisi_screen.dart';
import 'photo_preview_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isScanActive = true;
  Key toggleKey = UniqueKey();

  static const Color primaryGreen = Color(0xFF136B53);
  static const Color bgLightGreen = Color(0xFFF4FBF5);
  static const Color iconBgLightGreen = Color(0xFFCBEAD7);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInternetWarningIfNeeded();
    });
  }

  /// Dialog peringatan internet saat pertama kali buka aplikasi
  Future<void> _showInternetWarningIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final dontShow = prefs.getBool('dontShowInternetWarning') ?? false;
    if (dontShow || !mounted) return;

    bool dontShowAgain = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          actionsPadding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgLightGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.wifi, color: primaryGreen, size: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                'Pemberitahuan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Aplikasi ini memerlukan akses internet untuk dapat berfungsi dengan baik. Pastikan perangkat Anda terhubung ke jaringan.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  setDialogState(() => dontShowAgain = !dontShowAgain);
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: dontShowAgain,
                        activeColor: primaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        onChanged: (val) {
                          setDialogState(() => dontShowAgain = val ?? false);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Jangan ingatkan lagi',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF888888),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (dontShowAgain) {
                    await prefs.setBool('dontShowInternetWarning', true);
                  }
                  if (dialogContext.mounted) Navigator.pop(dialogContext);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'OK',
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
      ),
    );
  }

  /// Cek apakah GPS aktif sebelum membuka pilihan sumber foto
  Future<void> _checkGpsAndShowImageSource() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return;
      _showGpsRequiredDialog();
      return;
    }
    _showImageSourceDialog();
  }

  /// Dialog popup ketika GPS tidak aktif
  void _showGpsRequiredDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
        actionsPadding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.location_off, color: Colors.red.shade400, size: 24),
            ),
            const SizedBox(width: 12),
            const Text(
              'GPS Tidak Aktif',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        content: const Text(
          'Mohon aktifkan lokasi Anda terlebih dahulu. Lokasi diperlukan untuk mencatat posisi pengambilan foto tanaman.',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
            height: 1.5,
          ),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: primaryGreen, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Batal',
                    style: TextStyle(
                      color: primaryGreen,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Geolocator.openLocationSettings();
                  },
                  icon: const Icon(Icons.settings, color: Colors.white, size: 18),
                  label: const Text(
                    'Aktifkan',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onToggle(bool scanActive) async {
    setState(() => isScanActive = scanActive);
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    if (!scanActive) {
      // Reset state dan paksa recreate widget di belakang layar 
      // SEBELUM navigasi agar tidak ada flicker/refresh animasi saat kembali
      setState(() {
        isScanActive = true;
        toggleKey = UniqueKey();
      });

      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              const KondisiScreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }
  }

  // Fungsi untuk menangani pengambilan gambar dari sumber tertentu
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();

    // Ambil lokasi saat ini
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Ambil foto/pilih dari galeri
    final XFile? photo = await picker.pickImage(
      source: source,
      imageQuality: 75,
      maxWidth: 1024,
      maxHeight: 1024,
    );

    if (photo != null) {
      // Kompresi foto
      final filePath = photo.path;
      final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
      final splitted = filePath.substring(0, lastIndex);
      final outPath = '${splitted}_compressed.jpg';

      var result = await FlutterImageCompress.compressAndGetFile(
        photo.path,
        outPath,
        quality: 70,
        minWidth: 1024,
        minHeight: 1024,
      );

      if (!mounted) return;
      if (result != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PhotoPreviewScreen(
              imagePath: result.path,
              lat: position.latitude,
              long: position.longitude,
            ),
          ),
        );
      }
    }
  }

  // Fungsi untuk menampilkan pilihan sumber foto
  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Ambil dari Kamera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pilih dari Galeri'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLightGreen,
      bottomNavigationBar: AnimatedBottomToggle(
        key: toggleKey,
        isScanActive: isScanActive,
        onToggle: _onToggle,
      ),
      body: Column(
        children: [
          const AgroGuardHeader(),
          const SizedBox(height: 24),
          Expanded(child: _buildUploadSection()),
          const SizedBox(height: 24),
          const AgroInfoBanner(),
          const SizedBox(height: 24),
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
                'Foto daun atau hama pada tanaman padi',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () async {
                  // Meminta izin Kamera, Lokasi, dan Galeri
                  Map<Permission, PermissionStatus> statuses = await [
                    Permission.camera,
                    Permission.location,
                    Permission.photos,
                  ].request();

                  if (statuses[Permission.camera]!.isGranted &&
                      statuses[Permission.location]!.isGranted) {
                    _checkGpsAndShowImageSource();
                  } else if (statuses[Permission.camera]!.isPermanentlyDenied ||
                      statuses[Permission.location]!.isPermanentlyDenied) {
                    openAppSettings();
                  } else {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Izin kamera dan lokasi diperlukan.'),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.camera_alt_rounded, color: Colors.white),
                label: const Text(
                  'Ambil Foto',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
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
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(20),
        ),
      );

    for (final metric in path.computeMetrics()) {
      double d = 0;
      bool draw = true;
      while (d < metric.length) {
        final segLen = draw ? 8.0 : 6.0;
        if (draw) canvas.drawPath(metric.extractPath(d, d + segLen), paint);
        d += segLen;
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

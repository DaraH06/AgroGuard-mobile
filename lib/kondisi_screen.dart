import 'package:flutter/material.dart';
import 'services/kondisi_service.dart';
import 'widgets/agroguard_header.dart';
import 'widgets/animated_bottom_toggle.dart';
import 'widgets/kondisi_detail_popup.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/// Halaman Kondisi Sekitar — menampilkan daftar kasus penyakit tanaman
/// yang dilaporkan oleh pengguna AgroGuard di berbagai daerah.
/// Data diambil dari API Laravel GET /api/kondisi yang mengakses
/// collection 'log_klasifikasi' di MongoDB.
class KondisiScreen extends StatefulWidget {
  const KondisiScreen({super.key});

  @override
  State<KondisiScreen> createState() => _KondisiScreenState();
}

class _KondisiScreenState extends State<KondisiScreen> {
  /// State toggle bottom bar — false = Kondisi aktif
  bool isScanActive = false;

  static const Color primaryGreen = Color(0xFF136B53);
  static const Color bgLightGreen = Color(0xFFF4FBF5);
  static const Color iconBgGreen = Color(0xFFD4EAE1);

  /// Data kasus penyakit yang ditampilkan di list card (semua data dari API)
  List<Map<String, String>> _allBeritaList = [];

  /// Data kasus yang sudah difilter berdasarkan penyakit yang dipilih
  List<Map<String, String>> _beritaList = [];

  /// True saat sedang loading data dari API
  bool _isLoading = true;

  /// Pesan error jika gagal fetch data
  String? _errorMessage;

  /// Nama kabupaten lokasi pengguna saat ini
  String? _currentKabupaten;

  /// Nama penyakit yang sedang difilter (null = tampilkan semua)
  String? _selectedPenyakit;

  /// Daftar nama penyakit unik untuk filter chips
  List<String> _daftarPenyakit = [];

  @override
  void initState() {
    super.initState();
    _fetchKondisi();
  }

  /// Fetch data kondisi dari API menggunakan KondisiService.
  /// Jika berhasil, simpan ke _beritaList.
  /// Jika gagal, tampilkan pesan error dengan tombol retry.
  Future<void> _fetchKondisi() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String? kabupaten;

    try {
      // Coba ambil posisi terakhir yang sudah di-cache (lebih cepat)
      Position? position = await Geolocator.getLastKnownPosition();

      // Jika tidak ada cache, ambil posisi baru dengan timeout 10 detik
      position ??= await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: const Duration(seconds: 10),
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        kabupaten = placemarks.first.subAdministrativeArea;
        if (kabupaten != null && kabupaten.startsWith('Kabupaten ')) {
          kabupaten = kabupaten.replaceFirst('Kabupaten ', '');
        }
        if (kabupaten != null && kabupaten.startsWith('Kota ')) {
          kabupaten = kabupaten.replaceFirst('Kota ', '');
        }
        _currentKabupaten = kabupaten;
      }
    } catch (e) {
      debugPrint("Gagal dapat lokasi kondisi: $e");
      // Jika gagal dapat lokasi, tetap lanjut ambil semua data (tanpa filter)
    }

    try {
      final data = await KondisiService.fetchKondisi(kabupaten: kabupaten);
      if (!mounted) return;

      // Ambil daftar nama penyakit unik untuk filter chips
      final penyakitSet = <String>{};
      for (var item in data) {
        final nama = item['hama'] ?? '';
        if (nama.isNotEmpty && nama != '-') penyakitSet.add(nama);
      }

      setState(() {
        _allBeritaList = data;
        _beritaList = data;
        _daftarPenyakit = penyakitSet.toList()..sort();
        _selectedPenyakit = null;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Tidak dapat terhubung ke server.';
      });
    }
  }

  /// Callback dari AnimatedBottomToggle.
  /// Jika toggle ke "Scan" → kembali ke HomeScreen (pop).
  void _onToggle(bool scanActive) async {
    setState(() => isScanActive = scanActive);
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    if (scanActive) {
      Navigator.pop(context);
    }
  }

  /// Tampilkan popup detail (bottom sheet) ketika salah satu card dipencet.
  /// Popup menampilkan gambar, nama penyakit, lokasi, jumlah kasus, dll.
  void _showDetailPopup(Map<String, String> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => KondisiDetailPopup(item: item),
    );
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
          _buildInfoBanner(),
          const SizedBox(height: 10),
          if (!_isLoading && _daftarPenyakit.isNotEmpty) _buildFilterChips(),
          const SizedBox(height: 10),
          Expanded(child: _buildContent()),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// Menentukan konten utama berdasarkan state:
  /// - Loading → spinner
  /// - Error → pesan error + tombol "Coba Lagi"
  /// - Kosong → teks "Belum ada laporan"
  /// - Ada data → tampilkan list card
  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: primaryGreen),
      );
    }
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cloud_off_rounded, size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() { _isLoading = true; _errorMessage = null; });
                  _fetchKondisi();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }
    if (_beritaList.isEmpty) {
      return Center(
        child: Text(
          'Belum ada laporan kasus penyakit.',
          style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
        ),
      );
    }
    return _buildNewsList();
  }

  /// Banner info di bagian atas — menampilkan teks "Pemberitahuan Penyakit & Hama"
  /// dengan ikon trending up untuk memberi konteks ke user.
  Widget _buildInfoBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: iconBgGreen,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: primaryGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.trending_up_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pemberitahuan Penyakit Disekitar',
                    style: TextStyle(
                      color: primaryGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _currentKabupaten != null 
                        ? 'Pantau kondisi di wilayah $_currentKabupaten.'
                        : 'Pantau kondisi di wilayah Anda.',
                    style: const TextStyle(color: primaryGreen, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Filter chips horizontal — user bisa pilih penyakit mana yang ditampilkan.
  /// Chip "Semua" untuk reset filter, sisanya per nama penyakit.
  Widget _buildFilterChips() {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          // Chip "Semua" untuk menampilkan semua penyakit
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: const Text('Semua'),
              selected: _selectedPenyakit == null,
              onSelected: (_) => _applyFilter(null),
              selectedColor: primaryGreen,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: _selectedPenyakit == null ? Colors.white : primaryGreen,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: primaryGreen, width: 1),
              ),
              showCheckmark: false,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          ),
          // Chip per nama penyakit
          ..._daftarPenyakit.map((nama) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(nama),
              selected: _selectedPenyakit == nama,
              onSelected: (_) => _applyFilter(nama),
              selectedColor: primaryGreen,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: _selectedPenyakit == nama ? Colors.white : primaryGreen,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: primaryGreen, width: 1),
              ),
              showCheckmark: false,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          )),
        ],
      ),
    );
  }

  /// Terapkan filter berdasarkan nama penyakit yang dipilih.
  /// Jika null, tampilkan semua data.
  void _applyFilter(String? penyakit) {
    setState(() {
      _selectedPenyakit = penyakit;
      if (penyakit == null) {
        _beritaList = _allBeritaList;
      } else {
        _beritaList = _allBeritaList
            .where((item) => item['hama'] == penyakit)
            .toList();
      }
    });
  }

  /// ListView scrollable berisi card-card kasus penyakit.
  /// Setiap card bisa dipencet untuk menampilkan popup detail.
  Widget _buildNewsList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: _beritaList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = _beritaList[index];
        return GestureDetector(
          onTap: () => _showDetailPopup(item),
          child: _buildNewsCard(item),
        );
      },
    );
  }

  /// Card individual berisi: thumbnail penyakit, judul, lokasi, nama hama,
  /// jumlah kasus, tanggal terakhir, dan ikon chevron sebagai hint tap.
  Widget _buildNewsCard(Map<String, String> item) {
    return Container(
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
      child: Row(
        children: [
          // Thumbnail gambar penyakit di sisi kiri card
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Container(
              width: 100,
              height: 100,
              color: Colors.green.shade200,
              child: item['thumbnail_url'] != null && item['thumbnail_url']!.isNotEmpty
                  ? Image.network(
                      item['thumbnail_url']!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.grass, color: Colors.green, size: 48),
                    )
                  : const Icon(Icons.grass, color: Colors.green, size: 48),
            ),
          ),
          const SizedBox(width: 12),
          // Info teks: judul, lokasi, hama, kasus, tanggal
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['judul']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildDetail(Icons.location_on_outlined, item['lokasi']!),
                  _buildDetail(Icons.bug_report_outlined, item['hama']!),
                  _buildDetail(Icons.monitor_heart_outlined, item['kasus']!),
                  _buildDetail(Icons.calendar_today_outlined, item['tanggal']!),
                ],
              ),
            ),
          ),
          // Ikon chevron (>) sebagai hint bahwa card bisa dipencet
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey.shade400,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  /// Baris kecil berisi ikon + teks — digunakan untuk detail di dalam card
  /// (lokasi, nama hama, jumlah kasus, tanggal).
  Widget _buildDetail(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        children: [
          Icon(icon, size: 12, color: Colors.grey.shade500),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
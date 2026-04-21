import 'package:flutter/material.dart';
import 'widgets/agroguard_header.dart';
import 'widgets/animated_bottom_toggle.dart';

class SolutionScreen extends StatefulWidget {
  const SolutionScreen({super.key});

  @override
  State<SolutionScreen> createState() => _SolutionScreenState();
}

class _SolutionScreenState extends State<SolutionScreen> {
  bool isScanActive = true;
  int _selectedTab = 0; // 0: Penanganan, 1: Pencegahan, 2: Tips

  static const Color primaryGreen = Color(0xFF136B53);
  static const Color bgLightGreen = Color(0xFFF4FBF5);
  static const Color cardBg = Color(0xFFEAF5EE);

  void _onToggle(bool scanActive) {
    setState(() => isScanActive = scanActive);
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
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Solusi untuk Hawar Daun Bakteri',
                  style: TextStyle(
                    color: primaryGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 4),
                Text(
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

  // ── Tab bar: Penanganan / Pencegahan / Tips ─────────────────────────────────
  Widget _buildTabBar() {
    const tabs = ['Penanganan', 'Pencegahan', 'Tips'];
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
        return _buildPenanganan();
      case 1:
        return _buildPencegahan();
      case 2:
        return _buildTips();
      default:
        return const SizedBox.shrink();
    }
  }

  // ── PENANGANAN ──────────────────────────────────────────────────────────────
  Widget _buildPenanganan() {
    return Column(
      children: [
        _buildSolutionCard(
          icon: '🌿',
          title: 'Penggunaan Pestisida Organik',
          description:
              'Semprotkan pestisida organik berbahan neem oil atau ekstrak bawang putih pada area yang terinfeksi.',
          steps: [
            RichText(
              text: const TextSpan(
                style: TextStyle(color: Colors.black87, fontSize: 13, height: 1.4),
                children: [
                  TextSpan(text: 'Campurkan '),
                  TextSpan(
                    text: '2 sendok makan neem oil ',
                    style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: 'dengan 1 liter air'),
                ],
              ),
            ),
            RichText(
              text: const TextSpan(
                style: TextStyle(color: Colors.black87, fontSize: 13, height: 1.4),
                children: [
                  TextSpan(text: 'Tambahkan '),
                  TextSpan(
                    text: '1 tetes sabun cuci piring ',
                    style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: 'sebagai perata'),
                ],
              ),
            ),
            RichText(
              text: const TextSpan(
                style: TextStyle(color: Colors.black87, fontSize: 13, height: 1.4),
                children: [
                  TextSpan(text: 'Semprotkan pada '),
                  TextSpan(
                    text: 'pagi atau sore hari',
                    style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            RichText(
              text: const TextSpan(
                style: TextStyle(color: Colors.black87, fontSize: 13, height: 1.4),
                children: [
                  TextSpan(text: 'Ulangi setiap '),
                  TextSpan(
                    text: '3–5 hari ',
                    style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: 'sampai hama berkurang'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSolutionCard(
          icon: '💊',
          title: 'Bakterisida Kimia',
          description:
              'Jika serangan sudah parah, gunakan bakterisida berbahan aktif streptomisin sulfat atau tembaga hidroksida.',
          steps: [
            _plainStep('Larutkan bakterisida sesuai dosis pada label kemasan'),
            _plainStep('Semprotkan merata ke seluruh bagian tanaman yang terinfeksi'),
            _plainStep('Hindari penyemprotan saat hujan atau terik matahari'),
          ],
        ),
      ],
    );
  }

  // ── PENCEGAHAN ──────────────────────────────────────────────────────────────
  Widget _buildPencegahan() {
    return Column(
      children: [
        _buildSolutionCard(
          icon: '🛡️',
          title: 'Sanitasi Lahan',
          description:
              'Bersihkan sisa tanaman yang terinfeksi dan musnahkan agar bakteri tidak menyebar ke tanaman sehat.',
          steps: [
            _plainStep('Cabut dan bakar tanaman yang sudah sangat terinfeksi'),
            _plainStep('Bersihkan gulma di sekitar area tanam secara rutin'),
            _plainStep('Jangan biarkan air menggenang di lahan tanam'),
          ],
        ),
        const SizedBox(height: 16),
        _buildSolutionCard(
          icon: '🌱',
          title: 'Varietas Tahan Penyakit',
          description:
              'Gunakan benih varietas padi yang memiliki ketahanan tinggi terhadap hawar daun bakteri (HDB).',
          steps: [
            RichText(
              text: const TextSpan(
                style: TextStyle(color: Colors.black87, fontSize: 13, height: 1.4),
                children: [
                  TextSpan(text: 'Pilih varietas tahan seperti '),
                  TextSpan(
                    text: 'IR64, Ciherang, atau Inpari',
                    style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            _plainStep('Beli benih bersertifikat dari toko pertanian resmi'),
            _plainStep('Rendam benih dalam air hangat sebelum semai untuk eliminasi patogen'),
          ],
        ),
        const SizedBox(height: 16),
        _buildSolutionCard(
          icon: '💧',
          title: 'Manajemen Air',
          description:
              'Atur irigasi dengan baik karena bakteri hawar daun mudah menyebar melalui percikan air.',
          steps: [
            _plainStep('Hindari irigasi berlebihan yang menyebabkan genangan'),
            _plainStep('Gunakan sistem irigasi tetes jika memungkinkan'),
            _plainStep('Pastikan saluran drainase berfungsi dengan baik'),
          ],
        ),
      ],
    );
  }

  // ── TIPS ────────────────────────────────────────────────────────────────────
  Widget _buildTips() {
    return Column(
      children: [
        _buildSolutionCard(
          icon: '📅',
          title: 'Jadwal Perawatan Rutin',
          description:
              'Perawatan yang konsisten akan menjaga kesehatan tanaman dan mencegah serangan penyakit berulang.',
          steps: [
            RichText(
              text: const TextSpan(
                style: TextStyle(color: Colors.black87, fontSize: 13, height: 1.4),
                children: [
                  TextSpan(
                    text: 'Setiap minggu: ',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: 'Periksa kondisi daun dan batang secara visual'),
                ],
              ),
            ),
            RichText(
              text: const TextSpan(
                style: TextStyle(color: Colors.black87, fontSize: 13, height: 1.4),
                children: [
                  TextSpan(
                    text: 'Setiap 2 minggu: ',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: 'Berikan pupuk nitrogen sesuai dosis'),
                ],
              ),
            ),
            RichText(
              text: const TextSpan(
                style: TextStyle(color: Colors.black87, fontSize: 13, height: 1.4),
                children: [
                  TextSpan(
                    text: 'Setiap bulan: ',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: 'Lakukan penyemprotan pestisida preventif'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSolutionCard(
          icon: '🔬',
          title: 'Pemupukan yang Tepat',
          description:
              'Tanaman yang mendapat nutrisi seimbang memiliki daya tahan lebih baik terhadap serangan penyakit.',
          steps: [
            _plainStep('Hindari pemberian nitrogen berlebihan yang melemahkan dinding sel'),
            _plainStep('Tambahkan kalium (K) untuk memperkuat ketahanan tanaman'),
            _plainStep('Gunakan pupuk organik kompos untuk memperbaiki struktur tanah'),
          ],
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          icon: Icons.lightbulb_outline_rounded,
          title: 'Tahukah Kamu?',
          content:
              'Hawar daun bakteri (Xanthomonas oryzae pv. oryzae) paling aktif pada suhu 25–30°C dengan kelembapan tinggi. Pemantauan rutin di musim hujan sangat dianjurkan untuk deteksi dini.',
        ),
      ],
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  Widget _plainStep(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 13,
        height: 1.4,
      ),
    );
  }

  Widget _buildSolutionCard({
    required String icon,
    required String title,
    required String description,
    required List<Widget> steps,
  }) {
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
          // Judul kartu
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
          const SizedBox(height: 10),
          // Deskripsi
          Text(
            description,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          // Langkah-langkah
          const Text(
            'Langkah-langkah:',
            style: TextStyle(
              color: primaryGreen,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          ...steps.asMap().entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        margin: const EdgeInsets.only(right: 10, top: 1),
                        decoration: BoxDecoration(
                          color: primaryGreen,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            '${entry.key + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: entry.value),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF5EE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryGreen.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primaryGreen, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: primaryGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  content,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class KondisiService {
  static final String _host =
      '${dotenv.env['IP_ADDRESS']}:${dotenv.env['PORT']}';
  static final String _baseUrl = 'http://$_host/api';

  /// Ambil data kondisi penyakit dari Laravel GET /api/kondisi
  /// Jika [kabupaten] diisi, data akan difilter hanya untuk kabupaten tersebut.
  static Future<List<Map<String, String>>> fetchKondisi({String? kabupaten}) async {
    var urlStr = '$_baseUrl/kondisi';
    if (kabupaten != null && kabupaten.isNotEmpty) {
      urlStr += '?kabupaten=${Uri.encodeComponent(kabupaten)}';
    }
    
    final url = Uri.parse(urlStr);

    final response = await http.get(url).timeout(
      const Duration(seconds: 15),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['success'] == true && body['data'] != null) {
        final List<dynamic> dataList = body['data'];
        return dataList.map<Map<String, String>>((item) {
          return {
            'judul': '${item['nama_penyakit'] ?? '-'} di ${item['kecamatan'] ?? '-'}',
            'lokasi': '${item['kecamatan']}, ${item['kabupaten']}',
            'hama': item['nama_penyakit'] ?? '-',
            'kasus': '${item['jumlah_kasus']} kasus',
            'tanggal': item['terakhir'] ?? '-',
            'kecamatan': item['kecamatan'] ?? '-',
            'thumbnail_url': item['thumbnail_url'] ?? '',
          };
        }).toList();
      }
    }

    throw Exception('Gagal mengambil data (${response.statusCode})');
  }
}

import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/upload_result.dart';

class UploadService {
  static final String _host =
      '${dotenv.env['IP_ADDRESS']}:${dotenv.env['PORT']}';
  static final String _baseUrl = 'http://$_host/api';

  /// Upload gambar ke Laravel POST /api/upload
  /// Field multipart: 'image'
  static Future<UploadResult> uploadImage(
    String filePath, {
    String? provinsi,
    String? kabupaten,
    String? kecamatan,
    double? latitude,
    double? longitude,
  }) async {
    final uri = Uri.parse('$_baseUrl/upload');
    final request = http.MultipartRequest('POST', uri);

    request.files.add(await http.MultipartFile.fromPath('image', filePath));
    if (provinsi != null) request.fields['provinsi'] = provinsi;
    if (kabupaten != null) request.fields['kabupaten'] = kabupaten;
    if (kecamatan != null) request.fields['kecamatan'] = kecamatan;
    if (latitude != null) request.fields['latitude'] = latitude.toString();
    if (longitude != null) request.fields['longitude'] = longitude.toString();
    request.headers['Accept'] = 'application/json';

    try {
      final streamed = await request.send().timeout(
        const Duration(seconds: 20),
        onTimeout: () => throw Exception(
          'Request timeout — pastikan Laravel server berjalan di $_host',
        ),
      );

      final response = await http.Response.fromStream(streamed);
      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201 && body['success'] == true) {
        return UploadResult.fromJson(body);
      } else {
        final message = body['message']?.toString() ?? 'Upload gagal';
        final error = body['error']?.toString();
        final errors = body['errors']?.toString();
        final detail = error ?? errors;
        throw Exception(detail != null ? '$message: $detail' : message);
      }
    } on SocketException {
      throw Exception(
        'Tidak dapat terhubung ke server. Pastikan Laravel berjalan di $_host',
      );
    } on FormatException {
      throw Exception('Respons dari server tidak valid');
    }
  }
}

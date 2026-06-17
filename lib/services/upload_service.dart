import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/upload_result.dart';

class UploadService {
  static final String _host =
      '${dotenv.env['IP_ADDRESS']}:${dotenv.env['PORT']}';
  static final String _baseUrl = 'http://agroguard-admin.my.id/api';

  /// Upload gambar ke Laravel POST /api/upload
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
        onTimeout: () => throw TimeoutException(
          'Koneksi internet terlalu lambat. Coba lagi dengan sinyal yang lebih baik.',
        ),
      );

      final response = await http.Response.fromStream(streamed);

      debugPrint('Upload response status: ${response.statusCode}');
      debugPrint('Upload response body: ${response.body}');

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201 && body['success'] == true) {
        return UploadResult.fromJson(body);
      } else {
        final message = body['message']?.toString() ?? 'Upload gagal';
        final error = body['error']?.toString() ?? body['errors']?.toString();
        throw Exception(error != null ? '$message: $error' : message);
      }
    } on TimeoutException catch (e) {
      throw Exception(e.message); // Pesan timeout yang user-friendly
    } on SocketException {
      throw Exception(
        'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.',
      );
    } on FormatException catch (e) {
      debugPrint('FormatException saat parse response: $e');
      throw Exception('Respons dari server tidak valid');
    } catch (e) {
      debugPrint('Upload error: ${e.runtimeType} - $e');
      throw Exception('Terjadi kesalahan tidak terduga: ${e.toString()}');
    }
  }
}

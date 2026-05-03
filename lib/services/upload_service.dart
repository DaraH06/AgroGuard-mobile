import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/upload_result.dart';

class UploadService {
  // Same WiFi — jalankan: php artisan serve --host=0.0.0.0 --port=8000
  // Physical device via ADB — ganti ke: localhost:8000 + adb reverse tcp:8000 tcp:8000
  // Emulator Android       — ganti ke: 10.0.2.2:8000
  static const String _host = '192.168.1.53:8000';
  static const String _baseUrl = 'http://$_host/api';

  /// Upload gambar ke Laravel POST /api/upload
  /// Field multipart: 'image'
  static Future<UploadResult> uploadImage(String filePath) async {
    final uri = Uri.parse('$_baseUrl/upload');
    final request = http.MultipartRequest('POST', uri);

    request.files.add(await http.MultipartFile.fromPath('image', filePath));
    request.headers['Accept'] = 'application/json';

    try {
      final streamed = await request.send().timeout(
        const Duration(seconds: 30),
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
        final errors = body['errors'];
        throw Exception(errors != null ? '$message: $errors' : message);
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

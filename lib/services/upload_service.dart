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
  static Future<UploadResult> uploadImage(String filePath) async {
    final uri = Uri.parse('$_baseUrl/upload');
    final request = http.MultipartRequest('POST', uri);

    request.files.add(await http.MultipartFile.fromPath('image', filePath));
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

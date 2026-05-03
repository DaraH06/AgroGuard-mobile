import 'package:flutter/foundation.dart';

class UploadResult {
  final List hasil;

  UploadResult({
    required this.hasil,
  });

  factory UploadResult.fromJson(Map<String, dynamic> json) {
    debugPrint("Struktur JSON : $json");
    debugPrint("Isi kunci 'data': ${json['data']}");

    // Handle both List and Map responses
    final data = json['data'] ?? json['hasil'];
    List hasil = [];
    
    if (data is List) {
      hasil = data;
    } else if (data is Map) {
      hasil = [data];
    }

    return UploadResult(
      hasil: hasil,
    );
  }
}

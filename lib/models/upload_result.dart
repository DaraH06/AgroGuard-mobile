import 'package:flutter/foundation.dart';

class UploadResult {
  final List hasil;
  final Map<String, dynamic>? extraction;

  UploadResult({
    required this.hasil,
    this.extraction,
  });

  factory UploadResult.fromJson(Map<String, dynamic> json) {
    debugPrint("Struktur JSON : $json");
    debugPrint("Isi kunci 'data': ${json['data']}");
    debugPrint("Isi kunci 'extraction': ${json['extraction']}");

    // Handle both List and Map responses for main data
    final data = json['data'] ?? json['hasil'];
    List hasil = [];

    if (data is List) {
      hasil = data;
    } else if (data is Map) {
      hasil = [data];
    }

    // Extraction can be a Map (from Flask) or null
    Map<String, dynamic>? extraction;
    if (json['extraction'] != null && json['extraction'] is Map) {
      extraction = Map<String, dynamic>.from(json['extraction']);
    }

    return UploadResult(
      hasil: hasil,
      extraction: extraction,
    );
  }
}

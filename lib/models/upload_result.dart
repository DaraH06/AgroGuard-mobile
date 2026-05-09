import 'package:flutter/foundation.dart';

class UploadResult {
  final List hasil;
  final Map<String, dynamic>? extraction;

  // Parsed analysis fields from extraction
  final String? namaPenyakit;
  final List<String> deskripsi;
  final List<String> penanganan;
  final List<String> penanggulangan;
  final Map<String, String> tingkatKeyakinan;

  UploadResult({
    required this.hasil,
    this.extraction,
    this.namaPenyakit,
    this.deskripsi = const [],
    this.penanganan = const [],
    this.penanggulangan = const [],
    this.tingkatKeyakinan = const {},
  });

  /// Confidence tertinggi (nilai pertama dari sorted map)
  String get topConfidence {
    if (tingkatKeyakinan.isEmpty) return '0%';
    return tingkatKeyakinan.values.first;
  }

  /// Nama penyakit dari confidence tertinggi
  String get topDiseaseName {
    if (tingkatKeyakinan.isEmpty) return namaPenyakit ?? 'Unknown';
    return tingkatKeyakinan.keys.first;
  }

  /// Cek apakah tanaman sehat
  bool get isHealthy =>
      namaPenyakit?.toLowerCase() == 'healthy' ||
      topDiseaseName.toLowerCase() == 'healthy';

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

    // Parse extraction (analysis result from Flask → Laravel)
    Map<String, dynamic>? extraction;
    String? namaPenyakit;
    List<String> deskripsi = [];
    List<String> penanganan = [];
    List<String> penanggulangan = [];
    Map<String, String> tingkatKeyakinan = {};

    if (json['extraction'] != null && json['extraction'] is Map) {
      extraction = Map<String, dynamic>.from(json['extraction']);

      // Parse "hasil" object — contains nama_penyakit, penanganan, penanggulangan
      final hasilAnalisis = extraction['hasil'];
      if (hasilAnalisis != null && hasilAnalisis is Map) {
        namaPenyakit = hasilAnalisis['nama_penyakit']?.toString();

        if (hasilAnalisis['deskripsi'] is List) {
          deskripsi = List<String>.from(
            (hasilAnalisis['deskripsi'] as List).map((e) => e.toString()),
          );
        }

        if (hasilAnalisis['penanganan'] is List) {
          penanganan = List<String>.from(
            (hasilAnalisis['penanganan'] as List).map((e) => e.toString()),
          );
        }

        if (hasilAnalisis['penanggulangan'] is List) {
          penanggulangan = List<String>.from(
            (hasilAnalisis['penanggulangan'] as List).map((e) => e.toString()),
          );
        }
      }

      // Parse "tingkat keyakinan" map — e.g. {"Leaf Blast": "40.00%", "Healthy": "60.00%"}
      final keyakinan = extraction['tingkat keyakinan'];
      if (keyakinan != null && keyakinan is Map) {
        tingkatKeyakinan = Map<String, String>.from(
          keyakinan.map((k, v) => MapEntry(k.toString(), v.toString())),
        );
      }
    }

    debugPrint("Parsed namaPenyakit: $namaPenyakit");
    debugPrint("Parsed tingkatKeyakinan: $tingkatKeyakinan");

    return UploadResult(
      hasil: hasil,
      extraction: extraction,
      namaPenyakit: namaPenyakit,
      deskripsi: deskripsi,
      penanganan: penanganan,
      penanggulangan: penanggulangan,
      tingkatKeyakinan: tingkatKeyakinan,
    );
  }
}

class UploadResult {
  final String id;
  final String imagePath;
  final String imageUrl;
  final String originalFilename;
  final int fileSize;
  final DateTime uploadedAt;

  UploadResult({
    required this.id,
    required this.imagePath,
    required this.imageUrl,
    required this.originalFilename,
    required this.fileSize,
    required this.uploadedAt,
  });

  factory UploadResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return UploadResult(
      id: data['id']?.toString() ?? '',
      imagePath: data['image_path']?.toString() ?? '',
      imageUrl: data['image_url']?.toString() ?? '',
      originalFilename: data['original_filename']?.toString() ?? '',
      fileSize: (data['file_size'] as num?)?.toInt() ?? 0,
      uploadedAt: data['uploaded_at'] != null
          ? DateTime.tryParse(data['uploaded_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  String get fileSizeFormatted {
    if (fileSize < 1024) return '$fileSize B';
    if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    }
    return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

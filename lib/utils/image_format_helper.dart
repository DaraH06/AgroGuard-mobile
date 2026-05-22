bool isPngImage({required String path, String? mimeType}) {
  final lower = path.toLowerCase();
  if (lower.endsWith('.png')) return true;
  if (mimeType != null && mimeType.toLowerCase() == 'image/png') return true;
  return false;
}

const String kPngNotSupportedMessage =
    'Tidak dapat mengirim gambar dengan format png. Coba kirim gambar lain.';

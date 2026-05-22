import 'package:flutter_test/flutter_test.dart';
import 'package:agrouardmobile/utils/image_format_helper.dart';

void main() {
  group('isPngImage', () {
    test('detects .png extension case-insensitively', () {
      expect(isPngImage(path: '/tmp/photo.PNG'), isTrue);
      expect(isPngImage(path: '/tmp/photo.png'), isTrue);
    });

    test('detects image/png mime type', () {
      expect(
        isPngImage(path: '/tmp/photo', mimeType: 'image/png'),
        isTrue,
      );
    });

    test('returns false for jpeg', () {
      expect(isPngImage(path: '/tmp/photo.jpg', mimeType: 'image/jpeg'), isFalse);
      expect(isPngImage(path: '/tmp/photo.jpeg'), isFalse);
    });
  });
}

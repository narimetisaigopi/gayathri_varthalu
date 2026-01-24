import 'package:http/http.dart' as http;

class YoutubeUtils {
  /// Returns a full YouTube video URL for a given video ID.
  static String videoUrlFromId(String videoId) {
    return 'https://www.youtube.com/watch?v=$videoId';
  }

  /// Returns a YouTube short URL for a given video ID.
  static String shortUrlFromId(String videoId) {
    return 'https://youtu.be/$videoId';
  }

  /// Improved extraction of YouTube video ID from various URL formats.
  static String? extractVideoId(String url) {
    // Try to match common YouTube URL patterns
    final patterns = [
      RegExp(r'youtu\.be\/([\w-]{11})'),
      RegExp(
          r'youtube\.com\/(?:embed\/|v\/|watch\?v=|watch\?.+&v=)([\w-]{11})'),
    ];
    for (final pattern in patterns) {
      final match = pattern.firstMatch(url);
      if (match != null && match.groupCount >= 1) {
        return match.group(1);
      }
    }
    return null;
  }

  /// Returns the YouTube thumbnail URL for a given video ID, checking from higher to lower resolution.
  static Future<String> getYoutubeThumbnail(String videoId) async {
    final baseUrl = 'https://img.youtube.com/vi/$videoId';

    // Preferred order of resolutions
    final resolutions = [
      'maxresdefault.jpg',
      'sddefault.jpg',
      'hqdefault.jpg',
      'mqdefault.jpg',
      'default.jpg',
    ];

    for (final res in resolutions) {
      final url = '$baseUrl/$res';
      final response = await http.head(Uri.parse(url));

      if (response.statusCode == 200) {
        return url; // ✅ First available thumbnail
      }
    }

    // Should never reach here, but just in case
    return '$baseUrl/default.jpg';
  }

  /// Returns a low-resolution YouTube thumbnail URL for a given video URL.
  static String getYoutubeThumbnailSync(String url, {bool highQuality = true}) {
    final videoId = extractVideoId(url);
    final baseUrl = 'https://img.youtube.com/vi/$videoId';

    if (highQuality) {
      // Try maximum resolution thumbnail first
      return '$baseUrl/maxresdefault.jpg';
    } else {
      // Fallback to a more reliable resolution
      return '$baseUrl/hqdefault.jpg';
    }
  }
}

import 'package:intl/intl.dart';

class FacebookCommentFormatter {
  static String formatTimestamp(String timestampString) {
    final timestamp = DateTime.parse(timestampString);
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference < const Duration(minutes: 1)) {
      return 'Just now';
    } else if (difference < const Duration(hours: 1)) {
      final minutes = difference.inMinutes;
      return '$minutes min ago';
    } else if (difference < const Duration(days: 1)) {
      final hours = difference.inHours;
      return '$hours h ago';
    } else if (difference < const Duration(days: 7)) {
      final days = difference.inDays;
      return '$days d ago';
    } else {
      final formatter = DateFormat.yMMMMd();
      return formatter.format(timestamp);
    }
  }
}
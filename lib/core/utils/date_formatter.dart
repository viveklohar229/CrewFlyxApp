/// Clean date formatting helpers tailored for aviation schedules and UTC/Local timestamps.
class DateFormatter {
  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  static const List<String> _fullMonths = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  static const List<String> _weekdays = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
  ];

  /// Example: "17 Aug 2026"
  static String formatShortDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')} ${_months[date.month - 1]} ${date.year}';
  }

  /// Example: "Mon, 17 Aug"
  static String formatDayDate(DateTime date) {
    final weekday = _weekdays[date.weekday - 1];
    return '$weekday, ${date.day} ${_months[date.month - 1]}';
  }

  /// Example: "08:30 AM"
  static String formatTime(DateTime date) {
    final hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final formattedHour = (hour % 12 == 0 ? 12 : hour % 12).toString().padLeft(2, '0');
    return '$formattedHour:$minute $period';
  }

  /// Example: "08:30" (24H Aviation Format)
  static String formatTime24(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  /// Example: "17 Aug 2026, 08:30 AM"
  static String formatDateTime(DateTime date) {
    return '${formatShortDate(date)}, ${formatTime(date)}';
  }

  /// Example: "2 hours ago" or "Yesterday"
  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return formatShortDate(date);
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  /// Example: "August 2026"
  static String formatMonthYear(DateTime date) {
    return '${_fullMonths[date.month - 1]} ${date.year}';
  }
}

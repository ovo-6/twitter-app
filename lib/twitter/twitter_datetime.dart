import 'package:intl/intl.dart';

class TwitterDateTime {

  static final DateFormat df = new DateFormat("E MMM dd HH:mm:ss yyyy");
  static final Pattern exp = new RegExp("(.*)([+-]\\d{4})\\s(.*)");

  static final DateFormat outLongDf = new DateFormat("d MMM yyyy");
  static final DateFormat outShortDf = new DateFormat("MMM d");

  DateTime parse(String dateStr) {

    String timezoneStr = '';

    Iterable<Match> matches = exp.allMatches(dateStr);
    for (Match m in matches) {
      String before = m.group(1);
      timezoneStr = m.group(2);
      String after = m.group(3);
      dateStr = before + after;
    }

    DateTime created = df.parse(dateStr);
    String dateOutStr = created.toIso8601String() + timezoneStr;
    return DateTime.parse(dateOutStr);
  }

  String formatAsDifference(DateTime datetime, DateTime now) {
    Duration difference = now.difference(datetime);

    if (difference.inMinutes < 2) {
      return "Now";
    }

    if (difference.inHours < 1) {
      return difference.inMinutes.toString() + "m";
    }

    if (difference.inDays < 1) {
      return difference.inHours.toString() + "h";
    }

    if (datetime.year == now.year) {
      return outShortDf.format(datetime);
    }


    return outLongDf.format(datetime);
  }
}
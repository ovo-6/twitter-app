import 'package:twitter_app/twitter/twitter_datetime.dart';
import 'package:test/test.dart';

void main() {
  TwitterDateTime twitterDateTime = new TwitterDateTime();

  test('parse utc', () {
    DateTime answer = twitterDateTime.parse("Fri Dec 29 10:02:04 +0000 2017");
    expect(answer, DateTime.parse("2017-12-29 10:02:04.000Z"));
  });

  test('parse minus 1 hour 30 min', () {
    DateTime answer = twitterDateTime.parse("Fri Dec 29 10:02:04 -0130 2017");
    expect(answer, DateTime.parse("2017-12-29 11:32:04.000Z"));
  });

  test('format 30s', () {
    DateTime datetime = DateTime.parse("2017-12-29 11:32:04.000Z");
    DateTime now = DateTime.parse("2017-12-29 11:32:34.000Z");

    String answer = twitterDateTime.formatAsDifference(datetime, now);
    expect(answer, "Now");
  });

  test('format 2min', () {
    DateTime datetime = DateTime.parse("2017-12-29 11:32:04.000Z");
    DateTime now = DateTime.parse("2017-12-29 11:34:34.000Z");

    String answer = twitterDateTime.formatAsDifference(datetime, now);
    expect(answer, "2m");
  });

  test('format 5 hours', () {
    DateTime datetime = DateTime.parse("2017-12-29 11:32:04.000Z");
    DateTime now = DateTime.parse("2017-12-29 16:34:34.000Z");

    String answer = twitterDateTime.formatAsDifference(datetime, now);
    expect(answer, "5h");
  });

  test('format 2 days', () {
    DateTime datetime = DateTime.parse("2017-12-29 11:32:04.000Z");
    DateTime now = DateTime.parse("2017-12-31 16:34:34.000Z");

    String answer = twitterDateTime.formatAsDifference(datetime, now);
    expect(answer, "Dec 29");
  });

  test('format 1 year', () {
    DateTime datetime = DateTime.parse("2017-12-29 11:32:04.000Z");
    DateTime now = DateTime.parse("2018-01-01 16:34:34.000Z");

    String answer = twitterDateTime.formatAsDifference(datetime, now);
    expect(answer, "29 Dec 2017");
  });
}
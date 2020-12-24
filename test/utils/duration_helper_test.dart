import 'package:accelerometer/utils/duration_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('duration to string', () {
    test('none', () {
      var dur = Duration(milliseconds: 0);
      var str = durationToString(duration: dur);
      expect(str, '-ms');
    });
    test('ms', () {
      var dur = Duration(milliseconds: 1);
      var str = durationToString(duration: dur);
      expect(str, '1msec');
    });
    test('sec', () {
      var dur = Duration(seconds: 1);
      var str = durationToString(duration: dur);
      expect(str, '1sec');
    });
    test('min', () {
      var dur = Duration(minutes: 1);
      var str = durationToString(duration: dur);
      expect(str, '1min');
    });
    test('hr', () {
      var dur = Duration(hours: 1);
      var str = durationToString(duration: dur);
      expect(str, '1hr');
    });
    test('day', () {
      var dur = Duration(days: 1);
      var str = durationToString(duration: dur);
      expect(str, '1day');
    });
    test('day + hr', () {
      var dur = Duration(days: 1, hours: 1);
      var str = durationToString(duration: dur);
      expect(str, '1day 1hr');
    });
    test('hr + min', () {
      var dur = Duration(hours: 1, minutes: 1);
      var str = durationToString(duration: dur);
      expect(str, '1hr 1min');
    });
    test('min + sec', () {
      var dur = Duration(minutes: 1, seconds: 1);
      var str = durationToString(duration: dur);
      expect(str, '1min 1sec');
    });
    test('sec + msec', () {
      var dur = Duration(seconds: 1, milliseconds: 1);
      var str = durationToString(duration: dur);
      expect(str, '1sec 1msec');
    });
    test('day + hr + min', () {
      var dur = Duration(days: 1, hours: 1, minutes: 1);
      var str = durationToString(duration: dur);
      expect(str, '1day 1hr 1min');
    });
    test('days + hrs + mins', () {
      var dur = Duration(days: 2, hours: 2, minutes: 2);
      var str = durationToString(duration: dur);
      expect(str, '2days 2hrs 2min');
    });
    test('hr + min + sec', () {
      var dur = Duration(hours: 1, minutes: 1, seconds: 1);
      var str = durationToString(duration: dur);
      expect(str, '1hr 1min 1sec');
    });
    test('hrs + mins + sec', () {
      var dur = Duration(hours: 2, minutes: 2, seconds: 2);
      var str = durationToString(duration: dur);
      expect(str, '2hrs 2min 2sec');
    });
    test('min + sec + msec', () {
      var dur = Duration(minutes: 1, seconds: 1, milliseconds: 1);
      var str = durationToString(duration: dur);
      expect(str, '1min 1sec 1msec');
    });
    test('day + hr + min + sec', () {
      var dur = Duration(
        days: 1,
        hours: 1,
        minutes: 1,
        seconds: 1,
      );
      var str = durationToString(duration: dur);
      expect(str, '1day 1hr 1min 1sec');
    });
    test('days + hrs + mins + sec', () {
      var dur = Duration(
        days: 2,
        hours: 2,
        minutes: 2,
        seconds: 2,
      );
      var str = durationToString(duration: dur);
      expect(str, '2days 2hrs 2min 2sec');
    });
    test('day + hr + min + sec + msec', () {
      var dur =
          Duration(days: 1, hours: 1, minutes: 1, seconds: 1, milliseconds: 1);
      var str = durationToString(duration: dur);
      expect(str, '1day 1hr 1min 1sec 1msec');
    });
    test('days + hrs + mins + sec + msec', () {
      var dur = Duration(
        days: 2,
        hours: 2,
        minutes: 2,
        seconds: 2,
        milliseconds: 2,
      );
      var str = durationToString(duration: dur);
      expect(str, '2days 2hrs 2min 2sec 2msec');
    });
    test('days + hrs + mins + secs + msec', () {
      var dur = Duration(
        days: 31,
        hours: 23,
        minutes: 59,
        seconds: 59,
        milliseconds: 999,
      );
      var str = durationToString(duration: dur);
      expect(str, '31days 23hrs 59min 59sec 999msec');
    });
    test('days + 0 hrs + mins + 0 secs + msec', () {
      var dur = Duration(
        days: 31,
        hours: 0,
        minutes: 59,
        seconds: 0,
        milliseconds: 999,
      );
      var str = durationToString(duration: dur);
      expect(str, '31days 0hr 59min 0sec 999msec');
    });
    test('days + hrs + mins + secs + msec', () {
      var dur = Duration(
        days: 31,
        hours: 23,
        minutes: 59,
        seconds: 59,
        milliseconds: 999,
      );
      var str = durationToString(
        duration: dur,
        shortHand: true,
      );
      expect(str, '31d 23h 59m 59s 999ms');
    });
  });
}

import 'dart:io';

import 'package:ansicolor/ansicolor.dart';

import '../configuration.dart';

class Log {
  static AnsiPen red = AnsiPen()..red(bold: true);
  static AnsiPen yellow = AnsiPen()..yellow(bold: true);
  static AnsiPen green = AnsiPen()..green(bold: true);
  static AnsiPen blue = AnsiPen()..blue(bold: true);
  static AnsiPen gray05 = AnsiPen()..gray(level: 0.5);
  static AnsiPen gray09 = AnsiPen()..gray(level: 0.9);
  static int _numberOfAllTasks = 11;
  static int _numberOfTasksCompleted = 0;
  static int lastMessageLength = 0;

  /// Log with colors.
  Log();

  /// Information log with `white` color
  static void info(String message) => _write(message, withColor: gray09);

  /// Error log with `red` color
  static void error(String message) {
    stdout.writeln();
    _write(message, withColor: red);
  }

  /// Write `error` log and exit the program
  static void errorAndExit(String message) {
    error(message);
    exit(0);
  }

  /// Warning log with `yellow` color
  static void warn(String message) => _write(message, withColor: yellow);

  /// Success log with `green` color
  static void success(String message) => _write(message, withColor: green);

  /// Link log with `blue` color
  static void link(String message) => _write(message, withColor: blue);

  static void _write(String message, {required AnsiPen withColor}) {
    stdout.writeln(withColor(message));
  }

  static void _renderProgressBar() {
    stdout.writeCharCode(13);

    stdout.write(gray09('['));
    var blueBars = '';
    for (var z = _numberOfTasksCompleted; z > 0; z--) {
      blueBars += '❚❚';
    }
    stdout.write(blue(blueBars));
    var grayBars = '';
    for (var z = _numberOfAllTasks - _numberOfTasksCompleted; z > 0; z--) {
      grayBars += '❚❚';
    }
    stdout.write(gray05(grayBars));

    stdout.write(gray09(']'));
    stdout.write(gray09(
        ' ${(_numberOfTasksCompleted * 100 / _numberOfAllTasks).floor()}%'));
  }

  /// Info log on a new task
  static void startingTask(String name) {
    final emptyStr = _getlastMessageemptyStringLength();
    lastMessageLength = name.length;
    _renderProgressBar();
    stdout.write(gray09(' $name...$emptyStr'));
  }

  /// Info log on a completed task
  static void taskCompleted() {
    _numberOfTasksCompleted++;
    if (_numberOfTasksCompleted >= _numberOfAllTasks) {
      final emptyStr = _getlastMessageemptyStringLength();
      _renderProgressBar();
      stdout.writeln(emptyStr);
    }
  }

  /// Log `Certificate Subject` help information
  static void printCertificateSubjectHelp() {
    Log.warn(
        'Please note: The value of Publisher should be in one line and with commas, example:');
    Log.info(defaultPublisher);
    Log.info('');
    Log.warn('For more information see:');
    Log.link(
        'https://docs.microsoft.com/en-us/windows/msix/package/create-certificate-package-signing#determine-the-subject-of-your-packaged-app');
    Log.info('');
  }

  /// Log `Test Certificate` help information
  static void printTestCertificateHelp(String pfxTestPath) {
    Log.info('');
    Log.warn('Certificate Note:');
    Log.warn(
        'every msix installer must be signed with certificate before it can be installed.');
    Log.warn(
        'for testing purposes we signed your msix installer with a TEST certificate,');
    Log.warn(
        'to use this certificate you need to install it, open the certificate file:');
    Log.link(pfxTestPath);
    Log.warn('and follow the instructions at the following link:');
    Log.link(
        'https://www.advancedinstaller.com/install-test-certificate-from-msix.html');
    Log.info('');
  }

  static String _getlastMessageemptyStringLength() {
    var emptyStr = '';
    for (var i = 0; i < lastMessageLength + 8; i++) {
      emptyStr += ' ';
    }
    return emptyStr;
  }
}

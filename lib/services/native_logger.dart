import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

final class NativeLogger {
  late MethodChannel _methodChannel;

  NativeLogger({required String bundleIdentifier}) {
    _methodChannel = MethodChannel('$bundleIdentifier/log');
  }

  void log(LogRecord logRecord) {
    _methodChannel.invokeMethod("log", {
      'level': logRecord.level.name,
      'message': logRecord.message,
      'loggerName': logRecord.loggerName,
      'time': logRecord.time.toIso8601String(),
      'error': logRecord.error?.toString(),
      'stackTrace': logRecord.stackTrace?.toString(),
    });
  }
}
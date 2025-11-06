import 'package:logger/logger.dart';

class TLoggerHelper {
  static final Logger _logger = Logger(printer: PrettyPrinter());

  static void logInfo(String message) {
    _logger.i(message);
  }

  static void logWarning(String message) {
    _logger.w(message);
  }

  static void logError(String message) {
    _logger.e(message);
  }

// Add more methods as needed for different log levels
}

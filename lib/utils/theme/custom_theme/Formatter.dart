import 'package:intl/intl.dart';

class TFormatter {
  // Formats the date in 'dd-MM-yy' format.
  static String formatDate(DateTime? date) {
    date ??= DateTime.now();
    return DateFormat('dd-MM-yy').format(date);
  }

  // Formats the amount as currency.
  static String formatCurrency(double amount) {
    return NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(amount);
  }

  // Formats the phone number in the format (XXX) XXX-XXXX.
  static String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length == 10) {
      return '(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3, 6)}-${phoneNumber.substring(6)}';
    } else {
      // If phone number is not 10 digits, return it as is.
      return phoneNumber;
    }

  }  // Splits the full name into parts.
  static List<String> nameParts(String fullName) {
    return fullName.split(" ");
  }


}


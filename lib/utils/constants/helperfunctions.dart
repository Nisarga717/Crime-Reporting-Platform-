import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class THelperFunction {
  static Color? getColor(String value) {
    switch (value.toLowerCase()) {
      case 'green':
        return Colors.green;
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'pink':
        return Colors.pink;
      case 'purple':
        return Colors.purple;
      case 'grey':
        return Colors.grey;
      case 'black':
        return Colors.black;
      case 'yellow':
        return Colors.yellow;
      case 'white':
        return Colors.white;
      case 'orange':
        return Colors.orange;
      case 'brown':
        return Colors.brown;
      default:
        return null; // Return null for unrecognized colors
    }
  }

  static void showSnackBar(String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  static void showAlert(String title, String message) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text; // Return the original text if it's within or equal to maxLength
    } else {
      return '${text.substring(0, maxLength)}...'; // Truncate and append ellipsis
    }
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }


  static String getFormattedDate(DateTime date, {String format = 'dd-MM-yy'}) {
    return DateFormat(format).format(date);
  }

  static List<T> removeDuplicates<T>(List<T> list) {
    return list.toSet().toList();
  }

  static List<Widget> wrapWidgets(List<Widget> widgets, int rowSize) {
    List<Widget> wrappedWidgets = [];
    for (int i = 0; i < widgets.length; i += rowSize) {
      wrappedWidgets.add(
        Row(
          children: widgets
              .sublist(i, i + rowSize > widgets.length ? widgets.length : i + rowSize)
              .map((widget) => Expanded(child: widget))
              .toList(),
        ),
      );
    }
    return wrappedWidgets;
  }
}





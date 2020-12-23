import 'package:get/get.dart';

void snackBar(String title, String message) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    duration: Duration(seconds: 7),
  );
}

import 'package:accelerometer/controllers/auth_controller.dart';
import 'package:accelerometer/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    var auth = FirebaseAuth.instance;
    var dataBase = Database();
    Get.put<AuthController>(
      AuthController(auth: auth, dataBase: dataBase),
      permanent: true,
    );
  }
}

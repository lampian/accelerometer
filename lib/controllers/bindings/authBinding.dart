// @dart=2.9
import 'package:accelerometer/controllers/auth_controller.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    //var auth = FirebaseAuth.instance;
    //var dataBase = Database();
    Get.put<AuthController>(
      //AuthController(auth: auth, dataBase: dataBase),
      AuthController(),
      permanent: true,
    );
  }
}

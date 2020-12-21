// @dart=2.9
import 'package:accelerometer/models/user.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  Rx<UserModel> _userModel = UserModel(
    admin: false,
    email: '',
    id: '',
    name: '',
    verified: false,
  ).obs;

  UserModel get userModel => _userModel.value;

  set userModel(UserModel value) => this._userModel.value = value;

  void clear() {
    _userModel.value = UserModel(
      admin: false,
      email: '',
      id: '',
      name: '',
      verified: false,
    );
  }
}

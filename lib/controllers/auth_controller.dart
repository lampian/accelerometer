// @dart=2.9
import 'package:accelerometer/controllers/user_controller.dart';
import 'package:accelerometer/models/user.dart';
import 'package:accelerometer/services/database.dart';
import 'package:accelerometer/widgets/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class Validate {
  static bool email(String value) => value.isEmail;
  static bool password(String value) {
    if (value.isEmpty || value.isNullOrBlank) {
      return false;
    } else {
      return true;
    }
  }

  static bool userName(String value) {
    if (value.isEmpty || value.isNullOrBlank) {
      return false;
    } else {
      return true;
    }
  }
}

class AuthController extends GetxController {
  //AuthController({this.auth, this.dataBase});
  FirebaseAuth auth = FirebaseAuth.instance;
  Database dataBase = Database();
  Rx<User> _firebaseUser = Rx<User>();

  User get user => _firebaseUser.value;
  User get currentUser {
    User x = auth.currentUser;
    print('app: current user email: ${x.email}');
    return x;
  }

  var nameTextCntl = TextEditingController();
  String get nameText => this.nameTextCntl.text;
  set nameText(String value) => this.nameTextCntl.text = value;

  var emailTextCntl = TextEditingController();
  String get emailText => this.emailTextCntl.text;
  set emailText(String value) => this.emailTextCntl.text = value;

  var passwordTextCntl = TextEditingController();
  String get passwordText => this.passwordTextCntl.text;
  set passwordText(String value) => this.passwordTextCntl.text = value;

  @override
  onInit() {
    super.onInit();
    _firebaseUser.bindStream(auth.authStateChanges());
  }

  Future<String> createUser() async {
    if ((Validate.email(emailText) &&
            Validate.password(passwordText) &&
            Validate.userName(nameText)) ==
        false) {
      return 'User credentials must be properly'
          'formed and not empty';
    }
    try {
      final _aR = await auth.createUserWithEmailAndPassword(
          email: emailText, password: passwordText);
      UserModel _user = UserModel(
          id: _aR == null ? '' : _aR.user.uid,
          name: nameText,
          email: emailText,
          admin: false,
          verified: false);
      var result = await dataBase.createNewUser(_user);
      if (result == false) {
        return 'User registration failed - persistence';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return ('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return ('The account already exists for that email.');
      }
    } on Exception catch (_) {
      return 'app: unknown exception occured';
    }
    return '';
  }

  Future<String> login() async {
    if ((Validate.email(emailText) && Validate.password(passwordText)) ==
        false) {
      return 'User credentials must be properly formed and not empty';
    }

    try {
      await auth.signInWithEmailAndPassword(
        email: emailText,
        password: passwordText,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else if (e.code == 'unknown') {
        return e.message;
      }
    } catch (_) {
      return 'app: unknown exception occured';
    }
    return '';
  }

  void signInAnonymously() async {
    try {
      UserCredential _aR = await auth.signInAnonymously();
      //TODO how to handle usermodel
      Get.find<UserController>().userModel =
          await Database().getUser(_aR.user.uid);
    } catch (e) {
      snackBar('Error', 'Error signing in');
    }
  }

  void signOut() async {
    try {
      await auth.signOut();
      Get.find<UserController>().clear();
    } catch (e) {
      snackBar('Error', 'Error signing out');
    }
  }
}

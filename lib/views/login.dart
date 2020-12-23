// @dart=2.9
import 'package:accelerometer/controllers/auth_controller.dart';
import 'package:accelerometer/widgets/utils.dart';
import 'package:accelerometer/views/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
    print('app: login');
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(hintText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                  controller: controller.emailTextCntl,
                ),
                SizedBox(
                  height: 40,
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: "Password"),
                  keyboardType: TextInputType.emailAddress,
                  controller: controller.passwordTextCntl,
                  obscureText: true,
                ),
                RaisedButton(
                  key: Key('login'),
                  child: Text("Log In"),
                  onPressed: () async {
                    var retStr = await controller.login();
                    if (retStr.isNotEmpty) {
                      snackBar('Warning', retStr);
                    }
                  },
                ),
                FlatButton(
                  child: Text("Sign Up"),
                  onPressed: () {
                    Get.to(SignUp());
                  },
                ),
                FlatButton(
                  child: Text("Sign in anonymously"),
                  onPressed: () {
                    controller.signInAnonymously();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// @dart=2.9
import 'package:accelerometer/controllers/auth_controller.dart';
import 'package:accelerometer/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUp extends GetWidget<AuthController> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print('ims: sign up');
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(hintText: "Full Name"),
                  keyboardType: TextInputType.emailAddress,
                  controller: controller.nameTextCntl,
                ),
                SizedBox(
                  height: 40,
                ),
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
                  obscureText: true,
                  controller: controller.passwordTextCntl,
                ),
                FlatButton(
                  child: Text("Sign Up"),
                  onPressed: () async {
                    var retStr = await controller.createUser();
                    if (retStr.isNotEmpty) {
                      snackBar('Warning', retStr);
                    } else {
                      Get.back();
                    }
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

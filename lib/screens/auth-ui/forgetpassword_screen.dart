import 'package:ecomm/controllers/forget_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../utils/app_constant.dart';

class ForgetpasswordScreen extends StatefulWidget {
  const ForgetpasswordScreen({super.key});

  @override
  State<ForgetpasswordScreen> createState() => _ForgetpasswordScreenState();
}

class _ForgetpasswordScreenState extends State<ForgetpasswordScreen> {
  final ForgetPasswordController forgetPasswordController =
      Get.put(ForgetPasswordController());
  TextEditingController userEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        appBar: AppBar(
            backgroundColor: AppConstant.appMainColor,
            iconTheme: const IconThemeData(color: AppConstant.appTextColor),
            title: Center(
              child: Text(AppConstant.appMainName,
                  style: const TextStyle(
                    color: AppConstant.appTextColor,
                    fontWeight: FontWeight.bold,
                  )),
            )),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: Get.width,
              height: Get.height,
              color: AppConstant.appMainColor,
              child: Column(
                children: [
                  isKeyboardVisible
                      ? SizedBox()
                      : Container(
                          child: Lottie.asset('assets/images/login-icon.json'),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: userEmail,
                      style: const TextStyle(color: Colors.red),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        label: const Text('Email'),
                        filled: true,
                        prefixIcon: const Icon(Icons.email),
                        prefixIconColor: AppConstant.appMainColor,
                        fillColor: AppConstant.appSecondaryColor,
                        labelStyle:
                            const TextStyle(color: AppConstant.appMainColor),
                        hintText: 'Enter your email address',
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppConstant.appMainColor,
                            ),
                            borderRadius: BorderRadius.circular(20)),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 30, 10, 5),
                    decoration: BoxDecoration(
                        color: AppConstant.appSecondaryColor,
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(20)),
                    width: Get.width,
                    height: Get.height / 14,
                    child: TextButton.icon(
                      onPressed: () async {
                        String email = userEmail.text.trim();

                        if (email.isEmpty) {
                          Get.snackbar("Error", "Please provide a valid email",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppConstant.appMainColor,
                              colorText: Colors.red);

                          return;
                        } else {
                          forgetPasswordController.ForgetPasswordMethod(email);
                        }
                      },
                      label: const Text(
                        'Forget Password',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

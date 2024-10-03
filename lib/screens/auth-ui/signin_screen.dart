import 'package:ecomm/controllers/sign_in_controller.dart';
import 'package:ecomm/screens/auth-ui/signup_screen.dart';
import 'package:ecomm/screens/user-panel/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../utils/app_constant.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final SignInController signInController = Get.put(SignInController());
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();

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
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Obx(
                        () => TextField(
                          controller: userPassword,
                          obscureText: signInController.isPasswordVisible.value,
                          style: const TextStyle(color: Colors.red),
                          decoration: InputDecoration(
                            label: const Text('Password'),
                            filled: true,
                            prefixIcon: const Icon(Icons.password),
                            prefixIconColor: AppConstant.appMainColor,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                signInController.togglePasswordVisibility();
                              },
                              child: signInController.isPasswordVisible.value
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility),
                            ),
                            suffixIconColor: AppConstant.appMainColor,
                            fillColor: AppConstant.appSecondaryColor,
                            labelStyle: const TextStyle(
                                color: AppConstant.appMainColor),
                            hintText: 'Enter your password',
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
                      )),
                  Container(
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.red,
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
                        String password = userPassword.text.trim();

                        if (email.isEmpty || password.isEmpty) {
                          Get.snackbar("Error", "Please Enter All Details",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppConstant.appMainColor,
                              colorText: AppConstant.appTextColor);
                          return;
                        }

                        UserCredential? userCredential =
                            await signInController.SignInMethod(
                                email, password);

                        if (userCredential != null) {
                          if (userCredential.user!.emailVerified) {
                            Get.snackbar("Success", "Login Successfully",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppConstant.appMainColor,
                                colorText: AppConstant.appTextColor);

                            Get.offAll(MainScreen());
                            return;
                          } else {
                            Get.snackbar("Error", "Please Verify Email",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppConstant.appMainColor,
                                colorText: AppConstant.appTextColor);
                            return;
                          }
                        } else {
                          Get.snackbar("Error", "Please Sign up",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppConstant.appMainColor,
                              colorText: AppConstant.appTextColor);
                          return;
                        }
                      },
                      label: const Text(
                        'Log In',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have any account? ",
                        style: TextStyle(color: Colors.red),
                      ),
                      GestureDetector(
                        onTap: (() => Get.to(const SignupScreen())),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

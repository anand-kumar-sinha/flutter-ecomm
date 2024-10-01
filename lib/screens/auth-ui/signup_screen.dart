import 'package:ecomm/screens/auth-ui/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../utils/app_constant.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        appBar: AppBar(
            backgroundColor: AppConstant.appMainColor,
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
                      ? const SizedBox()
                      : Container(
                          height: Get.height / 4,
                          child: Lottie.asset('assets/images/login-icon.json'),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
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
                    child: TextField(
                      style: const TextStyle(color: Colors.red),
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        label: const Text('Name'),
                        filled: true,
                        prefixIcon: const Icon(Icons.person),
                        prefixIconColor: AppConstant.appMainColor,
                        fillColor: AppConstant.appSecondaryColor,
                        labelStyle:
                            const TextStyle(color: AppConstant.appMainColor),
                        hintText: 'Enter your name',
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
                    child: TextField(
                      style: const TextStyle(color: Colors.red),
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        label: const Text('Email'),
                        filled: true,
                        prefixIcon: const Icon(Icons.phone),
                        prefixIconColor: AppConstant.appMainColor,
                        fillColor: AppConstant.appSecondaryColor,
                        labelStyle:
                            const TextStyle(color: AppConstant.appMainColor),
                        hintText: 'Enter your phone no.',
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
                    child: TextField(
                      obscureText: true,
                      style: const TextStyle(color: Colors.red),
                      decoration: InputDecoration(
                        label: const Text('Password'),
                        filled: true,
                        prefixIcon: const Icon(Icons.password),
                        prefixIconColor: AppConstant.appMainColor,
                        suffixIcon: const Icon(Icons.visibility_off),
                        suffixIconColor: AppConstant.appMainColor,
                        fillColor: AppConstant.appSecondaryColor,
                        labelStyle:
                            const TextStyle(color: AppConstant.appMainColor),
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
                      onPressed: () => print('he'),
                      label: const Text(
                        'Sign Up',
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
                        "Already have a account?",
                        style: TextStyle(color: Colors.red),
                      ),
                      GestureDetector(
                        onTap: (() => Get.offAll(const SignInScreen())),
                        child: const Text(
                          'Log In',
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

import 'dart:async';

import 'package:ecomm/screens/auth-ui/signin_screen.dart';
import 'package:ecomm/screens/auth-ui/signup_screen.dart';
import 'package:ecomm/screens/auth-ui/welcome_screen.dart';
import 'package:ecomm/screens/user-panel/main_screen.dart';
import 'package:ecomm/utils/app_constant.dart';
import 'package:ecomm/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Get.offAll(() =>  WelcomeScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppConstant.appMainColor,
      appBar: AppBar(
          backgroundColor: AppConstant.appMainColor,
          title: Center(
            child: Text(AppConstant.appMainName,
                style: const TextStyle(
                  color: AppConstant.appTextColor,
                  fontWeight: FontWeight.bold,
                )),
          )),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(color: AppConstant.appMainColor),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: Lottie.asset(
                    'assets/images/splash-icon.json',
                  ),
                ),
              ),
              Text(
                AppConstant.appMainName,
                style: const TextStyle(color: AppConstant.appTextColor),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Text(
                  AppConstant.appCopyright,
                  style: const TextStyle(
                    color: AppConstant.appTextColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

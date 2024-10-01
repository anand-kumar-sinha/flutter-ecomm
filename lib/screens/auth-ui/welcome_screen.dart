import 'package:ecomm/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: Container(
        color: AppConstant.appMainColor,
        child: Column(
          children: [
            Container(
              child: Lottie.asset(
                'assets/images/login-icon.json',
              ),
            ),
            SizedBox(
              height: Get.height / 12,
            ),
            Container(
              decoration: BoxDecoration(
                  color: AppConstant.appSecondaryColor,
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(25)),
              width: Get.width / 1.2,
              height: Get.height / 14,
              child: TextButton.icon(
                icon: Image.asset(
                  'assets/images/google-icon.png',
                  width: 20,
                  height: 20,
                ),
                onPressed: () => print('he'),
                label: const Text(
                  'Sign in to Google',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: Get.height / 18,
            ),
            Container(
              decoration: BoxDecoration(
                  color: AppConstant.appSecondaryColor,
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(25)),
              width: Get.width / 1.2,
              height: Get.height / 14 ,
              child: TextButton.icon(
                icon: Image.asset(
                  'assets/images/email-icon.png',
                  width: 30,
                  height: 30,
                ),
                onPressed: () => print('he'),
                label: const Text(
                  'Sign In with Email',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
              width: Get.width,
              child: Lottie.asset(
                'assets/images/welcome-icon.json',
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              height: Get.height / 12,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                  color: AppConstant.appSecondaryColor,
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(20)),
              width: Get.width,
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
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: Get.height / 18,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                  color: AppConstant.appSecondaryColor,
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(20)),
              width: Get.width,
              height: Get.height / 14,
              child: TextButton.icon(
                icon: const Icon(Icons.email),
                onPressed: () => print('he'),
                label: const Text(
                  'Sign In with Email',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

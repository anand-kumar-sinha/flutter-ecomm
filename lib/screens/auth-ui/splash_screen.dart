import 'dart:async';
import 'package:ecomm/controllers/get_user_data_controller.dart';
import 'package:ecomm/screens/admin-panel/admin_main_screen.dart';
import 'package:ecomm/screens/auth-ui/welcome_screen.dart';
import 'package:ecomm/screens/user-panel/main_screen.dart';
import 'package:ecomm/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user = FirebaseAuth.instance.currentUser;


  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 6), () {
      findExistUser(context);
    });
  }

  Future<void> findExistUser (BuildContext context) async{

    if(user != null){
          final GetUserDataController getUserDataController = Get.put(GetUserDataController());
      var userData =await getUserDataController.getUserdata(user!.uid);

      if(userData?[0]?["isAdmin"] == true){
        Get.offAll( () => const AdminMainScreen());
      }else{
        Get.offAll(()=> const MainScreen());
      }
    }else{
      Get.offAll(WelcomeScreen());
    }
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

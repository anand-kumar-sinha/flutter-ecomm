import 'package:ecomm/screens/auth-ui/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../utils/app_constant.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: AppConstant.appTextColor),
          backgroundColor: AppConstant.appMainColor,
          title: Center(
            child: Text(AppConstant.appMainName,
                style: const TextStyle(
                  color: AppConstant.appTextColor,
                  fontWeight: FontWeight.bold,
                )),
          ),
                actions: [
        GestureDetector(
          onTap: () async {
            GoogleSignIn googleSignIn = GoogleSignIn();
            FirebaseAuth _auth = FirebaseAuth.instance;
            await _auth.signOut();

            await googleSignIn.signOut();
            Get.offAll(WelcomeScreen());
          },
          child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.logout,
                color: AppConstant.appTextColor,
              )),
        )
      ]
          ),
    );
  }
}

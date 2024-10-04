import 'package:ecomm/screens/auth-ui/welcome_screen.dart';
import 'package:ecomm/utils/app_constant.dart';
import 'package:ecomm/widgets/banner_widget.dart';
import 'package:ecomm/widgets/custom_drawer_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      appBar: AppBar(
        iconTheme:const IconThemeData(color: AppConstant.appTextColor),
        backgroundColor: AppConstant.appMainColor,
        title: Text(AppConstant.appMainName,
            style: const TextStyle(
              color: AppConstant.appTextColor,
              fontWeight: FontWeight.bold,
            )),
        centerTitle: true,
      ),
      drawer: const CustomDrawerWidget(),
      body: const SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height:7),
            BannerWidget(),
          ],
        ),
      ),
    );
  }
}

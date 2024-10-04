import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomm/controllers/get_device_token_controller.dart';
import 'package:ecomm/controllers/get_user_data_controller.dart';
import 'package:ecomm/models/user_model.dart';
import 'package:ecomm/screens/admin-panel/admin_main_screen.dart';
import 'package:ecomm/screens/user-panel/main_screen.dart';
import 'package:ecomm/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInController extends GetxController {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GetUserDataController getUserDataController =
      Get.put(GetUserDataController());

  Future<void> signInWithGoogle() async {
    final GetDeviceTokenController getDeviceTokenController =
        Get.put(GetDeviceTokenController());
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        EasyLoading.show(status: "Please wait...");
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        final User? user = userCredential.user;
        var userData =
            await getUserDataController.getUserdata(userCredential.user!.uid);

        if (userData.isNotEmpty) {
          if (userData[0]['isAdmin'] == true) {
            Get.snackbar(
              "Success Admin Login",
              "",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppConstant.appMainColor,
              colorText: AppConstant.appTextColor,
              messageText: const Text(
                "Login Successfully ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppConstant.appTextColor,
                ),
              ),
            );
            EasyLoading.dismiss();
            Get.offAll(() => const AdminMainScreen());
          } else {
            EasyLoading.dismiss();
            Get.offAll(() => const MainScreen());
          }
        } else {
          if (user != null) {
            UserModel userModel = UserModel(
              uId: user.uid,
              username: user.displayName.toString(),
              email: user.email.toString(),
              phone: user.phoneNumber.toString(),
              userImg: user.photoURL.toString(),
              userDeviceToken: getDeviceTokenController.deviceToken.toString(),
              country: '',
              userAddress: '',
              street: '',
              isAdmin: false,
              isActive: true,
              createdOn: DateTime.now(),
            );

            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .set(userModel.toMap());

            EasyLoading.dismiss();
            Get.off(() => const MainScreen());
          }
        }
      }
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar("Error", "$e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppConstant.appMainColor,
          colorText: AppConstant.appTextColor);
    }
  }
}
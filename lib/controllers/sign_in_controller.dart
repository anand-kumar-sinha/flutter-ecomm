import 'package:ecomm/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var isPasswordVisible = true.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.toggle(); // This is valid with RxBool
  }

  Future<UserCredential?> SignInMethod(
    String userEmail,
    String userPassword,
  ) async {
    try {
      EasyLoading.show(status: 'Logging Please Wait...');
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: userEmail, password: userPassword);

      EasyLoading.dismiss();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      Get.snackbar("Error", "$e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppConstant.appMainColor,
          colorText: AppConstant.appTextColor);
    }

    return null;
  }
}

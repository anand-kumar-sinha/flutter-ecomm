import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomm/screens/auth-ui/signIn_screen.dart';
import 'package:ecomm/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> ForgetPasswordMethod(
    String userEmail,
  ) async {
    try {
      EasyLoading.show(status: 'Forgetting Please Wait...');

      //finding user is exists or not;
      QuerySnapshot result = await _firestore.collection('users').where('email', isEqualTo: userEmail).limit(1).get();

      if(result.docs.isEmpty){
      EasyLoading.dismiss();

        Get.snackbar("User not found", "",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppConstant.appMainColor,
            colorText: AppConstant.appTextColor);
        return;
      }

      await _auth.sendPasswordResetEmail(email: userEmail);
      Get.snackbar("Password reset link send to:", userEmail,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppConstant.appMainColor,
          colorText: AppConstant.appTextColor);

      Get.to(const SignInScreen());
      EasyLoading.dismiss();
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      Get.snackbar("Error", "$e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppConstant.appMainColor,
          colorText: AppConstant.appTextColor);
    }

  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomm/controllers/get_device_token_controller.dart';
import 'package:ecomm/models/user_model.dart';
import 'package:ecomm/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isPasswordVisible = true.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.toggle(); // This is valid with RxBool
  }

  Future<UserCredential?> signUpMethod(
    String userName,
    String userEmail,
    String userPhone,
    String userPassword,
  ) async {
    final GetDeviceTokenController getDeviceTokenController = Get.put(GetDeviceTokenController());
    try {
      EasyLoading.show(status: 'Signup Please Wait...');
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: userEmail, password: userPassword);

      await userCredential.user!.sendEmailVerification();

      UserModel userModel = UserModel(
          uId: userCredential.user!.uid,
          username: userName,
          email: userEmail,
          phone: userPhone,
          userImg: '',
          userDeviceToken: getDeviceTokenController.deviceToken.toString(),
          country: '',
          userAddress: '',
          street: '',
          isAdmin: false,
          isActive: true,
          createdOn: DateTime.now());

      _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userModel.toMap());
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

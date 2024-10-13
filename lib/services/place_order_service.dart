import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomm/models/order_model.dart';
import 'package:ecomm/screens/user-panel/main_screen.dart';
import 'package:ecomm/services/generate_random_id_services.dart';
import 'package:ecomm/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

void placeOrder({
  required BuildContext context,
  required String customerName,
  required String customerPhone,
  required String customerAddress,
  required String customerPincode,
  required String customerCity,
  required String customerDeviceToken,
}) async {
  final user = FirebaseAuth.instance.currentUser;
  EasyLoading.show(status: 'Please Wait...');
  if (user != null) {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .doc(user.uid)
          .collection('cartOrders')
          .get();

      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      for (var doc in documents) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>;

        String orderId = generateOrderId();

        OrderModel orderModel = OrderModel(
          productId: data['productId'],
          categoryId: data['categoryId'],
          productName: data['productName'],
          categoryName: data['categoryName'],
          salePrice: data['salePrice'],
          fullPrice: data['fullPrice'],
          productImages: data['productImages'],
          deliveryTime: data['deliveryTime'],
          isSale: data['isSale'],
          productDescription: data['productDescription'],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          productQuantity: data['productQuantity'],
          productFullPrice: data['productFullPrice'],
          productSalePrice: data['productSalePrice'],
          customerId: user.uid,
          status: 'pending',
          customerName: customerName,
          customerCity: customerCity,
          customerPhone: customerPhone,
          customerAddress: customerAddress,
          customerPincode: customerPincode,
          customerDeviceToken: customerDeviceToken,
        );

        for (var x = 0; x < documents.length; x++) {
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(user.uid)
              .set(
            {
              'uId': user.uid,
              'customerName': customerName,
              'customerPhone': customerPhone,
              'customerAddress': customerAddress,
              'customerPincode': customerPincode,
              'customerCity': customerCity,
              'customerDeviceToken': customerDeviceToken,
              'orderStatus': 'pending',
              'createdAt': DateTime.now(),
            },
          );

          //upload orders

          await FirebaseFirestore.instance
              .collection('orders')
              .doc(user.uid)
              .collection('confirmOrders')
              .doc(orderId)
              .set(
                orderModel.toMap(),
              );

          //delete cart products

          await FirebaseFirestore.instance
              .collection('cart')
              .doc(user.uid)
              .collection('cartOrders')
              .doc(orderModel.productId.toString())
              .delete();
        }
      }

      Get.snackbar("Success", "Order Successfull",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppConstant.appMainColor,
          colorText: AppConstant.appTextColor);
      const Duration(seconds: 3);

      EasyLoading.dismiss();
      Get.offAll(() => MainScreen());
    } catch (e) {
      Get.snackbar("Error", "Getting error in place order",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppConstant.appMainColor,
          colorText: AppConstant.appTextColor);
      EasyLoading.dismiss();

      return;
    }
  }
}

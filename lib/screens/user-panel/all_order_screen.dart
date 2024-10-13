import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomm/controllers/cart_total_price_controller.dart';
import 'package:ecomm/models/order_model.dart';
import 'package:ecomm/utils/app_constant.dart';
import 'package:ecomm/widgets/order_product_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';

class AllOrderScreen extends StatefulWidget {
  const AllOrderScreen({super.key});

  @override
  State<AllOrderScreen> createState() => _AllOrderScreenState();
}

class _AllOrderScreenState extends State<AllOrderScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final CartTotalPriceController cartTotalPriceController =
      Get.put(CartTotalPriceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            color: AppConstant.appTextColor,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: AppConstant.appMainColor,
          title: const Text(
            'My Orders',
            style: TextStyle(
              color: AppConstant.appTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          height: Get.height,
          width: Get.width,
          color: AppConstant.appMainColor,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .doc(user!.uid)
                .collection('confirmOrders')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_rounded,
                      color: AppConstant.appMainColor,
                    ),
                    Text(
                      'No product available',
                      style: TextStyle(
                          color: AppConstant.appMainColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  width: Get.width,
                  height: Get.height / 5,
                  child: const Center(
                    child: CupertinoActivityIndicator(),
                  ),
                );
              }

              if (snapshot.data!.docs.isEmpty) {
                return const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.android_rounded,
                      color: AppConstant.appMainColor,
                    ),
                    Text(
                      'No product available',
                      style: TextStyle(
                          color: AppConstant.appMainColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              }

              if (snapshot.data != null) {
                return Container(
                  height: Get.height,
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final orderData = snapshot.data!.docs[index];
                      OrderModel orderModel = OrderModel(
                          productId: orderData['productId'],
                          categoryId: orderData['categoryId'],
                          productName: orderData['productName'],
                          categoryName: orderData['categoryName'],
                          salePrice: orderData['salePrice'],
                          fullPrice: orderData['fullPrice'],
                          productImages: orderData['productImages'],
                          deliveryTime: orderData['deliveryTime'],
                          isSale: orderData['isSale'],
                          productDescription: orderData['productDescription'],
                          createdAt: orderData['createdAt'],
                          updatedAt: orderData['updatedAt'],
                          productQuantity: orderData['productQuantity'],
                          productFullPrice: orderData['productFullPrice'],
                          productSalePrice: orderData['productSalePrice'],
                          customerId: orderData['customerId'],
                          status: orderData['status'],
                          customerName: orderData['customerName'],
                          customerCity: orderData['customerCity'],
                          customerPincode: orderData['customerPincode'],
                          customerPhone: orderData['customerPhone'],
                          customerAddress: orderData['customerAddress'],
                          customerDeviceToken:
                              orderData['customerDeviceToken']);

                      //fetch cart price
                      cartTotalPriceController.fetchProductPrice();
                      return OrderProductWidget(
                          orderModel: orderModel, user: user);
                    },
                  ),
                );
              }

              return Container();
            },
          ),
        ));
  }
}

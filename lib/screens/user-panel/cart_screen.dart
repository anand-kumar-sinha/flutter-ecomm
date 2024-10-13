import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomm/controllers/cart_total_price_controller.dart';
import 'package:ecomm/models/cart_model.dart';
import 'package:ecomm/screens/user-panel/order_summry.dart';
import 'package:ecomm/utils/app_constant.dart';
import 'package:ecomm/widgets/cart_product_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final CartTotalPriceController cartTotalPriceController =
      Get.put(CartTotalPriceController());

  void handleDelete(
      CompletionHandler handler, String userId, String productId) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(userId)
        .collection('confirmOrders')
        .doc(productId)
        .delete();
  }

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
            'Cart',
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
                .collection('cart')
                .doc(user!.uid)
                .collection('cartOrders')
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
                      final cartData = snapshot.data!.docs[index];
                      CartModel cartModel = CartModel(
                        productId: cartData['productId'],
                        categoryId: cartData['categoryId'],
                        productName: cartData['productName'],
                        categoryName: cartData['categoryName'],
                        salePrice: cartData['salePrice'],
                        fullPrice: cartData['fullPrice'],
                        productImages: cartData['productImages'],
                        deliveryTime: cartData['deliveryTime'],
                        isSale: cartData['isSale'],
                        productDescription: cartData['productDescription'],
                        createdAt: cartData['createdAt'],
                        updatedAt: cartData['updatedAt'],
                        productQuantity: cartData['productQuantity'],
                        productFullPrice: cartData['productFullPrice'],
                        productSalePrice: cartData['productSalePrice'],
                      );

                      //fetch cart price
                      cartTotalPriceController.fetchProductPrice();
                      return SwipeActionCell(
                          key: ObjectKey(cartModel.productId),
                          backgroundColor: const Color.fromARGB(0, 255, 0, 21),
                          trailingActions: [
                            SwipeAction(
                              title: "Delete",
                              forceAlignmentToBoundary: true,
                              performsFirstActionWithFullSwipe: true,
                              onTap: (CompletionHandler handler) async {
                                handleDelete(
                                    handler, user!.uid, cartModel.productId);
                              },
                            )
                          ],
                          child: CartProductWidget(
                              cartModel: cartModel, user: user));
                    },
                  ),
                );
              }

              return Container();
            },
          ),
        ),
        bottomNavigationBar: Container(
          height: 60,
          decoration: const BoxDecoration(
              color: AppConstant.appMainColor,
              border: BorderDirectional(
                top: BorderSide(color: Colors.red, width: 1),
              )),
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Total: ',
                  ),
                  Obx(
                    () => Text(
                      cartTotalPriceController.fullPrice.value
                          .toStringAsFixed(1),
                      style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.red,
                          decorationThickness: 3),
                    ),
                  ),
                  Obx(() => Text(
                        '  ${cartTotalPriceController.salePrice.value.toStringAsFixed(1)}',
                        style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      )),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                    color: AppConstant.appSecondaryColor,
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(20)),
                width: Get.width / 3,
                height: 40,
                child: TextButton.icon(
                  icon: const Icon(
                    Icons.shopping_cart_checkout,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    Get.to(const OrderSummry());
                  },
                  label: const Text(
                    'Check out',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

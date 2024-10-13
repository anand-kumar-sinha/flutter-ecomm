import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomm/controllers/cart_total_price_controller.dart';
import 'package:ecomm/models/cart_model.dart';
import 'package:ecomm/services/get_ordered_device_token.dart';
import 'package:ecomm/services/place_order_service.dart';
import 'package:ecomm/utils/app_constant.dart';
import 'package:ecomm/widgets/cart_product_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';

class OrderSummry extends StatefulWidget {
  const OrderSummry({super.key});

  @override
  State<OrderSummry> createState() => _OrderSummryState();
}

class _OrderSummryState extends State<OrderSummry> {
  User? user = FirebaseAuth.instance.currentUser;

  final CartTotalPriceController cartTotalPriceController =
      Get.put(CartTotalPriceController());
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  void handleDelete(
      CompletionHandler handler, String userId, String productId) async {
    await FirebaseFirestore.instance
        .collection('cart')
        .doc(userId)
        .collection('cartOrders')
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
            'Order Summary',
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
                    showCustomBottomSheet();
                  },
                  label: const Text(
                    'Order',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void showCustomBottomSheet() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.pink[200],
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Container(
                height: 55,
                margin: const EdgeInsets.only(bottom: 10),
                child: TextField(
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(color: Colors.red),
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    label: const Text('Name'),
                    filled: true,
                    prefixIcon: const Icon(Icons.person),
                    prefixIconColor: AppConstant.appMainColor,
                    fillColor: AppConstant.appSecondaryColor,
                    labelStyle:
                        const TextStyle(color: AppConstant.appMainColor),
                    hintText: 'Name',
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: AppConstant.appMainColor,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                ),
              ),
              Container(
                height: 55,
                margin: const EdgeInsets.only(bottom: 10),
                child: TextField(
                  textInputAction: TextInputAction.next,
                  controller: phoneController,
                  style: const TextStyle(color: Colors.red),
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    label: const Text('Phone'),
                    filled: true,
                    prefixIcon: const Icon(Icons.phone),
                    prefixIconColor: AppConstant.appMainColor,
                    fillColor: AppConstant.appSecondaryColor,
                    labelStyle:
                        const TextStyle(color: AppConstant.appMainColor),
                    hintText: 'Phone',
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: AppConstant.appMainColor,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                ),
              ),
              Container(
                height: 55,
                margin: const EdgeInsets.only(bottom: 10),
                child: TextField(
                  textInputAction: TextInputAction.next,
                  controller: cityController,
                  style: const TextStyle(color: Colors.red),
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    label: const Text('City'),
                    filled: true,
                    prefixIcon: const Icon(Icons.location_city),
                    prefixIconColor: AppConstant.appMainColor,
                    fillColor: AppConstant.appSecondaryColor,
                    labelStyle:
                        const TextStyle(color: AppConstant.appMainColor),
                    hintText: 'City',
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: AppConstant.appMainColor,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                ),
              ),
              Container(
                height: 55,
                margin: const EdgeInsets.only(bottom: 10),
                child: TextField(
                  textInputAction: TextInputAction.next,
                  controller: pincodeController,
                  style: const TextStyle(color: Colors.red),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    label: const Text('Pin Code'),
                    filled: true,
                    prefixIcon: const Icon(Icons.pin_drop),
                    prefixIconColor: AppConstant.appMainColor,
                    fillColor: AppConstant.appSecondaryColor,
                    labelStyle:
                        const TextStyle(color: AppConstant.appMainColor),
                    hintText: 'Pin Code',
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: AppConstant.appMainColor,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                ),
              ),
              Container(
                height: 55,
                margin: const EdgeInsets.only(bottom: 10),
                child: TextField(
                  style: const TextStyle(color: Colors.red),
                  textInputAction: TextInputAction.done,
                  controller: addressController,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    label: const Text('Address'),
                    filled: true,
                    prefixIcon: const Icon(Icons.location_city_rounded),
                    prefixIconColor: AppConstant.appMainColor,
                    fillColor: AppConstant.appSecondaryColor,
                    labelStyle:
                        const TextStyle(color: AppConstant.appMainColor),
                    hintText: 'Address',
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: AppConstant.appMainColor,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: AppConstant.appSecondaryColor,
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(20)),
                // width: Get.width / 3,
                height: 40,
                child: TextButton.icon(
                  icon: const Icon(
                    Icons.shopping_cart_checkout,
                    color: Colors.red,
                  ),
                  onPressed: () async {
                    if (nameController.text != '' &&
                        phoneController.text != '' &&
                        addressController.text != '' &&
                        pincodeController.text != '' &&
                        cityController.text != '') {
                      String name = nameController.text.trim();
                      String phone = phoneController.text.trim();
                      String address = addressController.text.trim();
                      String pincode = pincodeController.text.trim();
                      String city = cityController.text.trim();

                      

                      String customerToken = await getCustomerDeviceToken();

                      //place order
                      placeOrder(
                        context: context,
                        customerName: name,
                        customerPhone: phone,
                        customerAddress: address,
                        customerPincode: pincode,
                        customerCity: city,
                        customerDeviceToken: customerToken,
                      );
                    } else {
                      Get.snackbar("Error", "Please Enter All Details",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppConstant.appMainColor,
                          colorText: AppConstant.appTextColor);
                      return;
                    }
                  },
                  label: const Text(
                    'Place Order',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomm/models/cart_model.dart';
import 'package:ecomm/utils/app_constant.dart';
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
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppConstant.appSecondaryColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            border: Border.all(color: Colors.red),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 150,
                                height: 200,
                                padding: const EdgeInsets.only(right: 8),
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl: cartModel.productImages[0],
                                    height: 200,
                                    width: 150,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        const CupertinoActivityIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    fadeInDuration:
                                        const Duration(milliseconds: 500),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cartModel.productName,
                                      softWrap: true,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: AppConstant.appTextColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      cartModel.productDescription,
                                      softWrap: true,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: AppConstant.appTextColor,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Rs:',
                                        ),
                                        Text(
                                          cartModel.productFullPrice,
                                          style: const TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            decorationColor: Colors.red,
                                            decorationThickness: 3,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          cartModel.productSalePrice.toString(),
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            if (cartModel.productQuantity > 1) {
                                              await FirebaseFirestore.instance
                                                  .collection('cart')
                                                  .doc(user!.uid)
                                                  .collection('cartOrders')
                                                  .doc(cartModel.productId)
                                                  .update({
                                                'productQuantity':
                                                    cartModel.productQuantity -
                                                        1,
                                                'productFullPrice': (double
                                                            .parse(cartModel
                                                                .fullPrice) *
                                                        (cartModel
                                                                .productQuantity -
                                                            1))
                                                    .toString(),
                                                'productSalePrice': (double
                                                            .parse(cartModel
                                                                .salePrice) *
                                                        (cartModel
                                                                .productQuantity -
                                                            1))
                                                    .toString(),
                                              });
                                            }
                                          },
                                          child: const CircleAvatar(
                                            radius: 11,
                                            child: Text('-'),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(cartModel.productQuantity
                                            .toString()),
                                        const SizedBox(width: 8),
                                        GestureDetector(
                                          onTap: () async {
                                            if (cartModel.productQuantity <=
                                                10) {
                                              await FirebaseFirestore.instance
                                                  .collection('cart')
                                                  .doc(user!.uid)
                                                  .collection('cartOrders')
                                                  .doc(cartModel.productId)
                                                  .update({
                                                'productQuantity':
                                                    cartModel.productQuantity +
                                                        1,
                                                'productFullPrice': (double
                                                            .parse(cartModel
                                                                .fullPrice) *
                                                        (cartModel
                                                                .productQuantity +
                                                            1))
                                                    .toString(),
                                                'productSalePrice': (double
                                                            .parse(cartModel
                                                                .salePrice) *
                                                        (cartModel
                                                                .productQuantity +
                                                            1))
                                                    .toString(),
                                              });
                                            }
                                          },
                                          child: CircleAvatar(
                                            radius: 11,
                                            child: Text('+'),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: AppConstant.appSecondaryColor,
                                          border: Border.all(color: Colors.red),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      width: Get.width / 3,
                                      height: 40,
                                      child: TextButton.icon(
                                        icon: const Icon(
                                          Icons.delete_forever_rounded,
                                          color: Colors.red,
                                        ),
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection('cart')
                                              .doc(user!.uid)
                                              .collection('cartOrders')
                                              .doc(cartModel.productId)
                                              .delete();
                                        },
                                        label: const Text(
                                          'Remove',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
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
                  Text(
                    'Total: ',
                  ),
                  Text(
                    '999',
                    style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Colors.red,
                        decorationThickness: 3),
                  ),
                  Text(
                    '  799',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  )
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
                  onPressed: () {},
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

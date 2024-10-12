import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomm/models/product_model.dart';
import 'package:ecomm/screens/user-panel/cart_screen.dart';
import 'package:ecomm/widgets/product_card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_constant.dart';

class SingleCategoryProductScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  const SingleCategoryProductScreen({super.key, required this.categoryId, required this.categoryName});

  @override
  State<SingleCategoryProductScreen> createState() =>
      _SingleCategoryProductScreenState();
}

class _SingleCategoryProductScreenState
    extends State<SingleCategoryProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppConstant.appTextColor),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            color: AppConstant.appTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8, right: 3),
            child: GestureDetector(
              onTap: () => Get.to(()=> const CartScreen()),
              child: const Icon(
                Icons.shopping_cart_checkout_rounded,
                size: 27,
              ),
            ),
          )
        ],
      ),
      body: Container(
        height: Get.height,
        width: Get.width,
        color: AppConstant.appMainColor,
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('products')
              .where('categoryId', isEqualTo: widget.categoryId)
              .get(),
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
              return GridView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 3,
                  crossAxisSpacing: 3,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  final productData = snapshot.data!.docs[index];
                  ProductModel productModel = ProductModel(
                    productId: productData['productId'],
                    categoryId: productData['categoryId'],
                    productName: productData['productName'],
                    categoryName: productData['categoryName'],
                    salePrice: productData['salePrice'],
                    fullPrice: productData['fullPrice'],
                    productImages: productData['productImages'],
                    deliveryTime: productData['deliveryTime'],
                    isSale: productData['isSale'],
                    productDiscription: productData['productDiscription'],
                    createdAt: productData['createdAt'],
                    updatedAt: productData['updatedAt'],
                  );

                  return Container(
                      width: 180,
                      height: 250,
                      decoration: BoxDecoration(
                          color: AppConstant.appSecondaryColor,
                          border: Border.all(
                            color: AppConstant.appMainColor,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(15.0)),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: ProductCardWidget(
                          productModel: productModel, height: 160, width: 172));
                },
              );
            }

            return Container();
          },
        ),
      ),
    );
  }
}

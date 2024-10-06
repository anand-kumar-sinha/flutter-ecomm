
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomm/models/product_model.dart';
import 'package:ecomm/utils/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/product_card_widget.dart';

class AllProductScreen extends StatefulWidget {
  const AllProductScreen({super.key});

  @override
  State<AllProductScreen> createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
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
        title: Text(
          AppConstant.appMainName,
          style: const TextStyle(
            color: AppConstant.appTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: Get.height,
        color: AppConstant.appMainColor,
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('products')
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Icon(
                  Icons.error_rounded,
                  color: AppConstant.appMainColor,
                ),
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
              return const Center(
                child: Icon(
                  Icons.android_rounded,
                  color: AppConstant.appMainColor,
                ),
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
                    child: ProductCardWidget(productModel: productModel, height: 160, width: 172)
                  );
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

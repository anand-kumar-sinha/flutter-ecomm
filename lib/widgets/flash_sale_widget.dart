
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomm/models/product_model.dart';
import 'package:ecomm/utils/app_constant.dart';
import 'package:ecomm/widgets/product_card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FlashSaleWidget extends StatefulWidget {
  const FlashSaleWidget({super.key});

  @override
  State<FlashSaleWidget> createState() => _FlashSaleWidgetState();
}

class _FlashSaleWidgetState extends State<FlashSaleWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('products')
            .where('isSale', isEqualTo: true)
            .limit(4)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
            return SizedBox(
              width: Get.width,
              height: 210,
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
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
                    width: 162,
                    height: 210,
                    decoration: BoxDecoration(
                        color: AppConstant.appSecondaryColor,
                        border: Border.all(
                          color: AppConstant.appMainColor,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(15.0)),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: ProductCardWidget(productModel: productModel, height: 150, width: 150)
                  );
                },
              ),
            );
          }

          return Container();
        });
  }
}

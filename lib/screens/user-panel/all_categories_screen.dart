import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomm/models/category_model.dart';
import 'package:ecomm/screens/user-panel/cart_screen.dart';
import 'package:ecomm/screens/user-panel/single_category_product_screen.dart';
import 'package:ecomm/utils/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
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
        title: const Text(
          'Category',
          style: TextStyle(
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
        color: AppConstant.appMainColor,
        child: FutureBuilder(
          future: FirebaseFirestore.instance.collection('categories').get(),
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
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  CategoryModel categoryModel = CategoryModel(
                    categoryId: snapshot.data!.docs[index]['categoryId'],
                    categoryImg: snapshot.data!.docs[index]['categoryImg'],
                    categoryName: snapshot.data!.docs[index]['categoryName'],
                    createdAt: snapshot.data!.docs[index]['createdAt'],
                    updatedAt: snapshot.data!.docs[index]['updatedAt'],
                  );

                  return Container(
                    height: Get.height / 10,
                    width: Get.width / 2.3,
                    decoration: BoxDecoration(
                        color: AppConstant.appSecondaryColor,
                        border: Border.all(
                          color: AppConstant.appMainColor,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(15.0)),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(() => SingleCategoryProductScreen(
                                  categoryId: categoryModel.categoryId, categoryName: categoryModel.categoryName));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: CachedNetworkImage(
                                imageUrl: categoryModel.categoryImg,
                                height: 150,
                                width: Get.width / 2.3,
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
                          Text(
                            categoryModel.categoryName,
                            style: const TextStyle(
                                color: AppConstant.appTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          )
                        ],
                      ),
                    ),
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

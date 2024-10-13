import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomm/controllers/getting_rating.dart';
import 'package:ecomm/models/cart_model.dart';
import 'package:ecomm/models/product_model.dart';
import 'package:ecomm/models/review_model.dart';
import 'package:ecomm/screens/user-panel/cart_screen.dart';
import 'package:ecomm/screens/user-panel/order_summry.dart';
import 'package:ecomm/utils/app_constant.dart';
import 'package:ecomm/widgets/similar_product_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel productModel;
  const ProductDetailScreen({super.key, required this.productModel});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    CalculateProductRatingController calculateProductRatingController = Get.put(
        CalculateProductRatingController(widget.productModel.productId));

    int salePriceInt = ((int.parse(widget.productModel.salePrice) *
                100 /
                int.parse(widget.productModel.fullPrice)) -
            100)
        .toInt()
        .abs();
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
          AppConstant.appMainName,
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
              onTap: () => Get.to(() => const CartScreen()),
              child: const Icon(
                Icons.shopping_cart_checkout_rounded,
                size: 27,
              ),
            ),
          )
        ],
      ),
      body: Container(
        width: Get.width,
        color: AppConstant.appMainColor,
        child: Column(
          children: [
            //product image slider
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    CarouselSlider(
                      items: widget.productModel.productImages
                          .map(
                            (imageUrl) => ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  fit: BoxFit.cover,
                                  width: Get.width - 10,
                                  placeholder: (context, url) =>
                                      const ColoredBox(
                                        color: AppConstant.appMainColor,
                                        child: Center(
                                          child: CupertinoActivityIndicator(),
                                        ),
                                      ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error)),
                            ),
                          )
                          .toList(),
                      options: CarouselOptions(
                        scrollDirection: Axis.horizontal,
                        autoPlay: true,
                        aspectRatio: 0.85,
                        viewportFraction: 1,
                      ),
                    ),

                    //product details container
                    Container(
                      width: Get.width,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //product name
                          Text(
                            widget.productModel.productName,
                            style: const TextStyle(
                              color: AppConstant.appTextColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          //product Rating
                          Obx(() {
                            return IgnorePointer(
                              child: RatingBar.builder(
                                initialRating: calculateProductRatingController
                                    .averageRating.value, // Reactive value
                                itemSize: 23,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding: const EdgeInsets.only(left: 2),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.red,
                                ),
                                onRatingUpdate:
                                    (rating) {}, // Disable updating if necessary
                              ),
                            );
                          }),

                          //product price
                          Row(
                            children: [
                              const Text(
                                'Rs:',
                              ),
                              Text(
                                widget.productModel.fullPrice,
                                style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: Colors.red,
                                    fontSize: 17,
                                    decorationThickness: 3),
                              ),
                              Text(
                                '  ${widget.productModel.salePrice}',
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Icon(
                                  Icons.arrow_downward_rounded,
                                  color: Color.fromARGB(255, 0, 184, 6),
                                  size: 25,
                                ),
                              ),
                              Text(
                                '${salePriceInt.toString()}%',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 184, 6),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              )
                            ],
                          ),

                          widget.productModel.isSale
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppConstant.appMainColor,
                                    ),
                                    child: const Text(
                                      'Top Discount on Sale',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          Row(
                            children: [
                              const Icon(Icons.delivery_dining),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  'Free delivery up to, ${widget.productModel.deliveryTime}',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                          const Row(
                            children: [
                              Icon(Icons.compare_arrows_rounded),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  '7 days free replacement policy',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                          const Row(
                            children: [
                              Icon(Icons.money_rounded),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  'Cash on delivery',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Description: ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Expanded(
                                  child: Text(
                                      widget.productModel.productDiscription,
                                      overflow: TextOverflow.visible,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      )),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: Get.width,
                            height: 30,
                          ),
                          const Text('Similar Products: ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              )),
                          SizedBox(
                            width: Get.width,
                            height: 10,
                          ),

                          SimilarProductWidget(
                              categoryId: widget.productModel.categoryId),

                          SizedBox(
                            width: Get.width,
                            height: 10,
                          ),
                          const Text('Reviews: ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              )),
                          FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('products')
                                .doc(widget.productModel.productId)
                                .collection('reviews')
                                .get(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                  child: Container(
                                    margin: const EdgeInsets.all(20),
                                    child: const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.error_rounded,
                                          color: AppConstant.appMainColor,
                                        ),
                                        Text(
                                          'No Reviews available',
                                          style: TextStyle(
                                              color: AppConstant.appMainColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SizedBox(
                                  width: Get.width,
                                  height: Get.height / 5,
                                  child: const Center(
                                    child: CupertinoActivityIndicator(),
                                  ),
                                );
                              }

                              if (snapshot.data!.docs.isEmpty) {
                                return Center(
                                  child: Container(
                                    margin: const EdgeInsets.all(20),
                                    child: const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.error_rounded,
                                          color: AppConstant.appMainColor,
                                        ),
                                        Text(
                                          'No Reviews available',
                                          style: TextStyle(
                                              color: AppConstant.appMainColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              if (snapshot.data != null) {
                                return Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  width: Get.width,
                                  height: 150,
                                  child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      var data = snapshot.data!.docs[index];
                                      ReviewModel reviewModel = ReviewModel(
                                          customerName: data['customerName'],
                                          customerPhone: data['customerPhone'],
                                          customerDeviceToken:
                                              data['customerDeviceToken'],
                                          customerId: data['customerId'],
                                          feedback: data['feedback'],
                                          rating: data['rating'],
                                          createdAt: data['createdAt']);

                                      (double.parse(reviewModel.rating)) /
                                          snapshot.data!.docs.length;
                                      return Container(
                                        width: 210,
                                        height: 150,
                                        padding: const EdgeInsets.all(8),
                                        margin: const EdgeInsets.only(right: 8),
                                        decoration: BoxDecoration(
                                            color:
                                                AppConstant.appSecondaryColor,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                            border: Border.all(
                                                color: Colors.red, width: 1)),
                                        child: Column(
                                          children: [
                                            Text(
                                              reviewModel.customerName,
                                              style: const TextStyle(
                                                  color:
                                                      AppConstant.appTextColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            IgnorePointer(
                                              child: RatingBar.builder(
                                                initialRating: double.parse(
                                                    reviewModel.rating),
                                                itemSize: 23,
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemPadding:
                                                    const EdgeInsets.only(
                                                        left: 2),
                                                itemBuilder: (context, _) =>
                                                    const Icon(
                                                  Icons.star,
                                                  color: Colors.red,
                                                ),
                                                onRatingUpdate: (rating) {},
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(reviewModel.feedback,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 5,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                  )),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }

                              return Container();
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                      color: AppConstant.appSecondaryColor,
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(20)),
                  width: Get.width / 2.3,
                  height: Get.height / 14,
                  child: TextButton.icon(
                    icon: const Icon(
                      Icons.shopping_cart_checkout_rounded,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      await checkProductExistence(uId: user!.uid);
                    },
                    label: const Text(
                      'Add to cart',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                      color: AppConstant.appMainColor,
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(20)),
                  width: Get.width / 2.3,
                  height: Get.height / 14,
                  child: TextButton.icon(
                    icon: const Icon(
                      Icons.shopping_basket_rounded,
                      color: AppConstant.appTextColor,
                    ),
                    onPressed: () {
                      Get.to(const OrderSummry());
                    },
                    label: const Text(
                      'Buy now',
                      style: TextStyle(
                          color: AppConstant.appTextColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkProductExistence(
      {required String uId, int quantityIncrement = 1}) async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(uId)
        .collection('cartOrders')
        .doc(widget.productModel.productId.toString());

    DocumentSnapshot snapshot = await documentReference.get();

    if (snapshot.exists) {
      int currentQt = snapshot['productQuantity'];
      int updatedQuantity = currentQt + quantityIncrement;
      double salePrice =
          double.parse(widget.productModel.salePrice) * updatedQuantity;
      double fullPrice =
          double.parse(widget.productModel.fullPrice) * updatedQuantity;

      await documentReference.update({
        'productQuantity': updatedQuantity,
        'productSalePrice': salePrice.toString(),
        'productFullPrice': fullPrice.toString(),
      });
    } else {
      await FirebaseFirestore.instance.collection('cart').doc(uId).set(
        {
          "uId": uId,
          "createdAt": DateTime.now(),
        },
      );

      CartModel cartModel = CartModel(
        productId: widget.productModel.productId,
        categoryId: widget.productModel.categoryId,
        productName: widget.productModel.productName,
        categoryName: widget.productModel.categoryName,
        salePrice: widget.productModel.salePrice,
        fullPrice: widget.productModel.fullPrice,
        productImages: widget.productModel.productImages,
        deliveryTime: widget.productModel.deliveryTime,
        isSale: widget.productModel.isSale,
        productDescription: widget.productModel.productDiscription,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        productQuantity: 1,
        productFullPrice: widget.productModel.fullPrice.toString(),
        productSalePrice: widget.productModel.salePrice.toString(),
      );
      await documentReference.set(cartModel.toMap());
    }
  }
}

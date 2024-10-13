import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomm/models/order_model.dart';
import 'package:ecomm/models/product_model.dart';
import 'package:ecomm/models/review_model.dart';
import 'package:ecomm/screens/user-panel/product_detail_screen.dart';
import 'package:ecomm/services/get_ordered_device_token.dart';
import 'package:ecomm/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class OrderProductWidget extends StatefulWidget {
  final OrderModel orderModel;
  final User? user;
  const OrderProductWidget({super.key, required this.orderModel, this.user});

  @override
  State<OrderProductWidget> createState() => _OrderProductWidgetState();
}

class _OrderProductWidgetState extends State<OrderProductWidget> {
  TextEditingController feedbackController = TextEditingController();
  double productRating = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppConstant.appSecondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: Colors.red),
      ),
      child: GestureDetector(
        onTap: () {
          ProductModel productModel = ProductModel(
            productId: widget.orderModel.productId,
            categoryId: widget.orderModel.categoryId,
            productName: widget.orderModel.productName,
            categoryName: widget.orderModel.categoryName,
            salePrice: widget.orderModel.salePrice,
            fullPrice: widget.orderModel.fullPrice,
            productImages: widget.orderModel.productImages,
            deliveryTime: widget.orderModel.deliveryTime,
            isSale: widget.orderModel.isSale,
            productDiscription: widget.orderModel.productDescription,
            createdAt: widget.orderModel.createdAt,
            updatedAt: widget.orderModel.updatedAt,
          );
          Get.to(ProductDetailScreen(productModel: productModel));
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 150,
              height: 200,
              padding: const EdgeInsets.only(right: 8),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: widget.orderModel.productImages[0],
                  height: 200,
                  width: 150,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const CupertinoActivityIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fadeInDuration: const Duration(milliseconds: 500),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.orderModel.productName,
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
                    widget.orderModel.productDescription,
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
                        widget.orderModel.productFullPrice,
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.red,
                          decorationThickness: 3,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        widget.orderModel.productSalePrice.toString(),
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
                      const Text(
                        "Quantity: ",
                      ),
                      Text(
                        widget.orderModel.productQuantity.toString(),
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 184, 6),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Delivery Expected: ",
                      ),
                      Text(
                        widget.orderModel.deliveryTime,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 184, 6),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      const Text(
                        "Order Status: ",
                      ),
                      Text(
                        widget.orderModel.status,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 184, 6),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  widget.orderModel.status == 'Delivered'
                      ? Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                              color: AppConstant.appSecondaryColor,
                              border: Border.all(color: Colors.red),
                              borderRadius: BorderRadius.circular(20)),
                          width: Get.width / 3,
                          height: 40,
                          child: TextButton.icon(
                            icon: const Icon(
                              Icons.reviews_rounded,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              showCustomBottomSheet();
                            },
                            label: const Text(
                              'Review',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : const SizedBox.shrink()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void showCustomBottomSheet() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        padding: const EdgeInsets.only(top: 20),
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
              //product Rating
              RatingBar.builder(
                initialRating: 0,
                itemSize: 25,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.only(left: 2),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.red,
                ),
                onRatingUpdate: (rating) {
                  productRating = rating;
                  setState(() {});
                },
              ),
              Container(
                height: 55,
                margin: const EdgeInsets.only(bottom: 10, top: 30),
                child: TextField(
                  controller: feedbackController,
                  textInputAction: TextInputAction.go,
                  style: const TextStyle(color: Colors.red),
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    label: const Text('Review'),
                    filled: true,
                    prefixIcon: const Icon(Icons.reviews_rounded),
                    prefixIconColor: AppConstant.appMainColor,
                    fillColor: AppConstant.appSecondaryColor,
                    labelStyle:
                        const TextStyle(color: AppConstant.appMainColor),
                    hintText: 'Share your feedback',
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
                    Icons.reviews_rounded,
                    color: Colors.red,
                  ),
                  onPressed: () async {
                    String feedback = feedbackController.text.trim();
                    if (feedback.isEmpty || productRating == 0) {
                      Get.snackbar("Error", "Please provide rating and review",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppConstant.appMainColor,
                          colorText: AppConstant.appTextColor);

                      EasyLoading.dismiss();
                      return;
                    }
                    EasyLoading.show(status: 'Please Wait...');
                    String customerToken = await getCustomerDeviceToken();

                    ReviewModel reviewModel = ReviewModel(
                      customerName: widget.orderModel.customerName,
                      customerPhone: widget.orderModel.customerPhone,
                      customerDeviceToken: customerToken,
                      customerId: widget.orderModel.customerId,
                      feedback: feedback,
                      rating: productRating.toString(),
                      createdAt: DateTime.now(),
                    );

                    FirebaseFirestore.instance
                        .collection('products')
                        .doc(widget.orderModel.productId)
                        .collection('reviews')
                        .doc(widget.orderModel.customerId)
                        .set(reviewModel.toMap());

                    EasyLoading.dismiss();

                    Get.snackbar("Success", "Review Added",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppConstant.appMainColor,
                        colorText: AppConstant.appTextColor);
                  },
                  label: const Text(
                    'Add Review',
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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomm/models/cart_model.dart';
import 'package:ecomm/models/product_model.dart';
import 'package:ecomm/screens/user-panel/product_detail_screen.dart';
import 'package:ecomm/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartProductWidget extends StatefulWidget {
  final CartModel cartModel;
  final User? user;
  const CartProductWidget({super.key, required this.cartModel, this.user});

  @override
  State<CartProductWidget> createState() => _CartProductWidgetState();
}

class _CartProductWidgetState extends State<CartProductWidget> {
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
              productId: widget.cartModel.productId,
              categoryId: widget.cartModel.categoryId,
              productName: widget.cartModel.productName,
              categoryName: widget.cartModel.categoryName,
              salePrice: widget.cartModel.salePrice,
              fullPrice: widget.cartModel.fullPrice,
              productImages: widget.cartModel.productImages,
              deliveryTime: widget.cartModel.deliveryTime,
              isSale: widget.cartModel.isSale,
              productDiscription: widget.cartModel.productDescription,
              createdAt: widget.cartModel.createdAt,
              updatedAt: widget.cartModel.updatedAt);

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
                  imageUrl: widget.cartModel.productImages[0],
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
                    widget.cartModel.productName,
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
                    widget.cartModel.productDescription,
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
                        widget.cartModel.productFullPrice,
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
                        widget.cartModel.productSalePrice.toString(),
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
                          if (widget.cartModel.productQuantity > 1) {
                            await FirebaseFirestore.instance
                                .collection('cart')
                                .doc(widget.user!.uid)
                                .collection('cartOrders')
                                .doc(widget.cartModel.productId)
                                .update({
                              'productQuantity':
                                  widget.cartModel.productQuantity - 1,
                              'productFullPrice':
                                  (double.parse(widget.cartModel.fullPrice) *
                                          (widget.cartModel.productQuantity -
                                              1))
                                      .toString(),
                              'productSalePrice':
                                  (double.parse(widget.cartModel.salePrice) *
                                          (widget.cartModel.productQuantity -
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
                      Text(widget.cartModel.productQuantity.toString()),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () async {
                          if (widget.cartModel.productQuantity <= 10) {
                            await FirebaseFirestore.instance
                                .collection('cart')
                                .doc(widget.user!.uid)
                                .collection('cartOrders')
                                .doc(widget.cartModel.productId)
                                .update({
                              'productQuantity':
                                  widget.cartModel.productQuantity + 1,
                              'productFullPrice':
                                  (double.parse(widget.cartModel.fullPrice) *
                                          (widget.cartModel.productQuantity +
                                              1))
                                      .toString(),
                              'productSalePrice':
                                  (double.parse(widget.cartModel.salePrice) *
                                          (widget.cartModel.productQuantity +
                                              1))
                                      .toString(),
                            });
                          }
                        },
                        child: const CircleAvatar(
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
                        borderRadius: BorderRadius.circular(20)),
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
                            .doc(widget.user!.uid)
                            .collection('cartOrders')
                            .doc(widget.cartModel.productId)
                            .delete();
                      },
                      label: const Text(
                        'Remove',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
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
  }
}

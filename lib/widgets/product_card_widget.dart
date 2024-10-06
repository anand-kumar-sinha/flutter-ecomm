import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecomm/models/product_model.dart';
import 'package:ecomm/screens/user-panel/product_detail_screen.dart';
import 'package:ecomm/utils/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductCardWidget extends StatefulWidget {
  final ProductModel productModel;
  final double height;
  final double width;
  const ProductCardWidget({super.key, required this.productModel, required this.height, required this.width});

  @override
  State<ProductCardWidget> createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<ProductCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              GestureDetector(
                onTap:(){
                  Get.to(()=> ProductDetailScreen(productModel: widget.productModel));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: CachedNetworkImage(
                    imageUrl: widget.productModel.productImages[0],
                    height: widget.height,
                    width: widget.width,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CupertinoActivityIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    fadeInDuration: const Duration(milliseconds: 500),
                  ),
                ),
              ),
              SizedBox(
                width: 150,
                child: Text(
                  widget.productModel.productName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppConstant.appTextColor,
                    fontSize: 13,
                  ),
                ),
              ),
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
                        decorationThickness: 3),
                  ),
                  Text(
                    '  ${widget.productModel.salePrice}',
                    style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

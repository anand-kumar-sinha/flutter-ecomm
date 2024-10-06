import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecomm/models/product_model.dart';
import 'package:ecomm/utils/app_constant.dart';
import 'package:ecomm/widgets/category_widget.dart';
import 'package:ecomm/widgets/flash_sale_widget.dart';
import 'package:ecomm/widgets/heading_widget.dart';
import 'package:ecomm/widgets/similar_product_widget.dart';
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
  @override
  Widget build(BuildContext context) {
    int salePriceInt = ((int.parse(widget.productModel.salePrice) *
                100 /
                int.parse(widget.productModel.fullPrice)) -
            100)
        .toInt()
        .abs();
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
                                        color: Colors.white,
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
                          RatingBar.builder(
                            initialRating: 3,
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
                            onRatingUpdate: (rating) {},
                          ),

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
                          
                          widget.productModel.isSale?  Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Container(
                              padding: const  EdgeInsets.all(6),
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
                          ): const SizedBox(),
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
                    onPressed: () {},
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
                    onPressed: () {},
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
}

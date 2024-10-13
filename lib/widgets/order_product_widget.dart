import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecomm/models/order_model.dart';
import 'package:ecomm/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderProductWidget extends StatefulWidget {
  final OrderModel orderModel;
  final User? user;
  const OrderProductWidget({super.key, required this.orderModel, this.user});

  @override
  State<OrderProductWidget> createState() => _OrderProductWidgetState();
}

class _OrderProductWidgetState extends State<OrderProductWidget> {
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
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

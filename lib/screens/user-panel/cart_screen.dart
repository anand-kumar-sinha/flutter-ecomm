import 'package:ecomm/utils/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
        title: const Text(
          'Cart',
          style: TextStyle(
            color: AppConstant.appTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: AppConstant.appMainColor,
        height: Get.height,
        child: ListView.builder(
          itemCount: 20,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppConstant.appSecondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(color: AppConstant.appMainColor),
              ),
              child: const ListTile(
                leading: CircleAvatar(
                  child: Text('N'),
                ),
                title: Text('New Dress for womens'),
                subtitle: Row(
                  children: [
                    CircleAvatar(
                      radius: 11,
                      child: Text('-'),
                    ),
                    SizedBox(width: 8),
                    Text('5'),
                    SizedBox(width: 8),
                    CircleAvatar(
                      radius: 11,
                      child: Text('+'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
          height: 50,
          decoration: const BoxDecoration(
              color: AppConstant.appMainColor,
              border: BorderDirectional(
                top: BorderSide(color: Colors.red, width: 1),
              )),
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Total: ',
                  ),
                  Text(
                    '999',
                    style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Colors.red,
                        decorationThickness: 3),
                  ),
                  Text(
                    '  799',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                    color: AppConstant.appSecondaryColor,
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(20)),
                width: Get.width / 3,
                height: Get.height / 12,
                child: TextButton.icon(
                  icon: const Icon(
                    Icons.shopping_cart_checkout,
                    color: Colors.red,
                  ),
                  onPressed: () {},
                  label: const Text(
                    'Check out',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

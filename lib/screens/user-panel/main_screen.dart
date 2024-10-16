import 'package:ecomm/screens/user-panel/all_categories_screen.dart';
import 'package:ecomm/screens/user-panel/all_flash_sale_screen.dart';
import 'package:ecomm/screens/user-panel/all_product_screen.dart';
import 'package:ecomm/screens/user-panel/cart_screen.dart';
import 'package:ecomm/utils/app_constant.dart';
import 'package:ecomm/widgets/all_product_widget.dart';
import 'package:ecomm/widgets/banner_widget.dart';
import 'package:ecomm/widgets/category_widget.dart';
import 'package:ecomm/widgets/custom_drawer_widget.dart';
import 'package:ecomm/widgets/flash_sale_widget.dart';
import 'package:ecomm/widgets/heading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppConstant.appTextColor),
        backgroundColor: AppConstant.appMainColor,
        title: Text(AppConstant.appMainName,
            style: const TextStyle(
              color: AppConstant.appTextColor,
              fontWeight: FontWeight.bold,
            )),
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
      drawer: const CustomDrawerWidget(),
      body: Container(
        color: AppConstant.appMainColor,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // const SizedBox(height: 7),
              //search bar
              Container(
                padding: const EdgeInsets.all(8),
                child: SearchAnchor.bar(
                  suggestionsBuilder: (context, controller) => {},
                  barBackgroundColor:
                      const WidgetStatePropertyAll(Color.fromARGB(0, 255, 255, 255)),
                  barElevation: const WidgetStatePropertyAll(0),
                  barHintText: 'Search...',
                  barSide: const WidgetStatePropertyAll(BorderSide(color: AppConstant.appMainColor, width: 1)),
                  barLeading: const Icon(Icons.search_rounded, color: Colors.red,),
                  viewBackgroundColor: Colors.pink[200],
                ),
              ),
              const SizedBox(height: 7),

              //banner
              const BannerWidget(),
              //heading
              HeadingWidget(
                headingSubTitle: 'Budget',
                headingTitle: 'Categories',
                buttonText: 'See more >',
                onTap: () {
                  Get.to(() => const AllCategoriesScreen());
                },
              ),

              //category
              const CategoryWidget(),

              //flash sale heading
              HeadingWidget(
                headingSubTitle: 'Budget',
                headingTitle: 'Flash Sale',
                buttonText: 'See more >',
                onTap: () {
                  Get.to(() => const AllFlashSaleScreen());
                },
              ),

              //flash sale category
              const FlashSaleWidget(),

              //All product heading
              HeadingWidget(
                headingSubTitle: 'Budget',
                headingTitle: 'All Products',
                buttonText: 'See more >',
                onTap: () {
                  Get.to(() => const AllProductScreen());
                },
              ),

              //All product category
              const AllProductWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

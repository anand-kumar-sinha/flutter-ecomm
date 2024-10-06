import 'package:ecomm/screens/user-panel/all_categories_screen.dart';
import 'package:ecomm/screens/user-panel/all_flash_sale_screen.dart';
import 'package:ecomm/screens/user-panel/all_product_screen.dart';
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
      ),
      drawer: const CustomDrawerWidget(),
      body: Container(
        color: AppConstant.appMainColor,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
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
                headingTitle: 'Flash Sale',
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

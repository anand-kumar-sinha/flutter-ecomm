import 'package:ecomm/utils/app_constant.dart';
import 'package:ecomm/widgets/banner_widget.dart';
import 'package:ecomm/widgets/category_widget.dart';
import 'package:ecomm/widgets/custom_drawer_widget.dart';
import 'package:ecomm/widgets/heading_widget.dart';
import 'package:flutter/material.dart';

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
                headingSubTitle: 'Low Budget',
                headingTitle: 'Categories',
                buttonText: 'See more >',
                onTap: () {},
              ),

              //category
             CategoryWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

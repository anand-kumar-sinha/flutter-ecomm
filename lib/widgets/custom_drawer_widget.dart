import 'package:ecomm/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDrawerWidget extends StatefulWidget {
  const CustomDrawerWidget({super.key});

  @override
  State<CustomDrawerWidget> createState() => _CustomDrawerWidgetState();
}

class _CustomDrawerWidgetState extends State<CustomDrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Get.height / 23, bottom: 1),
      child: Drawer(
        backgroundColor: AppConstant.appSecondaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0)),
        ),
        child: Wrap(
          runSpacing: 10,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                subtitleTextStyle: const TextStyle(
                    color: AppConstant.appTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
                titleTextStyle: const TextStyle(
                    color: AppConstant.appTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                title: Text(AppConstant.appMainName),
                subtitle: Text(AppConstant.appVersion +
                    " " +
                    '(' +
                    AppConstant.appPoweredBy +
                    ')'),
                leading: const CircleAvatar(
                  radius: 22,
                  backgroundColor: AppConstant.appMainColor,
                  child: Text('data'),
                ),
              ),
            ),
            const Divider(
              indent: 8,
              endIndent: 8,
              thickness: 1.5,
              color: AppConstant.appMainColor,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                titleTextStyle: TextStyle(
                    color: AppConstant.appTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                title: Text('Home'),
                leading: Icon(Icons.home_rounded),
                iconColor: AppConstant.appTextColor,
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                titleTextStyle: TextStyle(
                    color: AppConstant.appTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                title: Text('Products'),
                leading: Icon(Icons.production_quantity_limits_rounded),
                iconColor: AppConstant.appTextColor,
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                titleTextStyle: TextStyle(
                    color: AppConstant.appTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                title: Text('Orders'),
                leading: Icon(Icons.shopping_bag),
                iconColor: AppConstant.appTextColor,
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                titleTextStyle: TextStyle(
                    color: AppConstant.appTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                title: Text('Contact'),
                leading: Icon(Icons.help),
                iconColor: AppConstant.appTextColor,
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                titleTextStyle: TextStyle(
                    color: AppConstant.appTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                title: Text('Logout'),
                leading: Icon(Icons.logout),
                iconColor: AppConstant.appTextColor,
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

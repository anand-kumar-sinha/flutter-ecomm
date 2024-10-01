import 'package:flutter/material.dart';
import '../utils/app_constant.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Center(
          child: Text(AppConstant.appMainName,
              style: const TextStyle(
                color: AppConstant.appTextColor,
                fontWeight: FontWeight.bold,
              )),
        ));
  }
}

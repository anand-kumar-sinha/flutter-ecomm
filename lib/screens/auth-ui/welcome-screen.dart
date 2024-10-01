import 'package:ecomm/utils/app_constant.dart';
import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppConstant.appMainColor,
          title: Center(
            child: Text(AppConstant.appMainName,
                style: const TextStyle(
                  color: AppConstant.appTextColor,
                  fontWeight: FontWeight.bold,
                )),
          )),
    );
  }
}

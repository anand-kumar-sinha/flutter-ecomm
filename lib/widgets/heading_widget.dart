import 'package:ecomm/utils/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HeadingWidget extends StatelessWidget {
  final String headingTitle;
  final String headingSubTitle;
  final String buttonText;
  final VoidCallback onTap;
  const HeadingWidget(
      {super.key,
      required this.buttonText,
      required this.headingSubTitle,
      required this.headingTitle,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headingTitle,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 16),
                ),
                Text(
                  headingSubTitle,
                  style: const TextStyle(
                      color: AppConstant.appTextColor, fontSize: 12),
                ),
              ],
            ),
            GestureDetector(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppConstant.appTextColor, width: 1.5),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      color: AppConstant.appTextColor,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

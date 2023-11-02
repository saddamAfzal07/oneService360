import 'package:flutter/material.dart';
import 'package:measurment_app/res/constant/colors.dart';

class CustomAppBar extends StatelessWidget {
  String title;
  CustomAppBar(this.title);
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 65,
      decoration: const BoxDecoration(
        color: AppColors
            .primaryColor, // Change the background color to your desired color.
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.whitedColor,
              ),
            ),
            const SizedBox(
              height: 6,
            )
          ],
        ),
      ),
    );
  }
}

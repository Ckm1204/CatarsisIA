
import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/fonts.dart';



class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
  });

  final String image, title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.secondaryBackground,
      padding: const EdgeInsets.all(AppSizes.defaultSpace),
      child: Column(
        children: [
          Image(
            width: HelperFunctions.screenWidth() * 0.8,
            height: HelperFunctions.screenHeight() * 0.6,
            image: AssetImage(image),
          ),
          Text(
            title,
            style: const TextStyle(
              fontFamily: AppFonts.primaryFont,
              fontSize: AppSizes.lg,
              fontWeight: AppFonts.bold,
              color: AppColors.light,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.spaceBtwItems),
          Text(
            subTitle,
            style: const TextStyle(
              fontFamily: AppFonts.secondaryFont,
              fontSize: AppSizes.md,
              color: AppColors.light,

            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
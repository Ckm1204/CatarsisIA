
import 'package:app_catarsis/modules/onboarding/widgets/onboarding_dot_navigation.dart';
import 'package:app_catarsis/modules/onboarding/widgets/onboarding_elevated_button.dart';
import 'package:app_catarsis/modules/onboarding/widgets/onboarding_page.dart';
import 'package:app_catarsis/modules/onboarding/widgets/onboarding_skip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../utils/constants/image_strings.dart';
import '../../utils/constants/text_strings.dart';
import 'controllers/onboarding_controller.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());

    return Scaffold(
      body: Stack(
        children: [
          /// Horizontal scrollable pages
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: [
              OnBoardingPage(
                image: AppImage.onBoardingImage1,
                title: AppText.onBoardingTitle1,
                subTitle: AppText.onBoardingSubTitle1,
              ),
              OnBoardingPage(
                image: AppImage.onBoardingImage2,
                title: AppText.onBoardingTitle2,
                subTitle: AppText.onBoardingSubTitle2,
              ),
              OnBoardingPage(
                image: AppImage.onBoardingImage3,
                title: AppText.onBoardingTitle3,
                subTitle: AppText.onBoardingSubTitle3,
              ),
            ],
          ),

          /// Skip button
          const OnBoardingSkip(),

          /// Dot navigation SmoothPageIndicator
          const OnBoardingDotNavigation(),

          /// Circular button
          const OnBoardingElevatedButton(),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';


import '../../../utils/constants/sizes.dart';
import '../../../utils/device/device_utility.dart';
import '../controllers/onboarding_controller.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;

    return Positioned(
      top: DeviceUtils.getAppBarHeight(),
      right: AppSizes.defaultSpace,
      child: TextButton(
        onPressed: () => controller.skipPage(),
        child: const Text('Salir'),
      ),
    );
  }
}

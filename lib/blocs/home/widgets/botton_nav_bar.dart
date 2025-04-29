// lib/modules/home/widgets/bottom_nav_bar.dart
import 'package:flutter/material.dart';
import '../../../utils/constants/text_strings.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // Añadir esta línea
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: AppText.home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.star),
          label: AppText.search,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.data_thresholding_outlined),
          label: AppText.profile,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: AppText.profile,
        ),

      ],
    );
  }
}
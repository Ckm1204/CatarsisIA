// lib/modules/home/pages/home_screen.dart
import 'package:app_catarsis/blocs/chat/pages/chat_ia_page.dart';
import 'package:app_catarsis/blocs/profile/pages/view_profile_screen.dart';
import 'package:app_catarsis/blocs/progress/pages/progress_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../help_module/pages/grounding_page.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/botton_nav_bar.dart';
import 'home_content_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Widget> _screens = [

    ChatIAPage(),

    //HomeContentScreen(),
    GroundingPage(),

    ProgressPage(),

    ViewProfileScreen(),

  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Scaffold(
            body: _screens[state.currentIndex],
            bottomNavigationBar: BottomNavBar(
              currentIndex: state.currentIndex,
              onTap: (index) {
                context.read<HomeBloc>().add(NavigationIndexChanged(index));
              },
            ),
          );
        },
      ),
    );
  }
}
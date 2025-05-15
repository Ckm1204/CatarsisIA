// lib/blocs/question_profile/pages/profile_page.dart


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../question_profile/bloc/profile_bloc.dart';
import '../../question_profile/pages/profile_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
        FirebaseFirestore.instance,
        FirebaseAuth.instance.currentUser!.uid,
      ),
      child: const ProfileScreen(),
    );
  }
}
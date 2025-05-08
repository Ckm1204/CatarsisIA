// lib/blocs/view_profile/pages/view_profile_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../blocs/view_profile_bloc.dart';
import '../blocs/view_profile_event.dart';
import '../blocs/view_profle_state.dart';

// lib/blocs/view_profile/pages/view_profile_screen.dart
class ViewProfileScreen extends StatelessWidget {
  const ViewProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ViewProfileBloc()..add(LoadProfile()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Mi Perfil')),
        body: BlocBuilder<ViewProfileBloc, ViewProfileState>(
          builder: (context, state) {
            if (state is ViewProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ViewProfileError) {
              return Center(child: Text(state.message));
            }

            if (state is ViewProfileLoaded) {
              final profile = state.profile;
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildInfoTile('Fecha de nacimiento',
                      DateFormat('dd/MM/yyyy').format(profile.birthDate)),
                  _buildInfoTile('Género', profile.gender),
                  _buildInfoTile('Nivel educativo', profile.educationLevel),
                  _buildInfoTile('Ocupación', profile.occupation),
                  _buildInfoTile('Nivel socioeconómico', profile.socioeconomicLevel),
                  _buildInfoTile('Apoyo emocional', profile.emotionalSupport),
                  _buildInfoTile('Situación de vivienda', profile.livingSituation),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/profile_initial');
                    },
                    child: const Text('Editar datos'),
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              )),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              )),
          const Divider(),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/view_profile_bloc.dart';
import '../blocs/view_profile_event.dart';
import '../blocs/view_profle_state.dart';

class ViewProfileScreen extends StatelessWidget {
  const ViewProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ViewProfileBloc()..add(LoadProfile()),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Mi Perfil', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => Navigator.of(context).pushReplacementNamed('/profile_initial'),
            ),
          ],
        ),
        body: BlocBuilder<ViewProfileBloc, ViewProfileState>(
          builder: (context, state) {
            if (state is ViewProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ViewProfileError) {
              return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
            }

            if (state is ViewProfileLoaded) {
              final profile = state.profile;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Tarjeta de información principal
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [

                            const SizedBox(height: 20),
                            _buildProfileInfoItem(
                              icon: Icons.people,
                              label: 'Género',
                              value: profile.gender,
                            ),
                            _buildProfileInfoItem(
                              icon: Icons.school,
                              label: 'Nivel educativo',
                              value: profile.educationLevel,
                            ),
                            _buildProfileInfoItem(
                              icon: Icons.work,
                              label: 'Ocupación',
                              value: profile.occupation,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Tarjeta de información adicional
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            _buildProfileInfoItem(
                              icon: Icons.attach_money,
                              label: 'Nivel socioeconómico',
                              value: profile.socioeconomicLevel,
                            ),
                            _buildProfileInfoItem(
                              icon: Icons.favorite,
                              label: 'Apoyo emocional',
                              value: profile.emotionalSupport,
                            ),
                            _buildProfileInfoItem(
                              icon: Icons.home,
                              label: 'Situación de vivienda',
                              value: profile.livingSituation,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Botón de edición (alternativo al icono del appbar)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.edit),
                        label: const Text('Editar perfil'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/profile_initial');
                        },
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildProfileInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// lib/blocs/question_profile/pages/profile_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/user_profile_model.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _birthDate;
  String? _gender;
  String? _educationLevel;
  String? _occupation;
  String? _socioeconomicLevel;
  String? _emotionalSupport;
  String? _livingSituation;
  final _otherGenderController = TextEditingController();
  final _otherOccupationController = TextEditingController();
  final _otherLivingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSuccess) {
          Navigator.of(context).pushReplacementNamed('/home');
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Perfil inicial'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
              ),
            ),            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Fecha de nacimiento*',
                        style: Theme.of(context).textTheme.titleMedium),
                    ListTile(
                      title: Text(_birthDate == null
                          ? 'Seleccionar fecha'
                          : DateFormat('dd/MM/yyyy').format(_birthDate!)),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () => _selectDate(context),
                    ),
                    if (_birthDate == null)
                      const Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          'La fecha de nacimiento es requerida',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    _buildRadioSection(
                      title: '¿Con qué género te identificas?*',
                      options: const [
                        'Masculino',
                        'Femenino',
                        'No binario',
                        'Prefiero no decirlo',
                        'Otro'
                      ],
                      value: _gender,
                      onChanged: (value) => setState(() => _gender = value),
                      otherController: _otherGenderController,
                      isRequired: true,
                    ),
                    _buildRadioSection(
                      title: '¿Cuál es tu nivel educativo más alto alcanzado?*',
                      options: const [
                        'Primaria',
                        'Secundaria',
                        'Técnico/Tecnólogo',
                        'Universitario',
                        'Posgrado',
                        'Prefiero no decirlo'
                      ],
                      value: _educationLevel,
                      onChanged: (value) => setState(() => _educationLevel = value),
                      isRequired: true,
                    ),
                    _buildRadioSection(
                      title: '¿Cuál es tu ocupación actual?*',
                      options: const [
                        'Estudiante',
                        'Empleado',
                        'Independiente',
                        'Desempleado',
                        'Otro'
                      ],
                      value: _occupation,
                      onChanged: (value) => setState(() => _occupation = value),
                      otherController: _otherOccupationController,
                      isRequired: true,
                    ),
                    _buildRadioSection(
                      title: '¿Cuál es tu nivel socioeconómico?*',
                      options: const [
                        'Bajo',
                        'Medio-bajo',
                        'Medio',
                        'Medio-alto',
                        'Alto',
                        'Prefiero no decirlo'
                      ],
                      value: _socioeconomicLevel,
                      onChanged: (value) => setState(() => _socioeconomicLevel = value),
                      isRequired: true,
                    ),
                    _buildRadioSection(
                      title: '¿Tienes acceso frecuente a apoyo emocional o psicológico?*',
                      options: const [
                        'Sí',
                        'No',
                        'Prefiero no decirlo'
                      ],
                      value: _emotionalSupport,
                      onChanged: (value) => setState(() => _emotionalSupport = value),
                      isRequired: true,
                    ),
                    _buildRadioSection(
                      title: '¿Vives solo/a o acompañado/a?*',
                      options: const [
                        'Solo/a',
                        'Con familia',
                        'Con pareja',
                        'Con compañeros de cuarto',
                        'Otro'
                      ],
                      value: _livingSituation,
                      onChanged: (value) => setState(() => _livingSituation = value),
                      otherController: _otherLivingController,
                      isRequired: true,
                    ),
                    const SizedBox(height: 32),
                    if (state is ProfileLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitForm,

                          child: const Text('Guardar perfil'),

                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },


    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (date != null) setState(() => _birthDate = date);
  }

  Widget _buildRadioSection({
    required String title,
    required List<String> options,
    required String? value,
    required ValueChanged<String?> onChanged,
    TextEditingController? otherController,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        ...options.map((option) => RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: value,
              onChanged: onChanged,
            )),
        if (value == 'Otro' && otherController != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              controller: otherController,
              decoration: const InputDecoration(
                labelText: 'Especificar',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Este campo es requerido' : null,
            ),
          ),
        if (isRequired && value == null)
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              'Este campo es requerido',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _submitForm() {
    if (_birthDate == null ||
        _gender == null ||
        _educationLevel == null ||
        _occupation == null ||
        _socioeconomicLevel == null ||
        _emotionalSupport == null ||
        _livingSituation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor complete todos los campos requeridos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      final profile = UserProfile(
        birthDate: _birthDate!,
        gender: _gender == 'Otro' ? _otherGenderController.text : _gender!,
        educationLevel: _educationLevel!,
        occupation: _occupation == 'Otro'
            ? _otherOccupationController.text
            : _occupation!,
        socioeconomicLevel: _socioeconomicLevel!,
        emotionalSupport: _emotionalSupport!,
        livingSituation: _livingSituation == 'Otro'
            ? _otherLivingController.text
            : _livingSituation!,
      );


      context.read<ProfileBloc>().add(SaveProfileData(profile));
    }
  }
}
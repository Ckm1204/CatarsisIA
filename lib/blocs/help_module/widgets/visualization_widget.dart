import 'package:flutter/material.dart';
import 'dart:async';
import 'package:confetti/confetti.dart';

class VisualizationWidget extends StatefulWidget {
  const VisualizationWidget({super.key});

  @override
  State<VisualizationWidget> createState() => _VisualizationWidgetState();
}

class _VisualizationWidgetState extends State<VisualizationWidget>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  int _currentPhase = 0;
  bool _eyesClosed = false;
  double _breathProgress = 0.0;
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Timer _breathTimer;
  bool _isBreathingIn = true;
  bool _showNature = false;
  late ConfettiController _confettiController;

  final List<Map<String, dynamic>> _phases = [
    {
      "title": "Prepara tu espacio",
      "description": "Busca una posición cómoda y relaja tu cuerpo",
      "icon": Icons.accessibility_new,
      "bgColor": Colors.deepPurple.shade50,
    },
    {
      "title": "Cierra los ojos",
      "description": "Deja que tu respiración se haga lenta y profunda",
      "icon": Icons.visibility_off,
      "bgColor": Colors.indigo.shade100,
    },
    {
      "title": "Siente tu respiración",
      "description": "Inhala... Exhala... Sigue el ritmo natural",
      "icon": Icons.air,
      "bgColor": Colors.blue.shade100,
    },
    {
      "title": "Visualiza tu santuario",
      "description": "Imagina un lugar que te transmita paz absoluta",
      "icon": Icons.landscape,
      "bgColor": Colors.lightBlue.shade100,
    },
    {
      "title": "Explora con todos tus sentidos",
      "description": "¿Qué ves? ¿Qué escuchas? ¿Qué aromas hay?",
      "icon": Icons.color_lens,
      "bgColor": Colors.teal.shade50,
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _confettiController = ConfettiController(duration: const Duration(seconds: 5));

    _startBreathAnimation();
  }

  void _startBreathAnimation() {
    _breathTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        if (_isBreathingIn) {
          _breathProgress += 0.01;
          if (_breathProgress >= 1.0) _isBreathingIn = false;
        } else {
          _breathProgress -= 0.01;
          if (_breathProgress <= 0.0) _isBreathingIn = true;
        }
      });
    });
  }

  void _nextPhase() {
    if (_currentPhase < _phases.length - 1) {
      setState(() {
        _currentPhase++;
        _eyesClosed = _currentPhase >= 1;
        if (_currentPhase == 3) {
          _showNature = true;
          _fadeController.forward();
        }
      });
    } else {
      _confettiController.play();
    }
  }

  void _prevPhase() {
    if (_currentPhase > 0) {
      setState(() {
        _currentPhase--;
        _eyesClosed = _currentPhase >= 1;
        if (_currentPhase < 3) _showNature = false;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pulseController.dispose();
    _fadeController.dispose();
    _breathTimer.cancel();
    _confettiController.dispose();
    super.dispose();
  }

  Widget _buildNatureScene() {
    return FadeTransition(
      opacity: _fadeController,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
            image: AssetImage('assets/nature_scene.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _phases[_currentPhase]["bgColor"],
                  Colors.white,
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green, Colors.blue, Colors.purple,
                Colors.orange, Colors.pink
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: (_currentPhase + 1) / _phases.length,
                          minHeight: 12,
                          backgroundColor: Colors.white.withOpacity(0.4),
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.info_outline),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Guía de Meditación'),
                          content: const Text(
                            'Sigue las instrucciones paso a paso. '
                            'Puedes volver atrás si necesitas más tiempo en cada fase.'
                          ),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () => Navigator.of(ctx).pop(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: Stack(
                    children: [
                      Card(
                        elevation: 12,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(25),
                          child: Column(
                            mainAxisSize: MainAxisSize.min, // Change to min
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ScaleTransition(
                                scale: _pulseController,
                                child: Icon(
                                  _phases[_currentPhase]["icon"],
                                  size: 60, // Reduced from 80
                                  color: Colors.blueAccent,
                                ),
                              ),
                              const SizedBox(height: 20), // Reduced from 30
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                child: Text(
                                  _phases[_currentPhase]["title"],
                                  key: ValueKey(_currentPhase),
                                  style: const TextStyle(
                                    fontSize: 24, // Reduced from 26
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 15), // Reduced from 20
                              Flexible( // Added Flexible
                                child: Text(
                                  _phases[_currentPhase]["description"],
                                  style: TextStyle(
                                    fontSize: 16, // Reduced from 18
                                    color: Colors.grey.shade700,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 20), // Reduced from 30
                              if (_currentPhase == 2)
                                SizedBox( // Added fixed size
                                  height: 150, // Reduced from 180
                                  child: _buildBreathingAnimation(),
                                ),
                              if (_eyesClosed)
                                _buildEyesClosedIndicator(),
                            ],
                          ),
                        ),
                      ),
                      if (_showNature)
                        Positioned.fill(child: _buildNatureScene()),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FloatingActionButton(
                      onPressed: _prevPhase,
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.arrow_back, color: Colors.blueAccent),
                    ),
                    if (_currentPhase == _phases.length - 1)
                      ElevatedButton.icon(
                        icon: const Icon(Icons.download),
                        label: const Text('Guardar Sesión'),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Sesión guardada')),
                          );
                        },
                      ),
                    FloatingActionButton(
                      onPressed: _nextPhase,
                      backgroundColor: Colors.blueAccent,
                      child: Icon(
                        _currentPhase == _phases.length - 1
                            ? Icons.check
                            : Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

Widget _buildBreathingAnimation() {
  return Stack(
    alignment: Alignment.center,
    children: [
      Container(
        width: 150, // Reduced from 150
        height: 150, // Reduced from 150
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.blueAccent.withOpacity(0.3),
            width: 2,
          ),
        ),
      ),
      AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        width: 120 * _breathProgress, // Reduced from 150
        height: 120 * _breathProgress, // Reduced from 150
        constraints: const BoxConstraints(
          minWidth: 40, // Reduced from 50
          minHeight: 40, // Reduced from 50
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blueAccent.withOpacity(0.1),
          border: Border.all(
            color: Colors.blueAccent,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            _isBreathingIn ? "INHALA" : "EXHALA",
            style: const TextStyle(
              fontSize: 20, // Reduced from 22
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
        ),
      ),
    ],
  );
}


  Widget _buildEyesClosedIndicator() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.visibility_off, color: Colors.white),
          SizedBox(width: 10),
          Text(
            "Ojos cerrados...",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
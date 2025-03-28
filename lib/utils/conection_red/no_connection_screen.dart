import 'package:flutter/material.dart';
  import 'package:get/get.dart';

  import 'connectivity_service.dart';

  class NoConnectionScreen extends StatelessWidget {
    const NoConnectionScreen({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return GetBuilder<ConnectivityService>(
        builder: (connectivityService) {
          if (connectivityService.isOffline.value) { // Access the value of the observable
            return Positioned(
              top: 50,
              left: 20,
              right: 20,
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(12),
                color: Colors.red.withOpacity(0.9),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.wifi_off,
                        color: Colors.white,
                        size: 50,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Sin conexión a internet",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Tu conexión es inestable o está desconectada.",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink(); // If there is internet, show nothing
        },
      );
    }
  }
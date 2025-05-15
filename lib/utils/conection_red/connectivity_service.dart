import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxController {
  final Connectivity _connectivity = Connectivity(); // Instancia de la clase Connectivity para verificar el estado de la conexión.
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none]; // Estado de la conexión.
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription; // Suscripción al stream de cambios de conectividad.

  /// Estado de la conexión (true = sin internet)
  var isOffline = false.obs; // Observable para el estado de conexión.

  @override
  void onInit() {
    super.onInit();
    _checkInitialConnection(); // Verifica el estado inicial de la conexión.
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus); // Escucha los cambios en la conectividad.
  }

  /// Verifica el estado inicial de la conexión
  Future<void> _checkInitialConnection() async {
    var result = await _connectivity.checkConnectivity(); // Verifica el estado inicial de la conexión.
    _updateConnectionStatus(result); // Actualiza el estado de la conexión.
  }

  /// Cambia el estado cuando hay o no conexión
  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    _connectionStatus = result; // Actualiza el estado de la conexión.
    update(); // Notifica a la UI del cambio.
    // ignore: avoid_print
    print('Connectivity changed: $_connectionStatus'); // Imprime el estado de la conexión.
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel(); // Cancela la suscripción al stream de cambios de conectividad.
    super.dispose();
  }
}
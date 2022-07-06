import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:get/get.dart';

// Esta classe define os métodos para manipulação do bluetooth através do plugin flutter_beacon
class RequirementStateController extends GetxController {
  final bluetoothState = BluetoothState.stateOff.obs; // Estado do bluetooth
  final _startScanning = false.obs; // Flag para iniciar o escaneamento
  final _pauseScanning = false.obs; // Flag para pausar o escaneamento

  bool get bluetoothEnabled => bluetoothState.value == BluetoothState.stateOn;  // Retorna se o bluetooth está ligado

  atualizaEstadoBluetooth(BluetoothState state) {
    bluetoothState.value = state;
  }

  // Inicia o escaneamento de beacons
  iniciaEscaneamento() {
    _startScanning.value = true;
    _pauseScanning.value = false;
  }

  // Pausa o escaneamento de beacons
  pausaEscaneamento() {
    _startScanning.value = false;
    _pauseScanning.value = true;
  }

  Stream<bool> get iniciaStream { // Retorna o stream de iniciar o escaneamento
    return _startScanning.stream;
  }
 
  Stream<bool> get pausaStream { // Retorna o stream de pausar o escaneamento
    return _pauseScanning.stream;
  }
}

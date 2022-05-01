import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:get/get.dart';

class RequirementStateController extends GetxController {
  final bluetoothState = BluetoothState.stateOff.obs;
  final _startScanning = false.obs;
  final _pauseScanning = false.obs;

  bool get bluetoothEnabled => bluetoothState.value == BluetoothState.stateOn;
  

  updateBluetoothState(BluetoothState state) {
    bluetoothState.value = state;
  }

  

  startScanning() {
    _startScanning.value = true;
    _pauseScanning.value = false;
  }

  pauseScanning() {
    _startScanning.value = false;
    _pauseScanning.value = true;
  }

  Stream<bool> get startStream {
    return _startScanning.stream;
  }

  Stream<bool> get pauseStream {
    return _pauseScanning.stream;
  }
}

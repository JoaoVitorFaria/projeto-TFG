// -------------------------------------importacoes-------------------------------------
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:beacon/controller/controller_bluetooth.dart';
import 'package:beacon/view/view_scan.dart';
import 'package:get/get.dart';
import 'dart:developer';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final controller = Get.find<RequirementStateController>();
  StreamSubscription<BluetoothState>? _streamBluetooth;
  int currentIndex = 0;
  String retorno = ' ';

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    esperaEstadoBluetooth();
  }

  esperaEstadoBluetooth() async {
    _streamBluetooth = flutterBeacon.bluetoothStateChanged().listen((BluetoothState state) async {
      controller.atualizaEstadoBluetooth(state);
      await verificaParametroApp();
    });
  }

  verificaParametroApp() async {
    final bluetoothState = await flutterBeacon.bluetoothState;
    controller.atualizaEstadoBluetooth(bluetoothState);
    _streamBluetooth.printInfo();

    if (controller.bluetoothEnabled) {
      if (currentIndex == 0) {
        controller.iniciaEscaneamento();
      }
    } else {
      controller.pausaEscaneamento(); 
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (_streamBluetooth != null) {
        if (_streamBluetooth!.isPaused) {
          _streamBluetooth?.resume();
        }
      }
      await verificaParametroApp();
    } else if (state == AppLifecycleState.paused) {
      _streamBluetooth?.pause(); 
    }
  }

  @override
  void dispose() {
    _streamBluetooth?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projeto'), 
        centerTitle: false,
        actions: <Widget>[
          Obx(() {
            final state = controller
                .bluetoothState.value; 

            if (state == BluetoothState.stateOn) {
              return IconButton(
                tooltip:
                    'Bluetooth ligado',
                icon: const Icon(Icons.bluetooth_connected),
                onPressed: () {},
                color:
                    Colors.lightBlueAccent, 
              );
            }

            if (state == BluetoothState.stateOff) {
              return IconButton(
                tooltip: 'Bluetooth desligado',
                icon: const Icon(Icons.bluetooth),
                onPressed:
                    handleOpenBluetooth, 
                color: Colors.red,
              );
            }

            return IconButton(
              icon: const Icon(Icons
                  .bluetooth_disabled), 
              tooltip: 'Bluetooth não disponível', 
              onPressed: () {},
              color: Colors.grey,
            );
          }),
        ],
      ),
      body: IndexedStack(
      
        index: currentIndex,
        children: const [
          TabScanning(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
          if (currentIndex == 0) {
           
            controller.iniciaEscaneamento();
          } else {
            controller.pausaEscaneamento();
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Escanear',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pause),
            label: 'Pausar',
          ),
        ],
      ),
    );
  }

  handleOpenBluetooth() async {
    if (Platform.isAndroid) {
      try {
        await flutterBeacon.openBluetoothSettings;
      } on PlatformException catch (e) {
        log(e.toString());
      }
    }
  }
}

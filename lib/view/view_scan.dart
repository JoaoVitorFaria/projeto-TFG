import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:beacon/controller/controller_bluetooth.dart';
import 'package:get/get.dart';

class TabScanning extends StatefulWidget { //StatuefulWidget fornece informações mutáveis e cria um state object
  @override //Sobrescreve o método build, pois a classe é abstrata
  _TabScanningState createState() => _TabScanningState(); //Cria um estado mutável para a widget
}

class _TabScanningState extends State<TabScanning> {
  StreamSubscription<RangingResult>? _streamRanging; //Cria um objeto que providencia um listener para os eventos do stream e segura os callbacks para lidar com eles
  final _regionBeacons = <Region, List<Beacon>>{}; //Variável do tipo Region em uma lista de objetos do tipo Beacon
  final _beacons = <Beacon>[]; //Lista de objetos Beacon
  final controller = Get.find<RequirementStateController>(); //Variável que contém a classe com ps métodos de scanning do bluetooth

  @override
  void initState() { //Função para iniciar o estado
    super.initState(); //Método que é chamado uma vez que a stateful widget é inserida na árvore de widget, função de inicialização

    controller.iniciaStream.listen((flag) { //Chama o método que inicia o stream, da classe RequirementStateController e escuta a flag de resposta
      if (flag == true) { //Testa o valor da flag
        iniciaScanBeacon(); //Chama a função para iniciar o scan do beacon
      }
    });

    controller.pausaStream.listen((flag) { //Chama o método que pausa o stream, da classe RequirementStateController e escuta a flag de resposta
      if (flag == true) { //Testa o valor da flag
        pausaScanBeacon(); //Chama a função para pausar o scan do beacon
      }
    });
  }

  iniciaScanBeacon() async { //Função assíncrona que inicia o scan do beacon
    await flutterBeacon.initializeScanning; //Instância única ao método de scan da API flutter beacon
    if (!controller.bluetoothEnabled) { //Teste do estado do bluetooth (desabilitado)
      print(
          'bluetoothAtivado=${controller.bluetoothEnabled}'); //Imprime o valor da variável
      return;
    }

    final regions = <Region>[ //Lista de objetos
      Region(
        identifier: 'Cubeacon', //Identificador de cada região (único)
        proximityUUID: 'CB10023F-A318-3394-4199-A8730C7C1AEC', //Identificador exclusivo universal da região
      ),
      Region(
        identifier: 'BeaconType2',
        proximityUUID: '6a84c716-0f2a-1ce9-f210-6a63bd873dd9',
      ),
    ];

    if (_streamRanging != null) { //Testa o valor do objeto de StreaSubscription
      if (_streamRanging!.isPaused) { //Testa se o objeto não está 'pausado' (retorna verdadeiro se houver mais chamadas para pausar que para retomar ou retorna falso se o stream ainda pode emitir eventos)
        _streamRanging?.resume(); //Resume a inscrição
        return;
      }
    }

    _streamRanging =
      flutterBeacon.ranging(regions).listen((RangingResult result) { //Começa a variar as regiões da lista adicionado uma inscrição que escuta o resultado da classe para gerenciar o resultado da varredura  
      print(result); //Imprime o resultado
      if (mounted) { //Testa se o state object está na árvore de widget
        setState(() { //Notifica o framework que o estado do objeto mudou
          _regionBeacons[result.region] = result.beacons; //Atribui as regiões do resultado
          _beacons.clear(); //Limpa a lista de beacons
          _regionBeacons.values.forEach((list) { //Faz um laço para cada um dos valores da lista de regiões
            _beacons.addAll(list); //Adiciona à lista de beacons
          });
          _beacons.sort(_compareParameters); //Ordena is beacons de acordo com os parâmetros
        });
      }
    });
  }

  pausaScanBeacon() async { //Função assíncrona que pausa o scanning do beacon
    _streamRanging?.pause(); //Pausa o stream
    if (_beacons.isNotEmpty) { //Testa se a lista de beacons não está vazia
      setState(() { //Notifica o framework que o estado do objeto mudou
        _beacons.clear(); //Limpa a lista de beacons
      });
    }
  }

  int _compareParameters(Beacon a, Beacon b) { //Variável que determina o parâmetro de ordenação dos beacons
    int compare = a.proximityUUID.compareTo(b.proximityUUID); //Compara o UUID de um beacon ao próximo

    if (compare == 0) { //Compara se os objetos comparados são iguais (valor 0)
      compare = a.major.compareTo(b.major); //Compara o maior valor dos objetos
    }

    if (compare == 0) { //Compara se os objetos comparados são iguais (valor 0)
      compare = a.minor.compareTo(b.minor); //Compara o menor valor dos objetos
    }

    return compare;
  }

  @override
  void dispose() { //Método chamado quando o objeto é removido da árvore
    _streamRanging?.cancel(); //Cancela a incrição e não recebe mais eventos
    super.dispose(); //Método quando o objeto não vai ser construído novamente
  }

  @override
  Widget build(BuildContext context) { //Constroi a widget
    return Scaffold( //Retorna o "esqueleto" da widget
    );
  }
}
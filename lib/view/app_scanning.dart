import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:beacon/controller/requirement_state_controller.dart';
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

    controller.startStream.listen((flag) { //Chama o método que inicia o stream, da classe RequirementStateController e escuta a flag de resposta
      if (flag == true) { //Testa o valor da flag
        initScanBeacon(); //Chama a função para iniciar o scan do beacon
      }
    });

    controller.pauseStream.listen((flag) { //Chama o método que pausa o stream, da classe RequirementStateController e escuta a flag de resposta
      if (flag == true) { //Testa o valor da flag
        pauseScanBeacon(); //Chama a função para pausar o scan do beacon
      }
    });
  }

  initScanBeacon() async { //Função assíncrona que inicia o scan do beacon
    await flutterBeacon.initializeScanning; //Instância única ao método de scan da API flutter beacon
    if (!controller.bluetoothEnabled) { //Teste do estado do bluetooth (desabilitado)
      print(
          'bluetoothEnabled=${controller.bluetoothEnabled}'); //Imprime o valor da variável
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

  pauseScanBeacon() async { //Função assíncrona que pausa o scanning do beacon
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
      body: _beacons.isEmpty //Testa se a lista de beacons está vazia
          ? Center(child: CircularProgressIndicator()) //Se estiver, mostra na tela um ícone animado de carregamento
          : ListView( //Se não estiver, retorna o componente que será mostrado
              children: ListTile.divideTiles( //Divide o componente em grids
                context: context,
                tiles: _beacons.map(
                  (beacon) {
                    return ListTile( //Retorna um 'tile' para cada iteração
                      title: Text( //Define o título como o UUID dregião de cada beacon 
                        beacon.proximityUUID,
                        style: TextStyle(fontSize: 15.0), //Estilização
                      ),
                      subtitle: new Row( //Define o subtítulo de cada linha
                        mainAxisSize: MainAxisSize.max, //Cria um array horizontal de tamanho máximo
                        children: <Widget>[ //Define os filhos como widgets
                          Flexible( //Cria um widget que controla como um filho se flexiona
                            child: Text( //Define o texto do filho
                              'Major: ${beacon.major}\nMinor: ${beacon.minor}', //Imprime o maior e o menor
                              style: TextStyle(fontSize: 13.0), //Estilização
                            ),
                            flex: 1, //Define a posição do flex
                            fit: FlexFit.tight, //Define o posicionamento do flex no espaço
                          ),
                          Flexible( //Cria um widget que controla como um filho se flexiona
                            child: Text( //Define o texto do filho
                              'Accuracy: ${beacon.accuracy}m\nRSSI: ${beacon.rssi}', //Imprime a precisão do beacon
                              style: TextStyle(fontSize: 13.0), //Estilização
                            ),
                            flex: 2, //Define a posição do flex
                            fit: FlexFit.tight, //Define o posicionamento do flex no espaço
                          )
                        ],
                      ),
                    );
                  },
                ),
              ).toList(), //Lista os widgets
            ),
    );
  }
}
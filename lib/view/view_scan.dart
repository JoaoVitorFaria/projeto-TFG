import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:beacon/controller/controller_bluetooth.dart';
import 'package:beacon/controller/controller_distancia.dart';
import 'package:beacon/controller/controller_nodes.dart';
import 'package:get/get.dart';
import 'dart:developer';
import 'package:flutter_tts/flutter_tts.dart';

class TabScanning extends StatefulWidget {
  const TabScanning({Key? key}) : super(key: key);
  //StatuefulWidget fornece informações mutáveis e cria um state object
  @override //Sobrescreve o método build, pois a classe é abstrata
  _TabScanningState createState() =>
      _TabScanningState(); //Cria um estado mutável para a widget
}

class _TabScanningState extends State<TabScanning> {
  StreamSubscription<RangingResult>?_resultadoScan; //Cria um objeto que providencia um listener para os eventos do stream e segura os callbacks para lidar com eles
  final _beaconPorRegiao = <Region,List<Beacon>>{}; //Variável do tipo Region em uma lista de objetos do tipo Beacon
  final _beacons = <Beacon>[]; //Lista de objetos Beacon
  final controller = Get.find<RequirementStateController>(); //Variável que contém a classe com ps métodos de scanning do bluetooth
  final controllerDistancia = Get.find<RequirementDistance>();
  final controllerNodes = Get.find<RequirementNode>();
  final FlutterTts flutterTts = FlutterTts();
  @override
  void initState() {
    //Função para iniciar o estado
    super
        .initState(); //Método que é chamado uma vez que a stateful widget é inserida na árvore de widget, função de inicialização

    controller.iniciaStream.listen((flag) {
      //Chama o método que inicia o stream, da classe RequirementStateController e escuta a flag de resposta
      if (flag == true) {
        //Testa o valor da flag
        iniciaScanBeacon(); //Chama a função para iniciar o scan do beacon
      }
    });

    controller.pausaStream.listen((flag) {
      //Chama o método que pausa o stream, da classe RequirementStateController e escuta a flag de resposta
      if (flag == true) {
        //Testa o valor da flag
        pausaScanBeacon(); //Chama a função para pausar o scan do beacon
      }
    });
  }

  iniciaScanBeacon() async {
    //Função assíncrona que inicia o scan do beacon
    final FlutterTts flutterTts = FlutterTts();
    await flutterTts.setLanguage('pt-BR');
    await flutterTts.setLanguage('pt-BR');
    await flutterTts.setSpeechRate(0.6);
    await flutterTts.setVoice({"name": "pt-BR-Wavenet-B", "locale": "pt-BR"});
    //Os nós, que representam os beacons, serão instanciados aqui
    final no1 = RequirementNode();
    final no2 = RequirementNode();
    final no3 = RequirementNode();
    final no4 = RequirementNode();
    final no5 = RequirementNode();
    final no6 = RequirementNode();
    final no7 = RequirementNode();
    final no8 = RequirementNode();
    final no9 = RequirementNode();
    final no10 = RequirementNode();
    final no11 = RequirementNode();
    final no12 = RequirementNode();
    final no13 = RequirementNode();

    // Nó k
    no1.defineValores(
        01,
        'Você está na porta de entrada do IMC',
        "D7:05:E8:A5:81:6D",
        "Após passar pela porta, siga à esquerda. Há uma rampa, por favor, percorra-a");
    // Nó A
    no2.defineValores(
        02,
        "Você está na rampa de acesso ao segundo andar do IMC ",
        '02',
        "A parede à esquerda terminou pois você chegou na metade da rampa.Por favor, continue subindo a rampa para chegar ao seu destino");
    // Nó B
    no3.defineValores(
        03, 
        "Você está no segundo andar do IMC", 
        "03 ",
        "Para chegar ao banheiro, siga à sua esquerda. Há um corredor, por favor, oriente-se pela parede à sua direita e percorra-o");
    // Nó C
    no4.defineValores(
        04, 
        "Você está próximo a sala de t.i", 
        "04",
        "Voce está no corredor mais longo do IMC. Por favor, percorra-o orientando-se pela parede à sua direita");
    // Nó D
    no5.defineValores(
        05, 
        "Você está próximo ao laboratório de pesquisa", 
        "05",
        "Em breve você encontrará duas esquinas. A Primeira é para a direita, a segunda para esquerda. Por favor, oriente-se pela parede à direita");
    // Nó E
    no6.defineValores(
        06,
        "Você está no corredor de estudos, em frente aos laboratórios de pesquisa",
        '06',
        "Continue percorrendo o corredor. Em breve haverá uma esquina, por favor, siga à direita");
    // Nó F
    no7.defineValores(
        07, 
        "Você está em frente à sala...", 
        '07',
        "Em breve você encontrará duas esquinas. A Primeira é para a direita, a segunda para esquerda. Oriente-se pela parede à direita e percorra o corredor até o final. Por favor, ignore o corredor que está à sua direita");
    // Nó G
    no8.defineValores(
        08, 
        "Você está próximo aos banheiros", 
        '08',
        "Você encontrará duas esquinas. A primeira é para a esquerda e a segunda para a direita. Por favor, oriente-se pela parede à direita e percorra o corredor até o final");
    // Nó H
    no9.defineValores(
        09, 
        "Você está no corredor da secretaria", 
        '09',
        "Vire a esquina à direita e siga em frente. Oriente-se pela parede a esquerda e ignore o primeiro corredor que encontrar. Ao encontrar uma porta, passe por ela e siga em frente");
    // Nó I
    no10.defineValores(
        10, 
        "Você está na secretaria", 
        '10',
        "Parabéns, a secretaria é a primeira porta a sua direita.");
    // Para o teste do beacons referentes os nós 4, 9 e 10 serão reutilizados com as seguintes configurações
    // Equivalente ao Nó 4
    no11.defineValores(
        11, 
        "Você está próximo ao LDC1 e LDC2", 
        "11",
        "Em breve você chegará em uma esquina. Por favor, siga à direita");
    // Equivalente ao Nó 9
    no12.defineValores(
        12, 
        "Você está próximo ao LDC1 e LDC2", 
        "12",
        "Você está próximo aos banheiros. Siga em frente orientado-se pela parede à esquerda");
    // Equivalente ao Nó 10
    no13.defineValores(
        13, 
        "Você está em frente aos banheiros", 
        "14",
        "Parabéns, os banheiros estão à sua direita");

    var destino = ""; //Variável que armazenará o destino do usuário
    destino = "opção 1";
    //destino = controllerInputVoice.getDestino(); //Pega o destino do usuário
    List caminho = []; //Lista que armazenará o caminho do usuário
    if (destino == "opção 1") {
      // Secretaria
      caminho = [
        no1,
        no2,
        no3,
        no4,
        no5,
        no7,
        no8,
        no9,
        no10,
        no11
      ]; // O nó 11 fica no corredor do LDC1 e serve para verificar se errou o caminho
    } else if (destino == "opção 2") {
      // Banheiro
      caminho = [
        no1,
        no2,
        no3,
        no11,
        no11,
        no12,
        no13,
        no4
      ]; // O nó 4 no sentindo da secretaria e serve para verificar se errou o caminho
    }
    log(caminho.toString());

    await flutterBeacon
        .initializeScanning; //Instância única ao método de scan da API flutter beacon
    if (!controller.bluetoothEnabled) {
      //Teste do estado do bluetooth (desabilitado)
      return;
    }
    final regions = <Region>[]; //Lista de regiões
    regions.add(Region(identifier: 'com.beacon'));

    if (_resultadoScan != null) {
      //Testa o valor do objeto de StreaSubscription
      if (_resultadoScan!.isPaused) {
        //Testa se o objeto não está 'pausado' (retorna verdadeiro se houver mais chamadas para pausar que para retomar ou retorna falso se o stream ainda pode emitir eventos)
        _resultadoScan?.resume(); //Retoma o stream
        return;
      }
    }

    var atual = 0;
    

    _resultadoScan = flutterBeacon.ranging(regions).listen((RangingResult result) {
      //Inicia o scaneamento de beacons
      _beaconPorRegiao[result.region] = result.beacons; //Adiciona o beacon na lista de beacons por região
      _beaconPorRegiao.values.forEach((list) {
        //Percorre a lista de beacons por região
        _beacons.addAll(list); //Adiciona todos os beacons da lista de beacons por região na lista de beacons
      });
      log("Tamanho"+ _beacons.length.toString());
      if (_beacons.length == 5) {
        //Testa se o número de beacons encontrados é igual a 5
        // var resultado = controllerDistancia.mediaDistancia(_beacons);
        // var resultado  = controllerDistancia.movingAverage(_beacons);
        // if (_beacons[0].macAddress == caminho[atual].getMac() && !(caminho[atual].getVisited())) {
        //   flutterTts.speak(caminho[atual].getLocalizacao());
        //   flutterTts.speak(caminho[atual].getComandos());
        //   caminho[atual].setVisited();
        //   atual++;
        // }else if(_beacons[0].macAddress != caminho[atual].getMac){
        //   flutterTts.speak("Você errou o caminho. Por favor, retorne");
        // }
        var resultado = controllerDistancia.mediaDistancia(_beacons);
        log("Distancia com media: " + resultado.toString());
        _beacons.clear(); //Limpa a lista de beacons
        //  log("Distancia : "+_beacons[cont].accuracy.toString());
        //   cont++;
      }
    });
  }

  pausaScanBeacon() async {
    //Método para pausar o scan de beacons
    _resultadoScan?.pause(); //Pausa o stream
    if (_beacons.isNotEmpty) {
      //Testa se a lista de beacons não está vazia
      setState(() {
        //Atualiza o estado da tela
        _beacons.clear(); //Limpa a lista de beacons
      });
    }
  }

  @override
  void dispose() {
    //Método chamado quando o objeto é removido da árvore
    _resultadoScan?.cancel(); //Cancela a incrição e não recebe mais eventos
    super.dispose(); //Método quando o objeto não vai ser construído novamente
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _beacons.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: ListTile.divideTiles(
                context: context,
                tiles: _beacons.map(
                  (beacon) {
                    return ListTile(
                      title: Text(
                        'MAC: ${beacon.macAddress}',
                        style: TextStyle(fontSize: 15.0),
                      ),
                      subtitle: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              'Distancia: ${beacon.accuracy}m\nRSSI: ${beacon.rssi}',
                              style: TextStyle(fontSize: 13.0),
                            ),
                            flex: 2,
                            fit: FlexFit.tight,
                          ),
                          Flexible(
                            child: Text(
                              'TxPower: ${beacon.txPower}',
                              style: TextStyle(fontSize: 13.0),
                            ),
                            flex: 2,
                            fit: FlexFit.tight,
                          )
                        ],
                      ),
                    );
                  },
                ),
              ).toList(),
            ),
    );
  }
}

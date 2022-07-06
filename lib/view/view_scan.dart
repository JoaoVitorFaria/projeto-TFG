
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:beacon/controller/controller_bluetooth.dart';
import 'package:beacon/controller/controller_distancia.dart';
import 'package:beacon/controller/controller_nodes.dart';
import 'package:get/get.dart';
import 'dart:developer';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:directed_graph/directed_graph.dart';

class TabScanning extends StatefulWidget {
  const TabScanning({Key? key}) : super(key: key);
  @override 
  _TabScanningState createState() =>_TabScanningState(); 
}

class _TabScanningState extends State<TabScanning> {
  StreamSubscription<RangingResult>?_resultadoScan; // Stream para escanear beacons
  final _beaconPorRegiao = <Region,List<Beacon>>{}; //Variável do tipo Region em uma lista de objetos do tipo Beacon
  final _beacons = <Beacon>[]; //Lista de objetos Beacon
  final controller = Get.find<RequirementStateController>(); //Variável que contém a classe com os métodos de scanning do bluetooth
  final controllerDistancia = Get.find<RequirementDistance>(); // Variável que contém a classe com os métodos de distância
  final controllerNodes = Get.find<RequirementNode>(); // Variável que contém a classe com os métodos de nodes
  final FlutterTts flutterTts = FlutterTts(); 
 
  @override
  void initState() {
    // Chamada do método initState da classe pai
    super.initState(); 

    // Listener para o evento iniciaStream
    controller.iniciaStream.listen((flag) { 
      if (flag == true) {   
        iniciaScanBeacon(); // Inicia o Scan dos beacons
      }
    });
    // Listener para o evento pausaStream
    controller.pausaStream.listen((flag) { 
      if (flag == true) {
        pausaScanBeacon(); //Chama a função para pausar o scan do beacon
      }
    });
  }

  //Função assíncrona que inicia o scan do beacon
  iniciaScanBeacon() async {
    
    final FlutterTts flutterTts = FlutterTts(); 
    await flutterTts.setLanguage('pt-BR'); // Seta o idioma do texto
    await flutterTts.setSpeechRate(0.6); // Seta a velocidade do texto

    //Os nós que representam os beacons são instanciados aqui
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
        'nupXZG',
        'Você está na porta de entrada do IMC',
        "D7:05:E8:A5:81:6D",
        "Após passar pela porta, siga à esquerda. Há uma rampa, por favor, percorra-a");
    // Nó A
    no2.defineValores(
        'nu1T2P',
        "Você está na rampa de acesso ao segundo andar do IMC ",
        'E4:D9:1C:68:10:5E',
        "A parede à esquerda terminou pois você chegou na metade da rampa.Por favor, continue subindo a rampa para chegar ao seu destino");
    // Nó B
    no3.defineValores(
        'nu82HB', 
        "Você está no segundo andar do IMC", 
        "EA:99:49:8F:A4:B6",
        "Para chegar ao banheiro, siga à sua esquerda. Há um corredor, por favor, oriente-se pela parede à sua direita e percorra-o");
    // Nó C
    no4.defineValores(
        'nuK46o', 
        "Você está próximo a sala de t.i", 
        "F8:13:A7:AC:D2:17",
        "Voce está no corredor mais longo do IMC. Por favor, percorra-o orientando-se pela parede à sua direita");
    // Nó D
    no5.defineValores(
        'nuPWVm', 
        "Você está próximo ao laboratório de pesquisa", 
        "F6:66:FC:FD:B0:AE",
        "Em breve você encontrará duas esquinas. A Primeira é para a direita, a segunda para esquerda. Por favor, oriente-se pela parede à direita");
    // Nó E
    no6.defineValores(
        'nuTorE',
        "Você está no corredor de estudos, em frente aos laboratórios de pesquisa",
        'EF:29:E0:C0:C7:FB',
        "Continue percorrendo o corredor. Em breve haverá uma esquina, por favor, siga à direita");
    // Nó F
    no7.defineValores(
        'nuYbJJ', 
        "Você está em frente à sala...", 
        'F2:55:56:32:1E:59',
        "Em breve você encontrará duas esquinas. A Primeira é para a direita, a segunda para esquerda. Oriente-se pela parede à direita e percorra o corredor até o final. Por favor, ignore o corredor que está à sua direita");
    // Nó G
    no8.defineValores(
        'nuaScN', 
        "Você está próximo aos banheiros", 
        'F1:D4:36:55:33:C1',
        "Você encontrará duas esquinas. A primeira é para a esquerda e a segunda para a direita. Por favor, oriente-se pela parede à direita e percorra o corredor até o final");
    // Nó H
    no9.defineValores(
        'nuudyl', 
        "Você está no corredor da secretaria", 
        'DD:59:6C:57:E9:0E',
        "Vire a esquina à direita e siga em frente. Oriente-se pela parede a esquerda e ignore o primeiro corredor que encontrar. Ao encontrar uma porta, passe por ela e siga em frente");
    // Nó I
    no10.defineValores(
        'nuwU1M', 
        "Você está na secretaria", 
        'D2:9A:07:1A:74:43',
        "Parabéns, a secretaria é a primeira porta a sua direita.");
    // Para o teste do beacons referentes os nós 4, 9 e 10 serão reutilizados com as seguintes configurações
    // Equivalente ao Nó 8
    no11.defineValores(
        'nuaScN', 
        "Você está próximo ao LDC1 e LDC2", 
        "F1:D4:36:55:33:C1",
        "Em breve você chegará em uma esquina. Por favor, siga à direita");
    // Equivalente ao Nó 9
    no12.defineValores(
        'nuudyl', 
        "Você está próximo aos corredor dos banheiros", 
        "DD:59:6C:57:E9:0E",
        "Você está próximo aos banheiros. Siga em frente orientado-se pela parede à esquerda");
    // Equivalente ao Nó 10
    no13.defineValores(
        'nuwU1M', 
        "Você está em frente aos banheiros", 
        "D2:9A:07:1A:74:43",
        "Parabéns, os banheiros estão à sua direita");

    int sum(int left, int right) => left + right;

    
    var graph = WeightedDirectedGraph<RequirementNode, int>(
    {
      no1 : {no2 : 1},
      no2:  {no1: 1, no3: 1},
      no3 : {no2: 1, no4: 1, no11: 1}, // Bifurcação no topo da rampa
      no4 : {no3: 1, no5: 1},
      no5 : {no4: 1, no6: 1},
      no6 : {no5: 1, no7: 1},
      no7 : {no6: 1, no8: 1},
      no8 : {no7: 1, no9: 1},
      no9 : {no8: 1, no10: 1},
      no10 : {no9: 1}, // Chegou na secretaria
      // Estes nós fazem uso dos mesmo beacons utilizados vértices 8,9 e 10.
      no11: {no3: 1, no12: 1},
      no12: {no11: 1, no13: 1},
      no13: {no12: 1},
    },
    summation: sum,
    zero: 0,
  );

  final rotaSecretaria = graph.shortestPath(no1, no10);
  final rotaBanheiro = graph.shortestPath(no1, no13);

  log('Rota para a secretaria: ');
  for(int i = 0; i < rotaSecretaria.length; i++) {
    log(rotaSecretaria[i].id);
  }

  log('Rota para o banheiro: ');
  for(int i = 0; i < rotaBanheiro.length; i++) {
    log(rotaBanheiro[i].id);
  }
    // Informa o usuário sobre as opções de destino.
    flutterTts.speak("Seja bem Vindo ao App!");
    flutterTts.speak('Opções para navegação: OPÇÃO 1- Secretaria, 2- Banheiro. Informe a opção desejada, dizendo o comando opção e o número da opção desejada.');
    // A definição da variável destino deve ser feita através do input de voz
    var destino = ""; 
    destino = "opção 2";
  
    List caminho = []; 
    if (destino == "opção 1") {
      caminho = rotaSecretaria; 
    } else if (destino == "opção 2") {
      caminho = rotaBanheiro;
    }
    

    await flutterBeacon.initializeScanning; 
    if (!controller.bluetoothEnabled) {
      return;
    }
    final regions = <Region>[]; 
    regions.add(Region(identifier: 'com.beacon'));

    if (_resultadoScan != null) {
      if (_resultadoScan!.isPaused) {
        _resultadoScan?.resume(); 
        return;
      }
    }

  var atual = 0 ;
      
    _resultadoScan = flutterBeacon.ranging(regions).listen((RangingResult result) {
      _beaconPorRegiao[result.region] = result.beacons; 
      for (var list in _beaconPorRegiao.values) {
        _beacons.addAll(list);
      }
      // Verifica se foram feitas 20 leituras de sinais emitidos pelo beacon
      if (_beacons.length == 20) {
        // Aplica uma média móvel sobre as distâncas emitidas pelo beacon nas 20 leituras
        var distanciaBeacon  = controllerDistancia.movingAverage(_beacons);
        // As orientações só serão dadas caso o usuário esteja próximo ao beacon(2 metros).
        if(distanciaBeacon <= 2){
          // Caso o beacon próximo ao usuário seja o correto 
          if (_beacons[0].macAddress == caminho[atual].getMac()) {
            caminho[atual].getLocalizacao();
            caminho[atual].getComandos();
            caminho[atual].setVisited();
            atual++;
         }else {  // Caso o beacon próximo não seja o correto.
            var index =  caminho.firstWhere((i) => i.getMac() == _beacons[0].macAddress); 
            // Verifico se esse beacon próximo já foi visitado ou não
            if (index.getVisited()){
              // Caso ele esteja passando próximo ao beacon uma segunda vez 
              if(!(index.getMac() == caminho[atual-1].getMac())){ 
               index.getLocalizacao();
                index.getComandos();
              }else{ // Caso ele apenas receba o sinal por ter ficado parado
                // flutterTts.speak("Você já está na posição correta");
              }
            }else if(!index.getVisited()){ // Caso seja um beacon que ele não visitou e que não faz parte do caminho
              flutterTts.speak("Você errou o caminho.");
              index.getLocalizacao();
              flutterTts.speak("Por favor, retorne!");
            }
         }
        }else{ // Caso ele esteja recebendo sinal de um beacon mas ainda esteja a uma distancia maior que 2 metros
          // Poderia printar uma mensagem avisando que ele está próximo ao beacon.
          //var index =  caminho.firstWhere((i) => i.getMac() == _beacons[0].macAddress); 
          // flutterTts.speak("Você está próximo ao beacon." + index.getLocalizacao());
        }
        // Limpo a lista de leitura de beacons para não atrapalhar medições seguintes.
        _beacons.clear(); 
      }
    });
  }

  pausaScanBeacon() async {
    _resultadoScan?.pause(); 
    if (_beacons.isNotEmpty) {
      setState(() {
        _beacons.clear(); 
      });
    }
  }

  @override
  void dispose() {
    _resultadoScan?.cancel(); 
    super.dispose(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _beacons.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: ListTile.divideTiles(
                context: context,
                tiles: _beacons.map(
                  (beacon) {
                    return ListTile(
                      title: Text(
                        'MAC: ${beacon.macAddress}',
                        style: const TextStyle(fontSize: 15.0),
                      ),
                      subtitle:  Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              'Distancia: ${beacon.accuracy}m\nRSSI: ${beacon.rssi}',
                              style: const TextStyle(fontSize: 13.0),
                            ),
                            flex: 2,
                            fit: FlexFit.tight,
                          ),
                          Flexible(
                            child: Text(
                              'TxPower: ${beacon.txPower}',
                              style: const TextStyle(fontSize: 13.0),
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

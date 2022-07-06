
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:flutter_tts/flutter_tts.dart';

// Esta classe implementa os métodos relacionados a manipulação dos vértices da solução
class RequirementNode extends GetxController {
  final FlutterTts flutterTts = FlutterTts(); 
  bool visited = false;
  var id = ''; // Identificador estampada do Beacon
  var descricao = '';   // Descrição da localização do vértice
  var mac = ''; // MAC do beacon
  var comandos = ''; // Falas de orientação para o usuário
 

  // Inicializa o objeto com os valores passados
  defineValores(String id, String descricao, String mac, String comandos) {
    this.id = id;
    this.descricao = descricao;
    this.mac = mac;
    this.comandos = comandos;
  }

  // Retorna o identificador único do Beacon
  getMac() {
    return mac;
  }

  // Retorna se o nó já foi visitado 
  getVisited() {
    return visited;
  }

  // Define um nó como visitado
  setVisited() {
    visited = true;
  }

  // Retorna a localização do Nó
  getLocalizacao() {
    flutterTts.speak(descricao);
  }

  // Retorna as orientações até o próximo Nó
  getComandos() {
    flutterTts.speak(comandos);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';

import 'dart:developer' as dev;

import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class RequirementNode extends GetxController {
  bool visited = false;
  var id = 0;
  var descricao = '';
  var mac = '';
  var comandos = '';

  // Inicializa o objeto com os valores passados
  defineValores(int id, String descricao, String mac, String comandos) {
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
    return descricao;
  }

  // Retorna as orientações até o próximo Nó
  getComandos() {
    return comandos;
  }
}

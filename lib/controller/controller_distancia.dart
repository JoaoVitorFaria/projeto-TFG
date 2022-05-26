import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moving_average/moving_average.dart';
import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'dart:math';

class RequirementDistance extends GetxController{

  // Referencia: https://www.flybuy.com/2018-11-19-fundamentals-of-beacon-ranging#:~:text=Mobile%20devices%20can%20estimate%20the,beacon's%20signal%20level%20as%20RSSI.
  // Retorna a distancia em metros com uso do RSSI e txPower
  double calculaDistancia(double rssi, int txPower){
    if (rssi == 0){
      // Retorna -1 caso a distancia nao possa ser calculada
      return -1.0; 
    }
    double ratio = rssi*1.0/txPower;
    if(ratio < 1.0){
      double distancia = (1.00)* pow(ratio,10.00);
      return distancia;
    }else{
      double distancia = (0.89976)* pow(ratio,7.7095) + 0.111;
      return distancia;
    }
  }

  // Retorna um valor de RSSI apos aplicar o filtro moving average
  // https://pub.dev/packages/moving_average
  List movingAverage(List vetorRssi){
    // Essa parte comentada vai permitir aplicar o filtro Moving Average do projeto semestral
    final simpleMovingAverage = MovingAverage<num>(
        averageType: AverageType.simple,
        windowSize: 4,
        partialStart: true,
        getValue: (num n) => n,
        add: (List<num> data, num value) => value,

    );
    // List resultado = simpleMovingAverage(vetorRssi);
    var resultado =[10,20];
    return resultado;
  }

  // Retorna a media dos valores RSSI salvos na Lista
  double mediaRssi(List vetorRssi){
    double mediaRssi = vetorRssi.fold(0, (mediaRssi, element) => mediaRssi + element / vetorRssi.length);
    return mediaRssi;
  }

}



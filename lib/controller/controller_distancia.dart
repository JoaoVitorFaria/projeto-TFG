

import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'dart:developer' as dev;

// Esta classe define métodos relacionados à distância entre o dispositivo do usuário e o Beacon
class RequirementDistance extends GetxController {

  // Referencia: https://www.flybuy.com/2018-11-19-fundamentals-of-beacon-ranging#:~:text=Mobile%20devices%20can%20estimate%20the,beacon's%20signal%20level%20as%20RSSI.
  // Retorna a distancia em metros com uso do RSSI e txPower
  double calculaDistancia(int rssi, int? txPower) {
    if (rssi == 0) {
      // Retorna -1 caso a distancia nao possa ser calculada
      return -1.0;
    }
    double ratio = rssi * 1.0 / txPower!;
    if (ratio < 1.0) {
      double distancia = (1.00) * pow(ratio, 10.00);
      return distancia;
    } else {
      double distancia = (0.89976) * pow(ratio, 7.7095) + 0.111;
      return distancia;
    }
  }

  // Retorna um valor após aplicar uma média móvel sobre um conjunto de 20 valores de accuracy
  double movingAverage(List<Beacon> distancia) {
    List resultado = [];
    double temp = 0;
    for (var i = 0; i < 17; i = i + 4) {
      temp += distancia[i].accuracy;
      temp += distancia[i + 1].accuracy;
      temp += distancia[i + 2].accuracy;
      temp += distancia[i + 3].accuracy;
      temp = temp / 4;
      resultado.add(temp);
      temp = 0;
    }
    double soma = 0;
    for (var i = 0; i < 5; i++) {
      soma += resultado[i];
    }
    return soma / 5;
  }

  // Retorna a media dos valores de accuracy lidos
  double mediaDistancia(List<Beacon> listaBeacons) {
    double media = 0;
    for (var i = 0; i < listaBeacons.length; i++) {
      media = media + listaBeacons[i].accuracy;
      dev.log("Valor sendo somado: " + listaBeacons[i].accuracy.toString());
    }
    media = media / listaBeacons.length;
    return media;
  }
}

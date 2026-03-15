import 'dart:convert';
import 'package:don_nut/src/models/user.dart';
import 'package:don_nut/src/utils/global.dart';
import 'package:http/http.dart' as http;
import 'package:don_nut/src/models/order_original.dart';

class OrderOriginalService {
  Future<List<OrderOriginal>> getOrders(url) async {
    final response = await http.get(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    List<OrderOriginal> orders = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      for (var i in jsonData["data"]) {
        orders.add(OrderOriginal(
          i['idPedido'],
          i['estado'],
          i['fechaRegistro'],
          User(i['cliente']['idUsuario'], i['cliente']['nombre'],
              i['cliente']['primerApellido'], '', '', '', '', '', ''),
        ));
      }
      return orders;
    } else {
      throw Exception('Error en la conexión');
    }
  }
  Future<List<OrderOriginal>> getHistory(url) async {
    final response = await http.get(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    List<OrderOriginal> orders = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      for (var i in jsonData["data"]) {
        orders.add(OrderOriginal(
          i['idPedido'],
          i['estado'],
          i['fechaRegistro'],
          User( 0, '',
              '', '', '', '', '', '', ''),
        ));
      }
      return orders;
    } else {
      throw Exception('Error en la conexión');
    }
  }
}

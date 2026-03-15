import 'dart:convert';
import 'package:don_nut/src/models/order.dart';
import 'package:don_nut/src/utils/global.dart';
import 'package:http/http.dart' as http;
import 'package:don_nut/src/models/producto.dart';

class ProductService {
  Future<List<Producto>> getProducts(url) async {
    final response = await http.get(Uri.parse(url));
    List<Producto> products = [];
    if (response.statusCode == 202) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      for (var i in jsonData["data"]) {
        products.add(Producto(
            i['idProducto'],
            i['nombre'],
            i['tipo'],
            i['imgBanner'],
            i['imgProducto'],
            i['descripcion'],
            i['fechaRegistro'],
            i['precio'],
            i['estado']));
      }
      return products;
    } else {
      throw Exception('Error en la conexión');
    }
  }

  Future<List<Order>?> getOrder(url) async {
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    List<Order> orders = [];

    if (response.statusCode == 202) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      if (jsonData['data'].length == 0) {
        return null;
      }

      for (var i in jsonData["data"]) {
        orders.add(Order(
            i['idProductoCarrito'],
            i['cantidad'],
            Producto(
                i['producto']['idProducto'],
                i['producto']['nombre'],
                i['producto']['tipo'],
                '', //imgBanner
                i['producto']['imgProducto'],
                i['producto']['descripcion'],
                '', //fechaRegistro
                i['producto']['precio'],
                '' //estado
                )));
      }
      return orders;
    } else if (response.statusCode == 401) {
      //No autorizado para ver el carrito

      return null;
    } else {
      throw Exception('Error en la conexión');
    }
  }
}

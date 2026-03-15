import 'dart:convert';

import 'package:don_nut/src/screens/product_info.dart';
import 'package:don_nut/src/utils/global.dart';
import 'package:http/http.dart' as http;

class OrderService {
  //Verifica si el producto ya se encuentra en el carrito del cliente
  Future<http.Response> getProduct(ProductPageArguments arguments) async {
    return await http.get(
        Uri.parse(url +
            'productoscarritos/producto/' +
            arguments.idProducto.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
  }

  //Actualiza la propiedad cantidad de un producto determinado, en el carrito del cliente
  Future<http.Response> updateProductoCarrito(
      idProductoCarrito, cantidad) async {
    return await http.put(
        Uri.parse(url + 'productoscarritos/' + idProductoCarrito.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, String>{"cantidad": cantidad.toString()}));
  }

  //Inserta un nuevo producto en el carrito del cliente
  Future<http.Response> insertProductoCarrito(
      ProductPageArguments arguments, cont) async {
    return await http.post(Uri.parse(url + 'productoscarritos'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, int>{
          "cantidad": cont,
          "fk_idProducto": arguments.idProducto
        }));
  }

  //Elimina un producto del carrito
  Future<http.Response> deleteProductoCarrito(idProductoCarrito) async {
    return await http.delete(
        Uri.parse(url + 'productoscarritos/' + idProductoCarrito.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
  }
}

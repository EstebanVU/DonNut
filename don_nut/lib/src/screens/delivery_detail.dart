import 'dart:convert';

import 'package:don_nut/src/models/order.dart';
import 'package:don_nut/src/models/producto.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../utils/global.dart';
import 'package:don_nut/src/utils/global.dart' as globals;

class DeliveryDetail extends StatefulWidget {
  const DeliveryDetail({Key? key}) : super(key: key);
 
  @override
  State<DeliveryDetail> createState() => DeliveryDetailState();
}

int subtotal = 0;

class DeliveryDetailState extends State<DeliveryDetail> {
  late Future<List<Order>> _listOrder; //Lista del carrito

  Future<List<Order>> _getOrder(url) async {
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    List<Order> orders = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      for (var i in jsonData["data"]['productos']) {
        orders.add(Order(
            0,
            i['cantidad'],
            Producto(
                i['producto']['idProducto'],
                i['producto']['nombre'],
                '',
                '', //imgBanner
                i['producto']['imgProducto'],
                '',
                '', //fechaRegistro
                '',
                '' //estado
                )));
      }
      return orders;
    } else if (response.statusCode == 401) {
      //No autorizado para ver el carrito
      return orders;
    } else {
      throw Exception('Error en la conexión');
    }
  }

  //Lo primero que se ejecuta al abrir la pantalla
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final arguments =
    ModalRoute.of(context)!.settings.arguments as DeliveryDetailArguments;
    _listOrder = _getOrder(globals.url + "pedidos/"+arguments.idPedido.toString());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        //Barra superior de la pantalla
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
              child: SizedBox(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    const SizedBox(height: 20),
                    Text("Pedido #"+arguments.idPedido.toString(),style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w400, fontSize: 22),),
                    const SizedBox(height: 10),
                    Text(arguments.nombre,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w400, fontSize: 22),),
                    const SizedBox(height: 20),
                    orderItem(_listOrder),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(
                  right: 30, left: 30, top: 20, bottom: 20),
              width: 400,
              child: ElevatedButton(
                child: const Text("Ver Ubicación"),
                onPressed: () {
                   
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xffAD53AE),
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  textStyle: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
Widget orderItem(_orders) {
  return FutureBuilder(
    future: _orders,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Container(
          margin: const EdgeInsets.only(bottom: 22, top: 22),
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            primary: false,
            physics: const NeverScrollableScrollPhysics(),
            children: _getProductsOrder(snapshot.data, context),
          ),
              
        );
      } else if (snapshot.hasError) {
        return const Text("Error al extraer la información");
      }

      return const Center(
          child: Padding(
              padding: EdgeInsets.only(top: 5),
              child: CircularProgressIndicator()));
    },
  );
  }

List<Widget> _getProductsOrder(data, context) {
  List<Widget> products = [];
  for (var item in data) {
    products.add(Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            item.cantidad .toString() + 'x ' + item.producto.nombre,
            maxLines: 2,
            textAlign: TextAlign.start,
            style: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 10),
          AutoSizeText(
            item.producto.descripcion,
            maxLines: 2,
            textAlign: TextAlign.start,
            style: const TextStyle(color: Color(0xff707070), fontSize: 14),
          ),
        ],
      ),
    ));

    products.add(
      const Divider(
        height: 5,
        thickness: 0.6,
        color: Color(0xff707070),
      ),
    );
    
  }
  return products;
}
class DeliveryDetailArguments {
  int idPedido;
  String nombre;
  DeliveryDetailArguments(
      {required this.idPedido,
      required this.nombre,
     });
}

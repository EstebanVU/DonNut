import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:don_nut/src/services/order_service.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ProductInfoPage extends StatefulWidget {
  const ProductInfoPage({Key? key}) : super(key: key);

  @override
  State<ProductInfoPage> createState() => _ProductInfoPageState();
}

class _ProductInfoPageState extends State<ProductInfoPage> {
  OrderService orderServices = OrderService();
  int cont = 1;

  void contadorMas() {
    if (cont > -1 && cont < 99) {
      setState(() {
        cont++;
      });
    }
  }

  void contadorMenos() {
    if (cont > 1) {
      setState(() {
        cont--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as ProductPageArguments;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        //Barra superior de la pantalla
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
          title: Image.network(
              'https://media.discordapp.net/attachments/775922349362642955/906604815361134592/logo.png?width=998&height=676',
              height: 70,
              width: 70),
          elevation: 0,
        ),
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 240,
                child: Column(
                  children: [
                    SizedBox(
                      width: 200,
                      child: AutoSizeText(
                        arguments.nombre,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            color: Color(0xff707070),
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 200,
                      child: AutoSizeText(
                        arguments.descripcion,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            color: Color(0xff707070), fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 200,
                      child: Text.rich(TextSpan(
                          text: "₡" + arguments.costo,
                          style: const TextStyle(
                              color: Color(0xffAD53AE),
                              fontWeight: FontWeight.w600),
                          children: const <TextSpan>[
                            TextSpan(
                              text: ' c/u',
                              style: TextStyle(
                                  color: Color(0xff707070),
                                  fontWeight: FontWeight.w600),
                            )
                          ])),
                    )
                  ],
                ),
              ),
              Image.network(arguments.imagen, height: 150, width: 150),
            ],
          ),
          const SizedBox(height: 90),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  "Unidades",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 150,
                height: 40,
                margin: const EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ElevatedButton(
                      child: const Text("-"),
                      onPressed: () {
                        contadorMenos();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        primary: Colors.white,
                        onPrimary: const Color(0xffAD53AE),
                        padding: EdgeInsets.zero,
                        elevation: 0.0,
                        shadowColor: Colors.transparent,
                        textStyle: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(
                      width: 22,
                      child: Text('$cont',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 18)),
                    ),
                    ElevatedButton(
                      child: const Text("+"),
                      onPressed: () {
                        contadorMas();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: const Color(0xffAD53AE),
                        padding: EdgeInsets.zero,
                        shape: const CircleBorder(),
                        elevation: 0.0,
                        shadowColor: Colors.transparent,
                        textStyle: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 90),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  "Observaciones",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: TextFormField(
                  scrollPadding: const EdgeInsets.only(bottom: 200),
                  minLines: 2,
                  maxLength: 200,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Escribe algo...',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff707070),
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffAD53AE),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    right: 40, left: 40, top: 20, bottom: 20),
                width: 400,
                child: ElevatedButton(
                  child: Text("Agregar al pedido ₡" +
                      (int.parse(arguments.costo) * cont).toString()),
                  onPressed: () {
                    if (GetStorage().read('email') != null ||
                        GetStorage().read('password') != null) {
                      addProduct(arguments);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xffAD53AE),
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  addProduct(ProductPageArguments arguments) async {
    final responseProduct = await orderServices.getProduct(arguments);

    if (responseProduct.statusCode == 200) {
      String body = utf8.decode(responseProduct.bodyBytes);
      final jsonData = jsonDecode(body);

      final idProductoCarrito = jsonData["data"]['idProductoCarrito'];
      final cantidad = jsonData["data"]['cantidad'] + cont;

      final responseUpdate = await orderServices.updateProductoCarrito(
          idProductoCarrito, cantidad);

      if (responseUpdate.statusCode == 202) {
        Navigator.pop(context);
      }
    } else if (responseProduct.statusCode == 400) {
      final responseInsert =
          await orderServices.insertProductoCarrito(arguments, cont);

      if (responseInsert.statusCode == 202) {
        Navigator.pop(context);
      }
    }
  }
}

class ProductPageArguments {
  int idProducto;
  String nombre;
  String descripcion;
  String costo;
  String imagen;
  ProductPageArguments(
      {required this.idProducto,
      required this.nombre,
      required this.descripcion,
      required this.costo,
      required this.imagen});
}

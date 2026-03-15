import 'package:don_nut/src/models/order.dart';
import 'package:don_nut/src/models/order_original.dart';
import 'package:don_nut/src/services/order_original_service.dart';
import 'package:don_nut/src/services/order_service.dart';
import 'package:don_nut/src/services/product_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:async';
import 'package:don_nut/src/utils/global.dart' as globals;
import 'history_detail.dart';
import 'location.dart';

final observacionPedidoTextController = TextEditingController();

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => OrderPageState();
}

int subtotal = 0;
bool _isVisible = false;
bool _isOpaque = false;

OrderService orderServices = OrderService();

class OrderPageState extends State<OrderPage> {
  ProductService productServices = ProductService();
  OrderService orderServices = OrderService();
  OrderOriginalService orderOriginalService = OrderOriginalService();
 
  late Future<List<Order>?> _listOrder; //Lista del carrito
  late Future<List<OrderOriginal>?> _historyOrders;// Historial de pedidos 
  int cont = 1;
  //Lo primero que se ejecuta al abrir la pantalla
  @override
  void initState() {
    super.initState();
    _listOrder = productServices.getOrder(globals.url + "productoscarritos");
    _historyOrders= orderOriginalService.getHistory(globals.url+ "pedidos/lista/historial");
  }
 
  @override
  Widget build(BuildContext context) {
    subtotal = 0;
    return DefaultTabController (
      length: 2,
      child: Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        //Barra superior de la pantalla
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Image.network(
                'https://media.discordapp.net/attachments/775922349362642955/906604815361134592/logo.png?width=998&height=676',
                height: 70,
                width: 70),
            
          ]),
          elevation: 0,
          bottom: const TabBar(
            indicatorColor: Color(0xffAD53AE),
            unselectedLabelColor: Color(0xff707070),
            labelColor: Color(0xffAD53AE),
            tabs: [
              Tab(
                child: Text(
                  'Carrito',
                ),
              ),
              Tab(
                child: Text(
                  'Historial Pedidos',
                ),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
          children: [
            SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
              child: Column(
                children: [
                  const SizedBox(height: 20,),
                  SizedBox(
                    width: 500,
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text("Mi pedido",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500)),
                        ),
                              IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  if (!_isVisible) {
                    _isVisible = true;
                    _isOpaque = true;
                  } else {
                    _isOpaque = false;
                  }
                });
              },
            ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ReRunnableFutureBuilder(_listOrder,
                      getProductsOrder: getProductsOrder) //Los productos
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(left: 30, right: 30),
              child: Text.rich(
                TextSpan(
                  text: "¿Desea aclararnos algo?  ",
                  style: const TextStyle(color: Color(0xff707070)),
                  children: [
                    TextSpan(
                      text: "Añadir observación",
                      style: const TextStyle(
                          color: Color(0xffad53ae),
                          fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          showObservationPage();
                        },
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  right: 30, left: 30, top: 20, bottom: 20),
              width: 400,
              child: ElevatedButton(
                child: const Text("Procesar pedido",style:TextStyle(fontWeight: FontWeight.w500),),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed("/location",
                          arguments: LocationDetailArguments(
                            observacionPedido:
                                observacionPedidoTextController.text,
                          ))
                      .then((value) => setState(() {
                            _listOrder = productServices
                                .getOrder(globals.url + "productoscarritos");
                          }));
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
      ),

     SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 10,),
            ReRunnableHistoryFutureBuilder(_historyOrders,
                      getHistory: getHistoryOrders,) 
           
          ],
        ),
      ),
    ),
           
            
            
          ],
      
    ),
      ),
    );
  }
  void showObservationPage() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: TextField(
                      controller: observacionPedidoTextController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Observación del pedido",
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
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop('Aceptar');
                          },
                          child: const Text("Aceptar"),
                          style: TextButton.styleFrom(
                              primary: const Color(0xffAD53AE))),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ));
  }

  List<Widget> getProductsOrder(data, context) {
    List<Widget> products = [];
    int _subtotal = 0;
    for (var item in data) {
      _subtotal = (_subtotal +
          (int.parse(item.producto.precio) * item.cantidad)) as int;
      products.add(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 284,
            child: TextButton(
              style: TextButton.styleFrom(
                splashFactory: NoSplash.splashFactory,
              ),
              onPressed: () {
                if (_isOpaque == true) {
                  setState(() {
                    cont = item.cantidad;
                  });
                  showEditPage(item.producto.nombre, item.producto.precio,
                      item.idProductoCarrito);
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    width: 274,
                    child: AutoSizeText(
                      item.cantidad.toString() + 'x ' + item.producto.nombre,
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    width: 274,
                    child: AutoSizeText(
                      item.producto.descripcion,
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          color: Color(0xff707070), fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      text: "Total ",
                      style: const TextStyle(color: Color(0xff707070)),
                      children: [
                        TextSpan(
                          text: "₡" +
                              (int.parse(item.producto.precio) * item.cantidad)
                                  .toString(),
                          style: const TextStyle(
                              color: Color(0xffad53ae),
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            opacity: _isOpaque ? 1 : 0,
            onEnd: () {
              if (!_isOpaque) {
                setState(() {
                  _isVisible = false;
                });
              }
            },
            child: Visibility(
              visible: _isVisible,
              child: IconButton(
                onPressed: () {
                  orderServices
                      .deleteProductoCarrito(item.idProductoCarrito)
                      .whenComplete(() {
                    setState(() {
                      _listOrder = productServices
                          .getOrder(globals.url + "productoscarritos");
                    });
                  });
                },
                splashRadius: 20,
                icon: const Icon(Icons.delete, size: 25),
              ),
            ),
          ),
        ],
      ));

      products.add(
        const Divider(
          height: 40,
          thickness: 0.6,
          color: Colors.black,
        ),
      );
      subtotal = _subtotal;
    }

    return products;
  }
  List<Widget> getHistoryOrders(data, context) {
    List<Widget> orders = [];
  for (var item in data) {
   
      orders.add(
        
            TextButton(onPressed: () {
              Navigator.of(context).pushNamed("/history_detail",
                arguments: HistoryDetailArguments(
                    idPedido: item.idOrden,
                    estado:item.estado,
                    fechaRegistro: item.fechaRegistro
                    ));
            }, child: Column(
              children: [
                const SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30,right: 30),
                      child: Text("Pedido #"+item.idOrden.toString(),style: const TextStyle(color: Color(0xff707070),fontWeight: FontWeight.w600, fontSize: 16),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30,right: 30),
                      child: Text(item.estado,style: const TextStyle(color: Color(0xff707070),fontWeight: FontWeight.w400, fontSize: 16)),
                    ),
                  ],
                ),
                const Divider(
                indent: 20,
                endIndent: 20,
                thickness: 0.3,
                color: Colors.black,
              ),
               Padding(
                 padding: const EdgeInsets.only(right: 20),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.end,
                   children: [
                     
                     Text(item.fechaRegistro,style: const TextStyle(color: Color(0xff707070),fontWeight: FontWeight.w400, fontSize: 12,)),
                   ],
                 ),
               ),
              
              ],
            ),style: TextButton.styleFrom(primary: const Color(0xffAD53AE))),
      );
    }
    
    return orders;
  }

  void showEditPage(nombre, precio, idProductoCarrito) {
    showModalBottomSheet(
        enableDrag: false,
        context: context,
        builder: (context) {
          return Container(
            color: const Color(0xFF737373),
            height: 280,
            child: Container(
                margin: const EdgeInsets.only(right: 20, left: 20),
                child: buildBottomNavigationMenu(
                    nombre, precio, idProductoCarrito, context),
                decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)))),
          );
        });
  }

  StatefulBuilder buildBottomNavigationMenu(
      nombre, precio, idProductoCarrito, BuildContext context) {
    return StatefulBuilder(
      builder: (context, _setState) => Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20, left: 15, right: 15),
            child: AutoSizeText(nombre,
                maxLines: 2,
                textAlign: TextAlign.start,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 30, left: 25, right: 25),
            child: Row(
              children: [
                const Text('Unidades:',
                    style: TextStyle(
                        color: Color(0xff707070),
                        fontSize: 16,
                        fontWeight: FontWeight.w500)),
                itemCounter(_setState)
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 30, left: 25, right: 25),
            child: Row(
              children: [
                Text.rich(
                  TextSpan(
                    text: "Total:  ",
                    style: const TextStyle(
                        color: Color(0xff707070),
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    children: [
                      TextSpan(
                        text: "₡" + (int.parse(precio) * cont).toString(),
                        style: const TextStyle(
                            color: Color(0xffad53ae),
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin:
                const EdgeInsets.only(right: 30, left: 30, top: 30, bottom: 20),
            width: 400,
            child: ElevatedButton(
              child: const Text("Guardar"),
              onPressed: () {
                orderServices
                    .updateProductoCarrito(idProductoCarrito, cont)
                    .whenComplete(() {
                  setState(() {
                    _listOrder = productServices
                        .getOrder(globals.url + "productoscarritos");
                  });
                });
                Navigator.pop(context);
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
          )
        ],
      ),
    );
  }

  Container itemCounter(setState) {
    return Container(
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
              offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          ElevatedButton(
            child: const Text("-"),
            onPressed: () {
              if (cont > 1) {
                setState(() {
                  cont--;
                });
              }
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              primary: Colors.white,
              onPrimary: const Color(0xffAD53AE),
              padding: EdgeInsets.zero,
              elevation: 0.0,
              shadowColor: Colors.transparent,
              textStyle:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(
            width: 22,
            child: Text('$cont',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black, fontSize: 18)),
          ),
          ElevatedButton(
            child: const Text("+"),
            onPressed: () {
              if (cont > -1 && cont < 99) {
                setState(() {
                  cont++;
                });
              }
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              onPrimary: const Color(0xffAD53AE),
              padding: EdgeInsets.zero,
              shape: const CircleBorder(),
              elevation: 0.0,
              shadowColor: Colors.transparent,
              textStyle:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class ReRunnableFutureBuilder extends StatelessWidget {
  final Future<List<Order>?> _future;
  final Function getProductsOrder;

  const ReRunnableFutureBuilder(this._future,
      {Key? key, required this.getProductsOrder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
                child: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: CircularProgressIndicator()));
          }
          if (snapshot.hasError) {
            return const Text("Error al extraer la información");
          }

          if (!snapshot.hasData) {
            return const Text("Aún no se encuentran productos en el carrito");
          } else {
            return Column(
              children: [
                ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    children: getProductsOrder(snapshot.data, context)),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  alignment: Alignment.centerLeft,
                  child: Text.rich(
                    TextSpan(
                      text: "Subtotal: ",
                      style: const TextStyle(color: Color(0xff707070)),
                      children: [
                        TextSpan(
                          text: "₡" + subtotal.toString(),
                          style: const TextStyle(
                              color: Color(0xffad53ae),
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        });
  }
}

class ReRunnableHistoryFutureBuilder extends StatelessWidget {
  final Future<List<OrderOriginal>?> _future;
  final Function getHistory;

  const ReRunnableHistoryFutureBuilder(this._future,
      {Key? key, required this.getHistory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
                child: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: CircularProgressIndicator()));
          }
          if (snapshot.hasError) {
            return const Text("Error al extraer la información");
          }

          if (!snapshot.hasData) {
            return const Text("Aún no se encuentran pedidos");
          } else {
            return Column(
              children: [
                ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    children: getHistory(snapshot.data, context)),
              ],
            );
          }
        });
  }
}

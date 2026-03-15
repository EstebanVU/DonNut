import 'package:don_nut/src/models/order_original.dart';
import 'package:flutter/material.dart';

import 'delivery_detail.dart';

class DeliveryPage extends StatefulWidget {
  const DeliveryPage({Key? key,required this.listOrders}) : super(key: key);
  final Future<List<OrderOriginal>>? listOrders;

  @override
  State<DeliveryPage> createState() => _DeliveryPage();
}

class _DeliveryPage extends State<DeliveryPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 10,),
            const Text("Entregas",style: TextStyle(color: Color(0xffAD53AE),fontWeight: FontWeight.w700, fontSize: 20),),
            orderItem(widget.listOrders, "entrega"),
          ],
        ),
      ),
    );
  }
  Widget orderItem(_orders,tipo) {
  return FutureBuilder(
    future: _orders,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Container(
          margin: const EdgeInsets.only(bottom: 22, top: 22),
          child: ListView(
            shrinkWrap: true,
            children: _listOrders(snapshot.data, context,tipo),
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
  List<Widget> _listOrders(data, context, tipo) {
  List<Widget> orders = [];
  for (var item in data) {
    if(item.estado==tipo){
      orders.add(
            TextButton(onPressed: () {
              Navigator.of(context).pushNamed("/delivery_detail",
                arguments: DeliveryDetailArguments(
                    idPedido: item.idOrden,
                    nombre:item.user.nombre
                    ));
            }, child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Pedido #"+item.idOrden.toString(),style: const TextStyle(color: Color(0xff707070),fontWeight: FontWeight.w600, fontSize: 16),),
                    const SizedBox(width: 120,),
                    Text(item.user.nombre+" "+item.user.pApellido,style: const TextStyle(color: Color(0xff707070),fontWeight: FontWeight.w400, fontSize: 16)),
                  ],
                ),
                const Divider(
                indent: 20,
                endIndent: 20,
                thickness: 0.3,
                color: Colors.black,
              ),
              ],
            ),style: TextButton.styleFrom(primary: const Color(0xffAD53AE))),
      );
    }}
    
    return orders;
  }

}
import 'package:don_nut/src/models/order_original.dart';
import 'package:don_nut/src/screens/preparation_detail.dart';
import 'package:flutter/material.dart';

class PreparationPage extends StatefulWidget {
  const PreparationPage({Key? key,required this.listOrders}) : super(key: key);
  final Future<List<OrderOriginal>>? listOrders;

  @override
  State<PreparationPage> createState() => _PreparationPage();
}

class _PreparationPage extends State<PreparationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: Colors.white,
          bottom: const TabBar(
            indicatorColor: Color(0xffAD53AE),
            unselectedLabelColor: Color(0xff707070),
            labelColor: Color(0xffAD53AE),
            tabs: [
              Tab(
                child: Text(
                  'Pendientes',
                ),
              ),
              Tab(
                child: Text(
                  'En Proceso',
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            
            orderItem(widget.listOrders, "pendiente"),
           
            orderItem(widget.listOrders, "preparación"),
            
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
              Navigator.of(context).pushNamed("/preparation_detail",
                arguments: PreparationDetailArguments(
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
                    Text(item.user.nombre+" "+item.user.primerApellido,style: const TextStyle(color: Color(0xff707070),fontWeight: FontWeight.w400, fontSize: 16)),
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


import 'package:don_nut/src/models/order_original.dart';
import 'package:don_nut/src/models/producto.dart';
import 'package:don_nut/src/screens/preparation_page.dart';
import 'package:don_nut/src/screens/search.dart';
import 'package:don_nut/src/screens/user_profile.dart';
import 'package:don_nut/src/services/auth_service.dart';
import 'package:don_nut/src/services/order_original_service.dart';
import 'package:don_nut/src/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:don_nut/src/utils/global.dart' as globals;
import 'delivery_page.dart';
import 'home_page.dart';
import 'login.dart';
import 'order_page.dart';

late Future<List<Producto>> _listTopProducts;
late Future<List<Producto>> _listBanners;
late Future<List<Producto>> _listProducts;
//
Future<List<OrderOriginal>>? _listOrders;
Future<List<OrderOriginal>>? _listOrdersDelivery;

class LoadingPage extends StatefulWidget {
  const LoadingPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  late MyHomePage homePage;
  late LoginPage loginPage;
  late SearchPage searchPage;
  late OrderPage orderPage;
  late UserProfile userProfilePage;
  //
  late PreparationPage preparationPage;
  late DeliveryPage deliveryPage;

  ProductService productServices = ProductService();
  AuthService authServices = AuthService();
  OrderOriginalService orderServices = OrderOriginalService();

  @override
  void initState() {
    super.initState();

    _listTopProducts = productServices.getProducts(
        globals.url + "productos/tipo/Saladas"); //Se carga el top ventas
    _listProducts = productServices.getProducts(globals.url + "productos");
    _listBanners = productServices.getProducts(
        globals.url + "productos/tipo/Banners"); //Se cargan los banners

    if (GetStorage().read('email') != null ||
        GetStorage().read('password') != null) {
      authServices.automaticLogin().whenComplete(() {
        authServices.getUserInformation().whenComplete(() {
          setRolPages();
          Navigator.of(context).pushReplacementNamed('/main');
        });
      });
    } else {
      setDefaultPages();
      waitSplash();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SizedBox(
        height: 180,
        width: 180,
        child: Image.asset("assets/logo_donut.png"),
      )),
    );
  }

  void setDefaultPages() {
    homePage = MyHomePage(
        listTopProducts: _listTopProducts,
        listBanners: _listBanners,
        listProducts: _listProducts);
    globals.pages[0] = homePage;

    searchPage = SearchPage(listTopProducts: _listProducts);
    globals.pages[1] = searchPage;

    orderPage = const OrderPage();
    globals.pages[2] = orderPage;

    globals.currentPage = globals.pages[0];
  }

  void setRolPages() {
    if (globals.user.rol == 'USUARIO' || globals.user.rol == 'SUPERADMIN') {
      setDefaultPages();
    } else if (globals.user.rol == 'REPARTIDOR') {
      //Setear las paginas segun el rol
      _listOrdersDelivery = orderServices
          .getOrders(globals.url + "pedidos/lista/entrega")
          .whenComplete(() {
        deliveryPage = DeliveryPage(
          listOrders: _listOrdersDelivery,
        );
        globals.pages[1] = deliveryPage;
      });
      globals.currentPage = globals.pages[0];
    } else if (globals.user.rol == 'PREPARADOR') {
      //Setear las paginas segun el rol
      _listOrders = orderServices
          .getOrders(globals.url + "pedidos/lista/preparacion")
          .whenComplete(() {
        preparationPage = PreparationPage(
          listOrders: _listOrders,
        );
        globals.pages[1] = preparationPage;
      });
      globals.currentPage = globals.pages[0];
    }
  }

  waitSplash() async {
    await Future.delayed(const Duration(milliseconds: 1500), () {});
    Navigator.of(context).pushReplacementNamed('/main');
  }
}

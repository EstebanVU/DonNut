import 'package:don_nut/src/screens/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:don_nut/src/utils/global.dart' as globals;
import 'package:get_storage/get_storage.dart';
import 'login.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int currentTab = 0;

  late LoginPage loginPage;
  late UserProfile userProfilePage;

  @override
  void initState() {
    if (GetStorage().read('email') != null ||
        GetStorage().read('password') != null) {
      userProfilePage = UserProfile(setCurrentPageState: setCurrentPageState);
      globals.pages[3] = userProfilePage;
    } else {
      loginPage = LoginPage(setCurrentPageState: setCurrentPageState);
      globals.pages[3] = loginPage;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      //Barra superior de la pantalla
      appBar: currentTab == 0 || currentTab == 1
          ? PreferredSize(
              preferredSize: const Size.fromHeight(60.0),
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                title: Image.network(
                    'https://media.discordapp.net/attachments/775922349362642955/906604815361134592/logo.png?width=998&height=676',
                    height: 70,
                    width: 70),
                elevation: 0,
              ),
            )
          : null,
      body: globals.currentPage,
      //Barra de navegacion inferior
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: currentTab,
        onTap: (int index) {
          setCurrentPageState(index);
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Inicio',
            icon: Icon(
              Icons.home_outlined,
              size: 35,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Buscar',
            icon: Icon(
              Icons.search,
              size: 35,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Carrito',
            icon: Icon(
              Icons.shopping_cart_outlined,
              size: 35,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Perfil',
            icon: Icon(
              Icons.person_outline_outlined,
              size: 35,
            ),
          ),
        ],
      ),
    );
  }

  void setCurrentPageState(int index) {
    setState(() {
      currentTab = index;
      globals.currentPage = globals.pages[index];
    });
  }
}

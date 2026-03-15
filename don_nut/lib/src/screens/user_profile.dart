import 'package:auto_size_text/auto_size_text.dart';
import 'package:don_nut/src/models/user.dart';
import 'package:don_nut/src/screens/login.dart';
import 'package:don_nut/src/services/auth_service.dart';
import 'package:don_nut/src/utils/global.dart' as globals;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key, required this.setCurrentPageState})
      : super(key: key);
  final dynamic setCurrentPageState;
  @override
  State<UserProfile> createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  AuthService authServices = AuthService();
  late Future<User?> user;
  final nombreTextController = TextEditingController();
  final primerApellidoTextController = TextEditingController();
  final segundoApellidoTextController = TextEditingController();
  final numeroCelularTextController = TextEditingController();
  bool saveEdit = false;

  @override
  void initState() {
    user = authServices.getUserInformation().whenComplete(() => initTexts());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      child: Center(
          child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 80),
            height: 100,
            child: Image.network(
                "https://media.discordapp.net/attachments/775922349362642955/906604815361134592/logo.png?width=200&height=150"),
          ),
          ReRunnableFutureBuilder(user, getUserInformation: getUserInformation),
          Container(
            margin: const EdgeInsets.only(top: 25, bottom: 20),
            width: 300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 70,
                  width: 70,
                  child: IconButton(
                      onPressed: () async {
                        const url = 'https://www.facebook.com/donasdonnut/';

                        if (await canLaunch(url)) {
                          await launch(url, forceSafariVC: false);
                        }
                      },
                      icon: Image.asset("assets/facebook.png")),
                ),
                SizedBox(
                  height: 70,
                  width: 70,
                  child: IconButton(
                    onPressed: () async {
                      const url = 'https://www.instagram.com/donasdonnut/';

                      if (await canLaunch(url)) {
                        await launch(url, forceSafariVC: false);
                      }
                    },
                    icon: Image.asset("assets/instagram.png"),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(children: [
                  Visibility(
                    visible: !saveEdit,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: SizedBox(
                      width: 300,
                      child: TextButton(
                          onPressed: () {
                            globals.token = '';
                            GetStorage().remove('email');
                            GetStorage().remove('password');
                            LoginPage loginPage;
                            loginPage = LoginPage(
                                setCurrentPageState:
                                    widget.setCurrentPageState);
                            globals.pages[3] = loginPage;
                            loginPage.setCurrentPageState(3);
                          },
                          style: TextButton.styleFrom(
                            primary: Colors.black,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.logout),
                              SizedBox(width: 5),
                              Text('Cerrar Sesión',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xff707070),
                                    fontWeight: FontWeight.w500,
                                  ))
                            ],
                          )),
                    ),
                  ),
                  Visibility(
                    visible: saveEdit,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: SizedBox(
                      width: 300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                              onPressed: () {
                                initTexts();
                                setState(() {
                                  saveEdit = false;
                                });
                                FocusManager.instance.primaryFocus
                                    ?.unfocus(); //Cierra el teclado
                              },
                              child: const Text("Cancelar",
                                  style: TextStyle(fontSize: 16)),
                              style: TextButton.styleFrom(
                                  primary: const Color(0xffAD53AE))),
                          TextButton(
                              onPressed: () {},
                              child: const Text("Guardar",
                                  style: TextStyle(fontSize: 16)),
                              style: TextButton.styleFrom(
                                primary: const Color(0xffAD53AE),
                              ))
                        ],
                      ),
                    ),
                  )
                ]),
              ],
            ),
          )
        ],
      )),
    );
  }

  List<Widget> getUserInformation(data, context) {
    List<Widget> userData = [];

    userData.add(Container(
      width: 300,
      margin: const EdgeInsets.only(top: 20),
      child: AutoSizeText(
          data.nombre + ' ' + data.primerApellido + ' ' + data.segundoApellido,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
    ));
    userData.add(Container(
      width: 300,
      margin: const EdgeInsets.only(top: 5, bottom: 20),
      child: AutoSizeText(data.email,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 16,
              color: Color(0xff707070),
              fontWeight: FontWeight.w500)),
    ));
    userData.add(SizedBox(
      width: 300,
      child: TextField(
        onChanged: (value) {
          setState(() {
            if (data.nombre != value) {
              saveEdit = true;
            } else {
              saveEdit = false;
            }
          });
        },
        inputFormatters: [LengthLimitingTextInputFormatter(30)],
        controller: nombreTextController,
        decoration: const InputDecoration(
          labelText: "Nombre",
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
    ));
    userData.add(SizedBox(
      width: 300,
      child: TextField(
        onChanged: (value) {
          setState(() {
            if (data.primerApellido != value) {
              saveEdit = true;
            } else {
              saveEdit = false;
            }
          });
        },
        inputFormatters: [LengthLimitingTextInputFormatter(30)],
        controller: primerApellidoTextController,
        decoration: const InputDecoration(
          labelText: "Primer Apellido",
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
    ));
    userData.add(SizedBox(
      width: 300,
      child: TextField(
        onChanged: (value) {
          setState(() {
            if (data.segundoApellido != value) {
              saveEdit = true;
            } else {
              saveEdit = false;
            }
          });
        },
        inputFormatters: [LengthLimitingTextInputFormatter(30)],
        controller: segundoApellidoTextController,
        decoration: const InputDecoration(
          labelText: "Segundo Apellido",
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
    ));
    userData.add(SizedBox(
      width: 300,
      child: TextField(
        onChanged: (value) {
          setState(() {
            if (data.telefono != value) {
              saveEdit = true;
            } else {
              saveEdit = false;
            }
          });
        },
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(15)
        ],
        controller: numeroCelularTextController,
        decoration: const InputDecoration(
          labelText: "Número de celular",
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
    ));

    return userData;
  }

  void initTexts() {
    nombreTextController.text = globals.user.nombre;
    primerApellidoTextController.text = globals.user.primerApellido;
    segundoApellidoTextController.text = globals.user.segundoApellido;
    numeroCelularTextController.text = globals.user.telefono;
  }
}

class ReRunnableFutureBuilder extends StatelessWidget {
  final Future<User?> _future;

  const ReRunnableFutureBuilder(this._future,
      {Key? key, required this.getUserInformation})
      : super(key: key);

  final Function getUserInformation;

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

          return Column(
            children: getUserInformation(snapshot.data, context),
          );
        });
  }
}

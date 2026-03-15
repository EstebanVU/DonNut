import 'package:flutter/material.dart';

class RecoverPassPage extends StatefulWidget {
  const RecoverPassPage({Key? key}) : super(key: key);

  @override
  State<RecoverPassPage> createState() => _RecoverPassPageState();
}

class _RecoverPassPageState extends State<RecoverPassPage> {
  final emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Center(
          child: Column(
        children: <Widget>[
          const SizedBox(height: 100),
          Image.network(
              "https://media.discordapp.net/attachments/775922349362642955/906604815361134592/logo.png?width=200&height=150"),
          const SizedBox(height: 25),
          const Text(
            "¿Has Olvidado tu contraseña?",
            style: TextStyle(
                color: Color(0xff707070),
                fontWeight: FontWeight.w900,
                fontSize: 20),
          ),
          const SizedBox(height: 25),
          const Text(
            "Ingresa tu correo y te enviaremos los \n"
            "          pasos para recuperarla",
            style: TextStyle(
                color: Color(0xff707070),
                fontWeight: FontWeight.w600,
                fontSize: 17),
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: 285,
            child: TextField(
              controller: emailTextController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
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
          const SizedBox(height: 55),
          SizedBox(
            width: 290,
            child: ElevatedButton(
              child: const Text("Enviar"),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: const Color(0xffAD53AE),
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                textStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      )),
    );
  }

  @override
  void initState() {
    super.initState();
    emailTextController.addListener(_printEmail);
  }

  @override
  void dispose() {
    super.dispose();
    emailTextController.dispose();
  }

  void _printEmail() {
    // ignore: avoid_print
    print('email: ${emailTextController.text}');
  }
}

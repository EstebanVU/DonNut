import 'package:don_nut/src/services/register_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
String auxpass='';
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
class _RegisterPageState extends State<RegisterPage> {
  late String nombre;
  late String primerApellido;
  late String segundoApellido;
  late String email;
  late String telefono;
  late String password;
  late String passwordVerificado;
  RegisterService registerService= RegisterService();
  bool valuefirst = false;
  registrarse() async {
    final response = await registerService.registrarUsuario(nombre, primerApellido, segundoApellido,  email,password, telefono);
    print(response.statusCode);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: <Widget>[
            Form(
              key:_formKey,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 70),
                  Image.network(
                      "https://media.discordapp.net/attachments/775922349362642955/906604815361134592/logo.png?width=160&height=120"),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: 320,
                    child: TextFormField(
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(30)
                      ],
                      decoration: const InputDecoration(
                        labelText: "Nombre:",
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
                      onChanged: (value) {
                        nombre = value;
                      },
                      onSaved: (value) {
                        nombre = value!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Llene este campo";
                        }
                        if (RegExp(r'(^[a-zA-Z ]*$)').hasMatch(value)==false) {
                          return "El nombre únicamente debe tener caracteres alfabéticos";
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 320,
                    child: TextFormField(
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(30)
                      ],
                      decoration: const InputDecoration(
                        labelText: "Primer apellido:",
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
                      onSaved: (value) {
                        primerApellido = value!;
                      },
                      onChanged: (value) {
                        primerApellido = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Llene este campo";
                        }
                        if (RegExp(r'(^[a-zA-Z ]*$)').hasMatch(value)==false) {
                          return "El apellido únicamente debe tener caracteres alfabéticos";
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 320,
                    child: TextFormField(
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(8)
                      ],
                      decoration: const InputDecoration(
                        labelText: "Segundo apellido:",
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
                      onSaved: (value) {
                        segundoApellido = value!;
                      },
                      onChanged: (value) {
                        segundoApellido = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Llene este campo";
                        }
                        if (RegExp(r'(^[a-zA-Z\u00C0-\u00FF]*$)').hasMatch(value)==false) {
                          return "El apellido únicamente debe tener caracteres alfabéticos";
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 320,
                    child: TextFormField(
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(50)
                      ],
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email:",
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
                      onSaved: (value) {
                        email = value!;
                      },
                      onChanged: (value) {
                        email = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Llene este campo";
                        }
                        if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)==false) {
                          return "La dirección de correo electronico debe ser válida";
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 320,
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(8)
                      ],
                      decoration: const InputDecoration(
                        prefixText: "+506 ",
                        labelText: "Telefono:",
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
                      onSaved: (value) {
                        telefono = value!;
                      },
                      onChanged: (value) {
                        telefono = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Llene este campo";
                        }
                        if (RegExp(r'(^[0-9]*$)').hasMatch(value)==false) {
                          return "El telefono únicamente debe tener caracteres numéricos";
                        }
                        if (value.length<8) {
                          return "El telefono debe tener ocho numeros";
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 320,
                    child: TextFormField(
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(16)
                      ],
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password:",
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
                      onSaved: (value) {
                        password = value!;
                      },
                      onChanged: (value) {
                        password = value;
                      },
                      validator: (value) {
                        auxpass= value!;
                        if (value.isEmpty) {
                          return "Llene este campo";
                        }
                        else if(value.length<8 || value.length>16){
                          return "La contraseña debe tener entre 8 y 16 caracteres";
                        }
                        else if(RegExp(r'(?=.*?[a-z])').hasMatch(value)==false){
                          return "La contraseña debe contener caracteres alfabéticos";
                        }
                        
                      },
                    ),
                  ),
                  SizedBox(
                    width: 320,
                    child: TextFormField(
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(16)
                      ],
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Verifica tu password:",
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
                      onSaved: (value) {
                        passwordVerificado = value!;
                      },
                      onChanged: (value) {
                        passwordVerificado = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Llene este campo";
                        }
                        if (value != auxpass) {
                          return "Las contraseñas no coinciden";
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CheckBoxFormField(),
                      Column(
                        children: [
                          Row(
                            children: const [
                              Text("Aceptar ",
                                  style: TextStyle(color: Color(0xff707070))),
                                  Text("términos y condiciones",
                              style: TextStyle(
                                  color: Color(0xffad53ae),
                                  fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 15,)
                        ],
                      ),
                      
                    ],
                  ),
                  SizedBox(
                    width: 290,
                    child: ElevatedButton(
                      child: const Text("Registrate"),
                      onPressed: () {if (_formKey.currentState!.validate()) {registrarse();}},
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xffAD53AE),
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text.rich(TextSpan(
                      text: '¿Ya tienes cuenta?',
                      style: const TextStyle(color: Color(0xff707070)),
                      children: <TextSpan>[
                        TextSpan(
                          text: ' Iniciar sesión',
                          style: const TextStyle(
                              color: Color(0xffad53ae),
                              fontWeight: FontWeight.w600),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pop(context);
                            },
                        )
                      ]))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CheckBoxFormField extends StatefulWidget {
  const CheckBoxFormField({Key? key}) : super(key: key);

  @override
  State<CheckBoxFormField> createState() => _CheckBoxFormFieldState();
}

class _CheckBoxFormFieldState extends State<CheckBoxFormField> {
  bool checkboxValue = false;
  @override
  Widget build(BuildContext context) {
    return FormField(builder: (state) {
      return Column(
        children: [
          Checkbox(value: checkboxValue, checkColor: Colors.white, activeColor: Colors.greenAccent,onChanged: (value) {
            checkboxValue = value!;
            state.didChange(value);
          },),
          
          Text(
            state.errorText ?? '',
            style: TextStyle(color: Theme.of(context).errorColor,)
          ),
        ],
      );
      
    },
    validator: (value) {
      if(!checkboxValue){
        return 'Debes aceptar \n los terminos';
      }
      return null;
    },
    );
  }
}

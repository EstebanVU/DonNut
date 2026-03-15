import 'dart:convert';
import 'package:don_nut/src/screens/register.dart';
import 'package:don_nut/src/utils/global.dart';
import 'package:http/http.dart' as http;

class RegisterService {
  Future<http.Response> registrarUsuario(
      nombre, primerApellido, segundoApellido, email, password, telefono) async {
    final response = await http.post(Uri.parse(url + 'auth/register'),
    headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
        body: jsonEncode({
          "nombre": nombre,
          "primerApellido": primerApellido,
          "segundoApellido":segundoApellido,
          "email":email,
          "password":password,
          "telefono":telefono,
        }));
        print(response.body);
    return response;
  }
}
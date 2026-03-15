import 'dart:convert';
import 'package:don_nut/src/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:don_nut/src/utils/global.dart' as globals;
import 'package:get_storage/get_storage.dart';

class AuthService {
  Future<http.Response> login(email, password) async {
    final response = await http.post(
      Uri.parse(globals.url + 'auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      globals.token = json.decode(response.body)['token'];
      GetStorage().write('email', email);
      GetStorage().write('password', password);
    }

    return response;
  }

  Future<String> automaticLogin() async {
    final response = await http.post(
      Uri.parse(globals.url + 'auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": GetStorage().read('email'),
        "password": GetStorage().read('password')
      }),
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      globals.token = jsonData['token'];

      return globals.token;
    } else {
      return "";
    }
  }

  Future<User?> getUserInformation() async {
    final response = await http.post(
      Uri.parse(globals.url + 'auth/me'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + globals.token
      },
    );

    User? _user;

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      _user = User(
          jsonData['idUsuario'],
          jsonData['nombre'],
          jsonData['primerApellido'],
          jsonData['SegundoApellido'],
          jsonData['email'],
          jsonData['telefono'],
          jsonData['fechaRegistro'],
          jsonData['estado'],
          jsonData['rol']);

      globals.user = _user;
    }
    return _user;
  }
}

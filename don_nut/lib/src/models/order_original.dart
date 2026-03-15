import 'package:don_nut/src/models/user.dart';

class OrderOriginal {
  int idOrden;
  String? fechaRegistro;
  String? estado;
  User? user;
  

  OrderOriginal(
      this.idOrden,
      this.estado,
      this.fechaRegistro,
      this.user,
      );
}

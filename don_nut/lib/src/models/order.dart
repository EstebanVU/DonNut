import 'package:don_nut/src/models/producto.dart';

class Order {
  int idProductoCarrito;
  int cantidad;
  Producto producto;
  Order(this.idProductoCarrito, this.cantidad, this.producto);
}

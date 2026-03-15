import 'package:auto_size_text/auto_size_text.dart';
import 'package:don_nut/src/models/producto.dart';
import 'package:don_nut/src/screens/product_info.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, required this.listTopProducts}) : super(key: key);
  final Future<List<Producto>> listTopProducts;
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final busquedaTextController = TextEditingController();

  List<Producto> products = []; //Contiene la informacion de los productos
  List<Widget> _products = []; //Contiene los productos a mostrar en pantalla
  List<String> listCategories = [
    'Todo',
    'Top Ventas',
    'Dulces',
    'Saladas',
  ];
  String? valueChoose = 'Todo';
  RangeValues values = const RangeValues(1000, 3000);
  bool resultados = false;

  @override
  void initState() {
    initProducts();
    super.initState();
  }

  void initProducts() async {
    products = await widget.listTopProducts;
    setState(() {
      _listProducts();
    });
  }

  @override
  void dispose() {
    super.dispose();
    busquedaTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const Align(
            alignment: Alignment.center,
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: 325,
            height: 35,
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _listProducts();
                });
              },
              textAlignVertical: TextAlignVertical.bottom,
              controller: busquedaTextController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "Buscar",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.filter_alt),
                  onPressed: () {
                    String? _valueChoose = valueChoose;
                    RangeValues _values = values;

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          actions: [
                            TextButton(
                                onPressed: () {
                                  valueChoose = _valueChoose;
                                  values = _values;
                                  Navigator.of(context).pop('Cancelar');
                                },
                                child: const Text("Cancelar"),
                                style: TextButton.styleFrom(
                                    primary: const Color(0xffAD53AE))),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    _listProducts();
                                  });
                                  Navigator.of(context).pop('Aplicar');
                                },
                                child: const Text("Aplicar"),
                                style: TextButton.styleFrom(
                                    primary: const Color(0xffAD53AE))),
                          ],
                          content: Container(
                              padding: const EdgeInsets.all(10.0),
                              color: Colors.white,
                              width: 380,
                              height: 440,
                              child: Column(
                                children: [
                                  const Text(
                                    "Filtro de busqueda",
                                    style: TextStyle(
                                        color: Color(0xff707070),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20),
                                  ),
                                  const SizedBox(
                                    height: 80,
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        "Categoria",
                                        style: TextStyle(
                                            color: Color(0xff707070),
                                            fontSize: 18),
                                      ),
                                      const SizedBox(
                                        width: 40,
                                      ),
                                      Expanded(
                                        child: StatefulBuilder(
                                          builder: (context, setState) =>
                                              DropdownButton<String>(
                                            hint: const Text("Seleccionar"),
                                            value: valueChoose,
                                            onChanged: (newValue) {
                                              setState(() {
                                                valueChoose = newValue!;
                                              });
                                            },
                                            items: listCategories
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 80,
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        "Precio",
                                        style: TextStyle(
                                            color: Color(0xff707070),
                                            fontSize: 18),
                                      ),
                                      StatefulBuilder(
                                        builder: (context, setState) =>
                                            SliderTheme(
                                                data: const SliderThemeData(
                                                  trackHeight: 1,
                                                ),
                                                child: RangeSlider(
                                                    values: values,
                                                    activeColor:
                                                        const Color(0xffAD53AE),
                                                    min: 500,
                                                    max: 4000,
                                                    divisions: 35,
                                                    labels: RangeLabels(
                                                      values.start
                                                          .round()
                                                          .toString(),
                                                      values.end
                                                          .round()
                                                          .toString(),
                                                    ),
                                                    onChanged:
                                                        (RangeValues newRange) {
                                                      setState(() {
                                                        values = newRange;
                                                      });
                                                    })),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        );
                      },
                    );
                  },
                ),
                alignLabelWithHint: false,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
              margin: const EdgeInsets.only(bottom: 22, top: 22),
              child: GridView.count(
                  clipBehavior: Clip.none,
                  crossAxisCount: 2,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  mainAxisSpacing: 22,
                  children: _products)),
          Visibility(
              visible: !resultados,
              child: const Text('No se encontraron resultados'))
        ],
      ),
    );
  }

//Metodo que devuelve la lista de los productos
  void _listProducts() {
    _products = [];
    bool _resultados = false;
    for (var item in products) {
      bool busquedaTxt = item.nombre
          .toLowerCase()
          .contains(busquedaTextController.text.toLowerCase());
      bool precio = int.parse(item.precio) >= values.start.round() &&
          int.parse(item.precio) <= values.end.round();

      if (busquedaTxt && precio && valueChoose == 'Todo' ||
          busquedaTxt && precio && valueChoose == item.tipo) {
        _resultados = true;
        _products.add(
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed("/product_info",
                  arguments: ProductPageArguments(
                      idProducto: item.idProducto,
                      nombre: item.nombre,
                      descripcion: item.descripcion,
                      costo: item.precio,
                      imagen: item.imgProducto));
            },
            child: Container(
              width: 155,
              height: 188,
              margin: const EdgeInsets.only(left: 22, right: 22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(children: [
                const SizedBox(height: 10),
                Image.network(
                  item.imgProducto,
                  height: 91,
                  width: 130,
                  alignment: Alignment.center,
                ),
                const SizedBox(height: 5),
                Container(
                    height: 45,
                    alignment: Alignment.center,
                    child: AutoSizeText(item.nombre,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20, color: Color(0xff707070)))),
                const SizedBox(height: 8),
                AutoSizeText(
                  '₡' + item.precio,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Color(0xffAD53AE),
                      fontWeight: FontWeight.w600,
                      fontSize: 20),
                ),
              ]),
            ),
          ),
        );
      }
    }

    resultados = _resultados;
  }
}

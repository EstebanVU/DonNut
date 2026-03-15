import 'package:don_nut/src/screens/preview_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String observacionPedido = '';
String latitud = '';
String longitud = '';
final observacionTextController = TextEditingController();

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  
  bool banderaAgrandar = false;
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(9.373786, -83.703023),
    zoom: 17,
  );
  Marker _destination = Marker(
      markerId: const MarkerId('destination'),
      infoWindow: const InfoWindow(title: 'Destination'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));
  @override
  void initState() {
    super.initState();
    latitud = '';
    longitud = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        //Barra superior de la pantalla
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              initialCameraPosition: _initialCameraPosition,
              markers: {if (_destination != null) _destination},
              onLongPress: _addMarker,
              minMaxZoomPreference: const MinMaxZoomPreference(13, 25),
              cameraTargetBounds: CameraTargetBounds(
                LatLngBounds(
                  northeast: const LatLng(9.424557, -83.650961),
                  southwest: const LatLng(9.297258, -83.783888),
                ),
              )),
          const BottomModal()
        ],
      ),
    );
  }

  void _biggerSetLocation() {
    banderaAgrandar = true;
  }

  void _addMarker(LatLng pos) {
    print("Latitud:" +
        double.parse(pos.latitude.toString()).toStringAsFixed(6) +
        " Longitud:" +
        double.parse(pos.longitude.toString()).toStringAsFixed(6));
    latitud = double.parse(pos.latitude.toString()).toStringAsFixed(6);
    longitud = double.parse(pos.longitude.toString()).toStringAsFixed(6);
    setState(() {
      _destination = Marker(
        markerId: const MarkerId('destination'),
        infoWindow: const InfoWindow(title: 'Destination'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: pos,
      );
    });
  }
}

class BottomModal extends StatelessWidget {
  const BottomModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.05,
        minChildSize: 0.05,
        maxChildSize: 0.45,
        builder: (context, scrollController) {
          return Container(
            child: SetLocation(scrollController),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )),
          );
        });
  }
}

class SetLocation extends StatelessWidget {
  final ScrollController scrollController;
  const SetLocation(this.scrollController, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as LocationDetailArguments;
    observacionPedido = arguments.observacionPedido;
    return SingleChildScrollView(
      controller: scrollController,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            const Divider(
              indent: 150,
              endIndent: 150,
              thickness: 1,
              color: Colors.black,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("Establecer Ubicación",
                style: TextStyle(color: Colors.black, fontSize: 20)),
            Row(children: const [
              SizedBox(
                width: 50,
                height: 80,
              ),
              Text("Favoritos:",
                  style: TextStyle(
                    color: Color(0xff707070),
                    fontSize: 20,
                  )),
            ]),
            Row(
              children: const [
                SizedBox(
                  width: 50,
                  height: 30,
                ),
                Text(
                  "Observaciones:",
                  style: TextStyle(color: Color(0xff707070), fontSize: 20),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 50),
              child: TextField(
                controller: observacionTextController,
                maxLength: 200,
                decoration: const InputDecoration(
                  hintText: 'Escribe algo...',
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
            SizedBox(
              width: 300,
              child: ElevatedButton(
                child: const Text("Confirmar"),
                onPressed: () {
                  if (latitud != '' && longitud != '') {
                    Navigator.of(context).pushNamed("/preview",
                        arguments: PreviewDetailArguments(
                            observacionPedido: observacionPedido,
                            observacionUbicacion:observacionTextController.text.toString(),
                            ubicLatitud: latitud,
                            ubicLongitud: longitud));
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xffAD53AE),
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class LocationDetailArguments {
  String observacionPedido;
  LocationDetailArguments({
    required this.observacionPedido,
  });
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:servicios_domicilio/constants/constants.dart';
import 'package:servicios_domicilio/helpers/mapbox_handler.dart';
import 'package:servicios_domicilio/helpers/shared_prefs.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/servicios_controller.dart';
import '../helpers/commonds.dart';
import '../services/tecnico_response.dart';
import 'package:quickalert/quickalert.dart';

class MapaDetalle extends StatefulWidget {
  final Map modifiedResponse;
  final ServicioElement tec;
  final LatLng destination;
  const MapaDetalle(
      {Key? key,
      required this.modifiedResponse,
      required this.tec,
      required this.destination})
      : super(key: key);

  @override
  State<MapaDetalle> createState() => _MapaDetalleState();
}

class _MapaDetalleState extends State<MapaDetalle> {
  final myLocation = getCurrentLatLngSharedPrefs();
  final _pageController = PageController();
  final controller = Get.put(ServiciosController());
// Directions API response related
  late String distance;
  late String dropOffTime;
  late Map geometry;
  late LatLng polyline;
  late MapboxMapController controllerMap;
  late CameraPosition _cameraPosition;
  late LatLng destination;
  //

  _initializeDirectionsResponse() {
    destination = widget.destination;
    //Obtenemos la distancia
    distance = (widget.modifiedResponse['distance'] / 1000).toStringAsFixed(1);
    //Convertimos la hora estimada de llegada
    dropOffTime = getDropOffTime(widget.modifiedResponse['duration']);
    //Obtenemos el mapa de coordenadas para trazar la ruta
    geometry = widget.modifiedResponse['geometry'];
    //final time = ((widget.modifiedResponse['duration']) / 60).round();
  }

  _addSourceAndLineLayer() async {
    //Agregamos el marcador del destino
    await controllerMap.addSymbol(
      SymbolOptions(
        geometry: destination,
        iconSize: 0.7,
        iconImage: 'assets/marker.png',
      ),
    );
    // Create a polyLine between source and destination
    final fills = {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "id": 0,
          "properties": <String, dynamic>{},
          "geometry": geometry,
        },
      ],
    };

    // Add new source and lineLayer
    await controllerMap.addSource(
        "fills", GeojsonSourceProperties(data: fills));
    await controllerMap.addLineLayer(
      "fills",
      "lines",
      LineLayerProperties(
        lineColor: Colors.redAccent.toHexStringRGB(),
        lineCap: "round",
        lineJoin: "round",
        lineWidth: 3,
      ),
    );
  }

  _onMapCreated(MapboxMapController controllerMap) async {
    this.controllerMap = controllerMap;
  }

  @override
  void initState() {
    _initializeDirectionsResponse();
    //Generamos la vista del mapa.
    _cameraPosition = CameraPosition(
        target: getCenterCoordinatesForPolyline(geometry), zoom: 15);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final top2 = MediaQuery.of(context).size.height * 0.05;
    return Scaffold(
      body: Stack(
        children: [
          MapboxMap(
            accessToken: mapboxToken,
            initialCameraPosition: _cameraPosition,
            onMapCreated: _onMapCreated,
            //Estilo del mapa
            styleString: 'mapbox://styles/mapbox/satellite-streets-v12',
            onStyleLoadedCallback: _addSourceAndLineLayer,
            myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
            myLocationEnabled: true,
          ),
          Positioned(
              left: 10,
              top: top2,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.75),
                        Colors.white.withOpacity(0.65),
                      ]),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.blue,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              )),
          Positioned(
              top: top2,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(9.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                  ),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.75),
                        Colors.white.withOpacity(0.65),
                      ]),
                ),
                child: Column(
                  children: [
                    Text(
                      'Llegada estimada $dropOffTime',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Distancia: $distance km',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: MediaQuery.of(context).size.height * 0.2,
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.servicios.length,
              itemBuilder: (context, index) {
                final item = controller.servicios[index];
                return _MapItemDetails(
                  item: item,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          QuickAlert.show(
              context: context,
              type: QuickAlertType.confirm,
              title: '¿Iniciar navegación?',
              cancelBtnText: 'No',
              confirmBtnText: 'Sí',
              onConfirmBtnTap: () async {
                await _launchNavigation(destination);
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              });
        },
        child: const Icon(Icons.navigation),
      ),
    );
  }
}

//Navegación con google maps
Future<void> _launchNavigation(LatLng destination) async {
  Uri url = Uri.parse(
      'google.navigation:q=${destination.latitude},${destination.longitude}');
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}

class _MapItemDetails extends StatelessWidget {
  const _MapItemDetails({
    Key? key,
    required this.item,
  }) : super(key: key);
  final ServicioElement item;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      //height: size.height * 0.18,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 12, left: 14, right: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Folio: ${item.folio}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              item.cliente,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: GoogleFonts.poppins(
                  fontSize: 30, fontWeight: FontWeight.w800),
            ),
            Row(
              children: [
                const Icon(Icons.room_outlined),
                SizedBox(
                  width: size.width * 0.87,
                  child: Text(
                    item.domicilio,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  '${item.fecha.day}/${item.fecha.month}/${item.fecha.year}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  item.horario,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.05,
            )
          ],
        ),
      ),
    );
  }
}

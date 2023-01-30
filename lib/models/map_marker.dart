import 'package:latlong2/latlong.dart';

class MapMarker {
  const MapMarker({
    required this.title,
    required this.address,
    required this.location,
  });

  final String title;
  final String address;
  final LatLng location;
}
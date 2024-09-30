import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smartbreath/core/services/location_service.dart';
import 'package:smartbreath/core/services/firebase_service.dart';

class MapViewModel extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  final FirebaseService _firebaseService = FirebaseService();

  GoogleMapController? _mapController;
  Position? _position;
  Map<MarkerId, Marker> _markers = {};
  bool _showBottomSheet = false;
  LatLng? _selectedLocation;
  bool _isLocationRisky = false;

  Position? get position => _position;
  Map<MarkerId, Marker> get markers => _markers;
  bool get showBottomSheet => _showBottomSheet;
  LatLng? get selectedLocation => _selectedLocation;
  bool get isLocationRisky => _isLocationRisky;

  MapViewModel() {
    _init();
  }

  void _init() async {
    _position = await _locationService.getCurrentLocation();
    await _loadMarkers();
    notifyListeners();
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _loadMarkers() async {
    final dangerousLocations = await _firebaseService.getDangerousLocations();
    for (var location in dangerousLocations) {
      _addMarker(location);
    }
  }

  void _addMarker(LatLng position) {
    final markerId = MarkerId(position.toString());
    final marker = Marker(
      markerId: markerId,
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    _markers[markerId] = marker;
  }

  void onMapLongPress(LatLng position) {
    _selectedLocation = position;
    _showBottomSheet = true;
    _checkLocationRisk();
    notifyListeners();
  }

  void _checkLocationRisk() {
    // Bu metod, seçilen konumun riskli olup olmadığını kontrol eder.
    // Gerçek uygulamada, bu kontrol Firebase veya başka bir veri kaynağı üzerinden yapılabilir.
    _isLocationRisky = _markers.values.any((marker) =>
        _calculateDistance(marker.position, _selectedLocation!) < 0.1);
  }

  double _calculateDistance(LatLng pos1, LatLng pos2) {
    // İki nokta arasındaki mesafeyi hesaplar (km cinsinden)
    return Geolocator.distanceBetween(
            pos1.latitude, pos1.longitude, pos2.latitude, pos2.longitude) /
        1000;
  }

  void addComment(BuildContext context) {
    // Yorum ekleme işlemi
    // Bu metod, yorum ekleme sayfasına yönlendirme yapabilir
  }

  void viewComments(BuildContext context) {
    // Yorumları görüntüleme işlemi
    // Bu metod, yorumları görüntüleme sayfasına yönlendirme yapabilir
  }
}
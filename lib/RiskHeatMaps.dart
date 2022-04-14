import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smartbreath/services/Configuration.dart';

class RiskHeatMaps extends StatefulWidget {
  @override
  _RiskHeatMapsState createState() => _RiskHeatMapsState();
}

class _RiskHeatMapsState extends State<RiskHeatMaps> {
  GoogleMapController mapController;
  BitmapDescriptor mapMarker;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Position position;
  void setCustomMaker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), "assets/image/heat.png");
  }

  void getMarkers(double lat, double long) {
    MarkerId markerId = MarkerId(lat.toString() + long.toString());
    Marker marker = Marker(
        markerId: markerId, position: LatLng(lat, long), icon: mapMarker);
    setState(() {
      markers[markerId] = marker;
    });
  }

  void getMarker() async {
    var pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      position = pos;
    });
    await FirebaseFirestore.instance
        .collection('location')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        var uzunluk = doc["latitude"];
        var genislik = doc["longitude"];
        getMarkers(uzunluk, genislik);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMarker();
    setCustomMaker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: position == null
            ? Center(
                child: CircularProgressIndicator(
                  color: primaryGreen,
                ),
              )
            : GoogleMap(
                markers: Set<Marker>.of(markers.values),
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(position.latitude.toDouble(),
                      position.longitude.toDouble()),
                  zoom: 15.0,
                ),
                onMapCreated: (GoogleMapController controller) async {
                  mapController = controller;
                },
              ),
      ),
    );
  }
}

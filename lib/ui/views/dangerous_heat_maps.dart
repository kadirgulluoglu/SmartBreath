import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smartbreath/core/viewmodels/map_view_model.dart';
import 'package:smartbreath/ui/widgets/custom_bottom_sheet.dart';
import 'package:smartbreath/ui/widgets/custom_circular_menu.dart';
import 'package:smartbreath/ui/widgets/map_search_bar.dart';
import 'package:smartbreath/core/constants/app_constants.dart';
import 'package:smartbreath/core/theme/app_theme.dart';

class DangerousHeatMapsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MapViewModel(),
      child: DangerousHeatMapsContent(),
    );
  }
}

class DangerousHeatMapsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mapViewModel = Provider.of<MapViewModel>(context);

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          _buildMap(context),
          _buildSearchBar(context),
          _buildCircularMenu(context),
          if (mapViewModel.showBottomSheet) _buildBottomSheet(context),
        ],
      ),
    );
  }

  Widget _buildMap(BuildContext context) {
    final mapViewModel = Provider.of<MapViewModel>(context);

    return mapViewModel.position == null
        ? Center(child: CircularProgressIndicator(color: AppTheme.primaryGreen))
        : GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(mapViewModel.position!.latitude,
                  mapViewModel.position!.longitude),
              zoom: 15,
            ),
            onMapCreated: mapViewModel.onMapCreated,
            markers: Set<Marker>.of(mapViewModel.markers.values),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onLongPress: mapViewModel.onMapLongPress,
          );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Positioned(
      top: 50,
      child: MapSearchBar(),
    );
  }

  Widget _buildCircularMenu(BuildContext context) {
    return CustomCircularMenu();
  }

  Widget _buildBottomSheet(BuildContext context) {
    return CustomBottomSheet();
  }
}
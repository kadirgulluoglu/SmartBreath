import 'package:flutter/material.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:provider/provider.dart';
import 'package:smartbreath/core/viewmodels/map_view_model.dart';

class CustomCircularMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mapViewModel = Provider.of<MapViewModel>(context);

    return CircularMenu(
      alignment: Alignment.bottomLeft,
      toggleButtonColor: Colors.blue,
      items: [
        CircularMenuItem(
          icon: Icons.my_location,
          color: Colors.green,
          onTap: () {
            // Kullanıcının konumuna git
          },
        ),
        CircularMenuItem(
          icon: Icons.refresh,
          color: Colors.orange,
          onTap: () {
            // Haritayı yenile
          },
        ),
        CircularMenuItem(
          icon: Icons.info,
          color: Colors.purple,
          onTap: () {
            // Bilgi göster
          },
        ),
      ],
    );
  }
}
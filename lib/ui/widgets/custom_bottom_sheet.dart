import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartbreath/core/viewmodels/map_view_model.dart';
import 'package:smartbreath/core/theme/app_theme.dart';

class CustomBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mapViewModel = Provider.of<MapViewModel>(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.1,
      maxChildSize: 0.9,
      builder: (_, controller) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: controller,
            children: [
              SizedBox(height: 10),
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Seçilen Konum',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                '${mapViewModel.selectedLocation?.latitude.toStringAsFixed(4)}, ${mapViewModel.selectedLocation?.longitude.toStringAsFixed(4)}',
                style: Theme.of(context).textTheme.subtitle1,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              _buildRiskInfo(context),
              SizedBox(height: 20),
              _buildActionButtons(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRiskInfo(BuildContext context) {
    final mapViewModel = Provider.of<MapViewModel>(context);
    return Column(
      children: [
        Text(
          'Risk Durumu',
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(height: 10),
        Text(
          mapViewModel.isLocationRisky ? 'Riskli' : 'Güvenli',
          style: TextStyle(
            color: mapViewModel.isLocationRisky ? Colors.red : AppTheme.primaryGreen,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final mapViewModel = Provider.of<MapViewModel>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => mapViewModel.addComment(context),
          child: Text('Yorum Ekle'),
          style: ElevatedButton.styleFrom(primary: AppTheme.primaryGreen),
        ),
        ElevatedButton(
          onPressed: () => mapViewModel.viewComments(context),
          child: Text('Yorumları Gör'),
          style: ElevatedButton.styleFrom(primary: AppTheme.primaryGreen),
        ),
      ],
    );
  }
}
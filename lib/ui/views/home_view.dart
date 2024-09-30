import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartbreath/core/viewmodels/home_view_model.dart';
import 'package:smartbreath/ui/widgets/bluetooth_status_widget.dart';
import 'package:smartbreath/ui/widgets/sensor_data_widget.dart';
import 'package:smartbreath/core/theme/app_theme.dart'; // Bu satırı ekleyin

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: HomeViewContent(),
    );
  }
}

class HomeViewContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      backgroundColor: AppTheme.primaryGreen, // Bu satırı değiştirin
      body: ListView(
        children: <Widget>[
          _buildLogo(context),
          SizedBox(height: 40.0),
          BluetoothStatusWidget(),
          SensorDataWidget(),
        ],
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 40.0),
          child: Image.asset(
            'assets/image/logo_two.png',
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}

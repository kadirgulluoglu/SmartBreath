import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartbreath/core/viewmodels/home_view_model.dart';
import 'package:smartbreath/core/constants/app_constants.dart';
import 'package:smartbreath/core/theme/app_theme.dart'; // Bu satırı ekleyin

class SensorDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height - 185.0,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
      ),
      child: ListView(
        primary: false,
        padding: EdgeInsets.only(left: 25.0, right: 20.0),
        children: <Widget>[
          _buildSensorItem(
              context,
              'assets/image/icon_temp.png',
              'Sıcaklık',
              '${viewModel.sensorData.temperature}',
              viewModel.sensorData.isTemperatureNormal),
          _buildDivider(),
          _buildSensorItem(
              context,
              'assets/image/icon_humudity.png',
              'Nem Oranı',
              '% ${viewModel.sensorData.humidity}',
              viewModel.sensorData.isHumidityNormal),
          _buildDivider(),
          _buildSensorItem(
              context,
              'assets/image/icon_gas.png',
              'Karbonmonoksit',
              '${viewModel.sensorData.carbonMonoxide} ppm',
              viewModel.sensorData.isCarbonMonoxideNormal),
          _buildDivider(),
        ],
      ),
    );
  }

  Widget _buildSensorItem(BuildContext context, String imgPath, String title,
      String value, bool isNormal) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              Image.asset(
                imgPath,
                fit: BoxFit.cover,
                color: Theme.of(context).focusColor,
                height: 75.0,
                width: 75.0,
              ),
              SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 20.0,
                      color: isNormal
                          ? AppTheme.primaryGreen
                          : Colors.red, // Bu satırı değiştirin
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey[300],
      height: 20.0,
      thickness: 3.0,
      indent: 0.0,
      endIndent: 0.0,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartbreath/core/viewmodels/home_view_model.dart';

class BluetoothStatusWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text('Bluetooth Status: ${viewModel.connectionStatus}'),
          ElevatedButton(
            onPressed: viewModel.isConnected ? viewModel.disconnectFromDevice : viewModel.connectToDevice,
            child: Text(viewModel.isConnected ? 'Disconnect' : 'Connect'),
          ),
        ],
      ),
    );
  }
}
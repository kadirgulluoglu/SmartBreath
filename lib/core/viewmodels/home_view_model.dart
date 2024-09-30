import 'package:flutter/foundation.dart';
import 'package:smartbreath/core/services/bluetooth_service.dart';
import 'package:smartbreath/core/services/sensor_service.dart';
import 'package:smartbreath/core/models/sensor_data.dart';

class HomeViewModel extends ChangeNotifier {
  final BluetoothService _bluetoothService;
  final SensorService _sensorService;

  SensorData _sensorData = SensorData();
  String _connectionStatus = "Disconnected";
  bool _isConnected = false;

  HomeViewModel({
    required BluetoothService bluetoothService,
    required SensorService sensorService,
  })  : _bluetoothService = bluetoothService,
        _sensorService = sensorService {
    _init();
  }

  SensorData get sensorData => _sensorData;
  String get connectionStatus => _connectionStatus;
  bool get isConnected => _isConnected;

  Future<void> _init() async {
    await _bluetoothService.init();
    _bluetoothService.connectionStatus.listen((status) {
      _connectionStatus = status;
      _isConnected = status == "Connected";
      notifyListeners();
    });

    _sensorService.sensorDataStream.listen((data) {
      _sensorData = data;
      notifyListeners();
    });
  }

  Future<void> connectToDevice() async {
    await _bluetoothService.connectToDevice();
  }

  Future<void> disconnectFromDevice() async {
    await _bluetoothService.disconnect();
  }
}
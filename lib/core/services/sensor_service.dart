import 'dart:async';
import 'dart:convert';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:smartbreath/core/models/sensor_data.dart';

class SensorService {
  final String SERVICE_UUID = "Your Service UUID";
  final String CHARACTERISTIC_UUID = "Your Characteristic UUID";

  BluetoothDevice? _device;
  StreamController<SensorData> _sensorDataController = StreamController<SensorData>.broadcast();

  Stream<SensorData> get sensorDataStream => _sensorDataController.stream;

  void setDevice(BluetoothDevice device) {
    _device = device;
  }

  Future<void> startReading() async {
    if (_device == null) {
      throw Exception("Bluetooth device is not set");
    }

    List<BluetoothService> services = await _device!.discoverServices();
    for (BluetoothService service in services) {
      if (service.uuid.toString() == SERVICE_UUID) {
        for (BluetoothCharacteristic characteristic in service.characteristics) {
          if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
            await characteristic.setNotifyValue(true);
            characteristic.value.listen((value) {
              if (value.isNotEmpty) {
                _processData(value);
              }
            });
          }
        }
      }
    }
  }

  void _processData(List<int> data) {
    String decodedData = utf8.decode(data);
    List<String> values = decodedData.split(',');

    if (values.length >= 3) {
      double temp = double.tryParse(values[0]) ?? 0.0;
      double humi = double.tryParse(values[1]) ?? 0.0;
      double mq9 = double.tryParse(values[2]) ?? 0.0;

      SensorData sensorData = SensorData(
        temperature: temp,
        humidity: humi,
        carbonMonoxide: mq9,
      );

      _sensorDataController.add(sensorData);
    }
  }

  void dispose() {
    _sensorDataController.close();
  }
}
import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartbreath/RiskHeatMaps.dart';
import 'package:smartbreath/main.dart';
import 'package:smartbreath/services/Configuration.dart';
import 'package:smartbreath/services/user_model.dart';

class ChatPage extends StatefulWidget {
  final BluetoothDevice server;
  final Function menuCallback;
  const ChatPage({this.server, this.menuCallback});

  @override
  _ChatPage createState() => new _ChatPage();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _ChatPage extends State<ChatPage> {
  User user = FirebaseAuth.instance.currentUser;
  UserModel userModel = UserModel();

  static final clientID = 0;
  BluetoothConnection connection;

  List<_Message> messages = List<_Message>();
  String gelenmesaj = '';
  String nem = '';
  String sicaklik = '';
  String sicaklik2 = '';
  String _messageBuffer = '';
  bool sicaklik2renk = false;
  bool nemrenk = false;
  bool sicaklikrenk = false;
  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;
  bool isDisconnecting = false;

  Position position;

  void currentLocation() async {
    var pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      position = pos;
    });
    var lat = pos.latitude;
    var long = pos.longitude;
    await FirebaseFirestore.instance
        .collection('location')
        .add({'latitude': lat, 'longitude': long});
  }

  @override
  void initState() {
    super.initState();
    currentLocation();
    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });
      connection.input.listen(_onDataReceived).onDone(() {
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  Future getFirebase() async {
    await FirebaseFirestore.instance
        .collection("person")
        .doc(user.uid)
        .get()
        .then((value) => {
              this.userModel = UserModel.fromMap(value.data()),
              setState(() {}),
            });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final List<Row> list = messages.map((_message) {
      gelenmesaj = _message.text.trim();

      nem = "${gelenmesaj.substring(0, 5)}";
      sicaklik = "${gelenmesaj.substring(6, 11)}";
      sicaklik2 = "${gelenmesaj.substring(12, 17)}";

      if (double.parse(sicaklik) >= 35) {
        sicaklikrenk = true;
      }
      if (double.parse(nem) >= 40) {
        nemrenk = true;
      }
      if (double.parse(sicaklik2) > 316.5) {
        sicaklik2renk = true;
      }

      return Row(
        children: <Widget>[
          Container(
            child: Text(
              (text) {
                return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
              }(_message.text.trim()),
            ),
          ),
        ],
        mainAxisAlignment: _message.whom == clientID
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
      );
    }).toList();
    return Scaffold(
      backgroundColor: primaryGreen,
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 125.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                          child: Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                          onTap: widget.menuCallback)
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 25.0),
          Padding(
            padding: EdgeInsets.only(left: 40.0),
            child: Image.asset('assets/image/logo2.png'),
          ),
          SizedBox(height: 40.0),
          Container(
            height: size.height - 185.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
            ),
            child: ListView(
              primary: false,
              padding: EdgeInsets.only(left: 25.0, right: 20.0),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 45.0),
                  child: Container(
                    height: size.height - 300.0,
                    child: ListView(
                      children: [
                        _buildFoodItem('assets/image/icon-temp.png', 'Sıcaklık',
                            '$sicaklik', sicaklikrenk),
                        _buildFoodItem('assets/image/icon-humudity.png', 'Nem',
                            '$nem', nemrenk),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          RaisedButton(
              color: primaryGreen,
              child: Text(
                "Risk Haritası",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RiskHeatMaps()));
              }),
        ],
      ),
    );
  }

  Widget _buildFoodItem(
      String imgPath, String foodName, String price, bool renk) {
    return Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: InkWell(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    child: Row(children: [
                  Hero(
                      tag: imgPath,
                      child: Image(
                          image: AssetImage(imgPath),
                          fit: BoxFit.cover,
                          height: 75.0,
                          width: 75.0)),
                  SizedBox(width: 10.0),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          foodName,
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 23,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          price,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 20.0,
                            color: renk ? Colors.red : primaryGreen,
                          ),
                        )
                      ])
                ])),
              ],
            )));
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        messages.add(
          _Message(
            1,
            backspacesCounter > 0
                ? _messageBuffer.substring(
                    0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index),
          ),
        );
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }
}

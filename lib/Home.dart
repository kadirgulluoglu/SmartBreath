import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smartbreath/RiskHeatMaps.dart';
import 'package:smartbreath/services/Configuration.dart';
import 'package:smartbreath/services/user_model.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User user = FirebaseAuth.instance.currentUser;
  UserModel userModel = UserModel();
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

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 25.0),
          Padding(
            padding: EdgeInsets.only(left: 40.0),
            child: Image.asset(
              'assets/image/logo2.png',
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 40.0),
          Container(
            height: size.height - 185.0,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
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
                        _buildFoodItem('assets/image/icon-temp.png',
                            Locales.string(context, 'sicaklik'), '25', true),
                        _buildFoodItem('assets/image/icon-humudity.png',
                            Locales.string(context, 'nem'), '100', false),
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
                          color: Theme.of(context).focusColor,
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
}

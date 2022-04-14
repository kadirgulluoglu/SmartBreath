import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartbreath/Anasayfa.dart';
import 'package:smartbreath/services/user_model.dart';

class DrawerPage extends StatefulWidget {
  final Function(int) menuCallback;
  DrawerPage({this.menuCallback});
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  int selectedMenuIndex = 0;
  List<IconData> icons = [
    Icons.home,
    Icons.history,
    Icons.account_balance,
  ];
  List<String> menuItems = [
    'Anasayfa',
    'Geçmiş',
    'Profil',
  ];
  UserModel userModel = UserModel();
  User user = FirebaseAuth.instance.currentUser;
  @override
  initState() {
    super.initState();
    getFirebase();
  }

  Widget buildMenuRow(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedMenuIndex = index;
          widget.menuCallback(index);
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.0),
        child: Row(
          children: [
            Icon(
              icons[index],
              color: selectedMenuIndex == index ? Colors.white : Colors.white54,
            ),
            SizedBox(width: 10),
            Text(
              menuItems[index],
              style: TextStyle(
                color:
                    selectedMenuIndex == index ? Colors.white : Colors.white54,
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
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
      body: Container(
        padding: EdgeInsets.only(left: 20, top: 70, bottom: 30),
        color: Color(0xcc40b65b),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: ClipOval(
                    child: Image.network(
                      'https://pbs.twimg.com/profile_images/1454356676014968833/OGUlX-Bz_400x400.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${userModel.name}',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: menuItems
                  .asMap()
                  .entries
                  .map((mapEntry) => buildMenuRow(mapEntry.key))
                  .toList(),
            ),
            Row(
              children: [
                Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                Text(
                  'Ayarlar',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                Container(
                  width: 2,
                  height: 20,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                TextButton(
                  child: Text(
                    'Çıkış Yap',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    logout(context);
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('BeniHatirla', false);
  await FirebaseAuth.instance.signOut();
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => Anasayfa()));
}

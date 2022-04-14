import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartbreath/login.dart';
import 'package:smartbreath/services/Configuration.dart';
import 'package:smartbreath/services/user_model.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //formkey

  final _formkey = GlobalKey<FormState>();
  //textcontrolller
  final TextEditingController namecontroller = new TextEditingController();
  final TextEditingController emailcontroller = new TextEditingController();
  final TextEditingController passwordcontroller = new TextEditingController();
  final TextEditingController passwordagaincontroller =
      new TextEditingController();
  bool isObscure = true;
  bool isLoading = false;

  Widget buildAd() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ad Soyad',
          style: TextStyle(
            color: primaryGreen,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: primaryGreen,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                )
              ]),
          height: 60,
          child: TextFormField(
            validator: (value) {
              RegExp regexp = new RegExp(r'^.{6,}$');
              if (value.isEmpty) {
                return ("\t Lütfen Ad-Soyadınızı Giriniz.");
              }
              if (!regexp.hasMatch(value)) {
                return ("\t Lütfen Geçerli Ad-Soyad Giriniz.");
              }
              return null;
            },
            controller: namecontroller,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 20),
                prefixIcon: Icon(
                  Icons.account_circle,
                  color: Theme.of(context).primaryColor,
                ),
                hintText: 'Ad Soyad',
                hintStyle:
                    TextStyle(color: Theme.of(context).secondaryHeaderColor)),
          ),
        )
      ],
    );
  }

  Widget buildEposta() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'E-Posta',
          style: TextStyle(
            color: primaryGreen,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: primaryGreen,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                )
              ]),
          height: 60,
          child: TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return "\t Lütfen Mail Adresinizi Giriniz..";
              }
              if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                  .hasMatch(value)) {
                return "\t Lütfen Geçerli Mail Adresinizi giriniz..";
              }
              return null;
            },
            onSaved: (value) {
              emailcontroller.text = value;
            },
            controller: emailcontroller,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 15),
                prefixIcon: Icon(
                  Icons.email,
                  color: Theme.of(context).primaryColor,
                ),
                hintText: 'E-Posta',
                hintStyle:
                    TextStyle(color: Theme.of(context).secondaryHeaderColor)),
          ),
        )
      ],
    );
  }

  Widget buildSifre() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Şifre',
          style: TextStyle(
            color: Color(0xff40b65b),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: primaryGreen,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                )
              ]),
          height: 60,
          child: TextFormField(
            validator: (value) {
              RegExp regexp = new RegExp(r'^.{6,}$');
              if (value.isEmpty) {
                return ("\t Lütfen Şifrenizi Giriniz.");
              }
              if (!regexp.hasMatch(value)) {
                return ("\t Lütfen Geçerli Şifre Giriniz.");
              }
              return null;
            },
            onSaved: (value) {
              passwordcontroller.text = value;
            },
            controller: passwordcontroller,
            keyboardType: TextInputType.visiblePassword,
            obscureText: isObscure,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 15),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Theme.of(context).primaryColor,
                ),
                hintText: 'Şifre',
                hintStyle:
                    TextStyle(color: Theme.of(context).secondaryHeaderColor)),
          ),
        )
      ],
    );
  }

  Widget buildYeniSifre() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Şifre Tekrar',
          style: TextStyle(
            color: primaryGreen,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: primaryGreen,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                )
              ]),
          height: 60,
          child: TextFormField(
            validator: (value) {
              if (passwordcontroller.text != passwordagaincontroller.text) {
                return "\t Parolalar eşleşmiyor";
              }
              return null;
            },
            onSaved: (value) {
              passwordagaincontroller.text = value;
            },
            controller: passwordagaincontroller,
            keyboardType: TextInputType.visiblePassword,
            obscureText: isObscure,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 20),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Theme.of(context).primaryColor,
                ),
                hintText: 'Şifre',
                hintStyle: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                )),
          ),
        )
      ],
    );
  }

  Widget buildKayitolbuton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5,
        child: Text('KAYIT OL',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold)),
        onPressed: () {
          signUp(emailcontroller.text, passwordcontroller.text);
        },
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: primaryGreen,
      ),
    );
  }

  Widget buildSignInbuton() {
    return GestureDetector(
      onTap: () {
        return Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Hesabınız var mı? ',
              style: TextStyle(
                  color: primaryGreen,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
            TextSpan(
                text: 'Giriş Yapın',
                style: TextStyle(
                  fontSize: 18,
                  color: primaryGreen,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor,
                    ],
                  ),
                ),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.07,
                    vertical: size.height * 0.14,
                  ),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: size.width * 0.6,
                          child: FittedBox(
                            child: Text(
                              'KAYIT OL',
                              style: TextStyle(
                                  color: primaryGreen,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.10),
                        buildAd(),
                        SizedBox(height: size.height * 0.02),
                        buildEposta(),
                        SizedBox(height: size.height * 0.02),
                        buildSifre(),
                        SizedBox(height: size.height * 0.02),
                        buildYeniSifre(),
                        SizedBox(height: 20),
                        isLoading
                            ? Container(
                                padding: EdgeInsets.symmetric(vertical: 25),
                                child: CircularProgressIndicator(
                                  color: primaryGreen,
                                ),
                              )
                            : buildKayitolbuton(),
                        buildSignInbuton(),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    if (_formkey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then(
            (value) => {
              postDetailsToFirestore(),
            },
          )
          .catchError((e) {
        Fluttertoast.showToast(msg: e.message);
      });
      setState(() {
        isLoading = false;
      });
    }
  }

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User user = _auth.currentUser;
    UserModel userModel = UserModel();
    userModel.uid = user.uid;
    userModel.name = namecontroller.text;
    userModel.email = user.email;

    await firebaseFirestore
        .collection("person")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Kayıt Başarılı");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }
}

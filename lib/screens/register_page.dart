import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/kullanici.dart';
import 'location_page.dart';
import 'login_page.dart';

final DateTime timestamp = DateTime.now();
final kullaniciRef = FirebaseFirestore.instance.collection("kullanıcılar");

Kullanici? anlikKullanici;

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    Key? key,
  }) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController txtemail = TextEditingController();
  TextEditingController txtparola = TextEditingController();
  TextEditingController txtad = TextEditingController();
  TextEditingController txtsoyad = TextEditingController();
  TextEditingController txtdogtar = TextEditingController();
  Position? position;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade900.withAlpha(200),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textFormFieldDynamic(txtad, TextInputType.text, "Ad", ""),
              const SizedBox(
                height: 2,
              ),
              textFormFieldDynamic(txtsoyad, TextInputType.text, "Soyadı", ""),
              const SizedBox(
                height: 2,
              ),
              textFormFieldDynamic(
                  txtdogtar, TextInputType.text, "Doğum tarihi", ""),
              const SizedBox(
                height: 2,
              ),
              textFormFieldDynamic(
                  txtemail, TextInputType.emailAddress, "E-mail", ""),
              const SizedBox(
                height: 2,
              ),
              textFormFieldDynamic(
                  txtparola, TextInputType.visiblePassword, "Parola", ""),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Align(
                  alignment: Alignment.topRight,
                  child: buttonLogs(),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget textFormFieldDynamic(TextEditingController controller,
      TextInputType inputType, String labelText, String hintText) {
    return Padding(
      padding: const EdgeInsets.only(left: 35, right: 35),
      child: Theme(
        data: Theme.of(context).copyWith(backgroundColor: Colors.white),
        child: TextFormField(
          controller: controller,
          keyboardType: inputType,
          style: const TextStyle(
              color: Colors.indigo, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            labelStyle: const TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontStyle: FontStyle.italic),
            contentPadding: const EdgeInsets.fromLTRB(30.0, 15.0, 20.0, 15.0),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            )),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(
                color: Colors.white,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(
                color: Colors.white,
                width: 1.4,
              ),
            ),
          ),
        ),
      ),
    );
  }

  buttonLogs() {
    return GestureDetector(
      onTap: () async {
        position = await _getGeoLocationPosition();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LocationPage(
                    position: position,
                    txtemail: txtemail.text,
                    txtparola: txtparola.text,
                    txtad: txtad.text,
                    txtsoyad: txtsoyad.text,
                    txtdogtar: txtdogtar.text)));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: 175,
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: const Center(
                child: Padding(
                  padding:
                      EdgeInsets.only(right: 25, left: 25, top: 15, bottom: 15),
                  child: Text(
                    "Üye ol",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.yellow.shade400, width: 0.8),
                color: const Color.fromARGB(100, 22, 44, 80),
              ),
            ),
            dynamicButton("Zaten hesabım var", () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            }),
          ],
        ),
      ),
    );
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  dynamicButton(String? txt, Function()? function) {
    return TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) {
                return Colors.blue.withOpacity(0.04);
              }
              if (states.contains(MaterialState.focused) ||
                  states.contains(MaterialState.pressed)) {
                return Colors.blue.withOpacity(0.12);
              }
              return null; // Defer to the widget's default.
            },
          ),
        ),
        onPressed: function,
        child: Text(
          txt!,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ));
  }
}

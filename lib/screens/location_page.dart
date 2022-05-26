import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezka_test_project/screens/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/kullanici.dart';
import 'login_page.dart';

class LocationPage extends StatefulWidget {
  final String? txtad;
  final String? txtsoyad;
  final String? txtdogtar;
  final String? txtemail;
  final String? txtparola;
  final Position? position;
  const LocationPage(
      {Key? key,
      this.txtdogtar,
      this.txtsoyad,
      this.position,
      this.txtad,
      this.txtparola,
      this.txtemail})
      : super(key: key);

  @override
  _LocationPageState createState() => _LocationPageState(
      txtparola: txtparola,
      txtad: txtad,
      position: position,
      txtsoyad: txtsoyad,
      txtdogtar: txtdogtar,
      txtemail: txtemail);
}

class _LocationPageState extends State<LocationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Set<Polygon> _polygons = HashSet<Polygon>();
  bool isPolygon = true;
  Placemark? place;
  List<LatLng> polygonLatLng = [];
  double? radius;
  List<Marker> myMarker = [];
  GoogleMapController? mapController;
  double lati = 0;
  double longti = 0;
  String location = 'Null, Press Button';
  String? address = 'search';
  bool markerTapped = false;

  String? txtad;
  String? txtsoyad;
  String? txtdogtar;
  String? txtemail;
  String? txtparola;
  Position? position;

  _LocationPageState(
      {this.txtemail,
      this.position,
      this.txtsoyad,
      this.txtdogtar,
      this.txtad,
      this.txtparola});

  @override
  void initState() {
    setState(() {
      lati = position!.latitude;
      longti = position!.longitude;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade900.withAlpha(200),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Visibility(
            visible: markerTapped,
            child: GestureDetector(
              onTap: () async {
                debugPrint("Adress : " + address.toString());
                createPerson();
              },
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add_location, color: Colors.white, size: 35),
                  Text(
                    "Seçilen Konumu Kullan",
                    style: TextStyle(color: Colors.white, fontSize: 26),
                  ),
                ],
              )),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Visibility(
            visible: markerTapped == false,
            child: GestureDetector(
              onTap: () async {
                location = 'Lat: $lati , Long: $longti';
                getAddressFromLatLong(lati, longti);
                createPerson();
              },
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.location_on, color: Colors.white, size: 35),
                  Text(
                    "Mevcut Konumu Kullan",
                    style: TextStyle(color: Colors.white, fontSize: 26),
                  ),
                ],
              )),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
            ),
            height: 700,
            width: 425,
            child: GoogleMap(
              polygons: _polygons,
              myLocationEnabled: true,
              onTap: _handleTap,
              markers: Set.from(myMarker),
              initialCameraPosition:
                  CameraPosition(target: LatLng(lati, longti), zoom: 16.5),
            ),
          ),
        ],
      ),
    );
  }

  _handleTap(LatLng argument) {
    debugPrint(argument.toString());
    setState(() {
      myMarker = [];
      myMarker.add(
        Marker(
            onTap: () {
              setState(() {
                if (markerTapped == false) {
                  markerTapped = true;
                } else {
                  markerTapped = false;
                }
              });
            },
            markerId: MarkerId(argument.toString()),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueViolet),
            position: argument,
            draggable: true,
            onDragEnd: (dragEndPosition) {
              debugPrint(dragEndPosition.toString());
            }),
      );
      getAddressFromLatLong(argument.latitude, argument.longitude)
          .then((value) {
        debugPrint("Adress : " + address.toString());
      });
      if (isPolygon) {
        setState(() {
          polygonLatLng.add(argument);
          // setPolygon();
        });
      }
    });
  }

  Future<User?> createPerson() async {
    var user = await _auth.createUserWithEmailAndPassword(
        email: txtemail!, password: txtparola!);
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await kullaniciRef.doc(user.user!.uid).get();
    if (!documentSnapshot.exists) {
      kullaniciRef.doc(user.user!.uid).set({
        "id": user.user!.uid,
        "ad": txtad!.toUpperCase().toString(),
        "soyad": txtsoyad!.toUpperCase().toString(),
        "sehir": place!.administrativeArea!.toUpperCase().toString(),
        "email": user.user!.email,
        "dogtar": txtdogtar!,
        "konum": address,
      }).then((value) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LoginPage(userID: user.user!.uid)));
      });
      documentSnapshot = await kullaniciRef.doc(user.user!.uid).get();
    }
    anlikKullanici = Kullanici.fromDocument(documentSnapshot);

    return user.user;
  }

  Future<void> getAddressFromLatLong(double lati, double longti) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lati, longti);
    debugPrint(placemarks.toString());
    place = placemarks[0];
    setState(() {
      address = '${place!.street}' +
          " " +
          'Mah.' +
          ' ${place!.thoroughfare}' +
          ' ' +
          'No:' +
          '${place!.name}' +
          ' ${place!.subAdministrativeArea}'
              '/' +
          ' ${place!.administrativeArea}';
      debugPrint(address.toString());
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezka_test_project/screens/register_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helpers/progress.dart';

class ResponsePage extends StatefulWidget {
  final String? ad;
  final String? soyad;
  final String? sehir;
  const ResponsePage({Key? key, this.sehir, this.ad, this.soyad})
      : super(key: key);

  @override
  _ResponsePageState createState() =>
      _ResponsePageState(ad: ad, soyad: soyad, sehir: sehir);
}

class _ResponsePageState extends State<ResponsePage> {
  String? ad;
  String? soyad;
  String? sehir;
  _ResponsePageState({this.sehir, this.soyad, this.ad});

  @override
  void initState() {
    debugPrint("ad : " + ad!.toUpperCase().toString());
    debugPrint("soyad : " + soyad!.toUpperCase().toString());
    debugPrint("sehir : " + sehir!.toUpperCase().toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade900.withAlpha(200),
      body: Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Center(
                  child: Text(
                "Sonuç",
                style: TextStyle(color: Colors.white, fontSize: 23),
              )),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 5, bottom: 35),
              child: Divider(
                thickness: 1,
                height: 20,
                color: Colors.white,
              ),
            ),
            Center(
              child: buildStreamBuilder(),
            ),
          ],
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> buildStreamBuilder() {
    return StreamBuilder<QuerySnapshot>(
        stream: kullaniciRef
            .where("ad", isEqualTo: ad!.toUpperCase().toString())
            .where("soyad", isEqualTo: soyad!.toUpperCase().toString())
            .where("sehir", isEqualTo: sehir!.toUpperCase().toString())
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          } else {
            return Container(
              width: 415,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      snapshot.data!.docs.first.get("ad").toString() +
                          " " +
                          snapshot.data!.docs.first.get("soyad").toString(),
                      style: const TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10.0, left: 10),
                          child: Text(
                            "Adres : " +
                                snapshot.data!.docs.first
                                    .get("konum")
                                    .toString(),
                            style: const TextStyle(
                                color: Colors.pinkAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}

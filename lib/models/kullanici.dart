import 'package:cloud_firestore/cloud_firestore.dart';

class Kullanici {
  final String? ad;
  final String? id;
  final String? soyad;
  final String? dogtar;
  final String? email;
  final String? konum;
  final String? sehir;

  //final Timestamp? timestamp;

  Kullanici({
    this.ad,
    this.sehir,
    this.id,
    this.konum,
    this.soyad,
    this.email,
    this.dogtar, //this.timestamp,
  });

  factory Kullanici.fromDocument(DocumentSnapshot? doc) {
    return Kullanici(
      id: doc!['id'],
      sehir: doc['sehir'],
      email: doc['email'],
      ad: doc['ad'],
      soyad: doc['soyad'],
      konum: doc['konum'],
    );
  }
}

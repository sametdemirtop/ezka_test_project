import 'package:ezka_test_project/screens/response_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController txtsehir = TextEditingController();
  TextEditingController txtad = TextEditingController();
  TextEditingController txtsoyad = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade900.withAlpha(200),
      body: Center(
        child: Container(
          width: 360,
          height: 375,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textFieldDynamic(txtad, TextInputType.text, "İSİM", "İSİM"),
                  textFieldDynamic(
                      txtsoyad, TextInputType.text, "SOYİSİM", "SOYİSİM"),
                  textFieldDynamic(
                      txtsehir, TextInputType.text, "ŞEHİR", "ŞEHİR"),
                  const SizedBox(
                    height: 50,
                  ),
                  buttonLogs(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textFieldDynamic(TextEditingController controller,
      TextInputType inputType, String labelText, String hintText) {
    return Padding(
      padding: const EdgeInsets.only(left: 35, right: 35),
      child: Theme(
        data: Theme.of(context).copyWith(backgroundColor: Colors.white),
        child: TextField(
          controller: controller,
          keyboardType: inputType,
          style: const TextStyle(
              color: Colors.indigo, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            prefixIcon: circleconstructor(),
            labelText: labelText,
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            labelStyle: const TextStyle(
              color: Colors.indigo,
              fontWeight: FontWeight.w500,
              fontSize: 22,
            ),
            hintStyle: const TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.w500,
              fontSize: 22,
            ),
            contentPadding: const EdgeInsets.fromLTRB(30.0, 15.0, 20.0, 15.0),
          ),
        ),
      ),
    );
  }

  Widget circleconstructor() {
    return Padding(
      padding: EdgeInsets.all(11),
      child: Container(
        height: 1,
        width: 1,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.indigo[900]!,
          ),
          shape: BoxShape.circle,
        ),
        child: Container(),
      ),
    );
  }

  buttonLogs() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ResponsePage(
                      ad: txtad.text,
                      soyad: txtsoyad.text,
                      sehir: txtsehir.text,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: 270,
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: const Center(
                child: Padding(
                  padding:
                      EdgeInsets.only(right: 25, left: 25, top: 0, bottom: 10),
                  child: Center(
                    child: Text(
                      "ARA",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.indigo[900]!, width: 0.8),
                color: Colors.indigo[900],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

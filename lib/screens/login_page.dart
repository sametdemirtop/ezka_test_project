import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezka_test_project/screens/register_page.dart';
import 'package:ezka_test_project/screens/search_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final String? userID;
  const LoginPage({Key? key, this.userID}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState(userID: userID);
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController txtemail = TextEditingController();
  TextEditingController txtparola = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? userID;
  _LoginPageState({this.userID});

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
              textFormFieldDynamic(
                  txtemail, TextInputType.emailAddress, "E-mail", "E-mail"),
              const SizedBox(
                height: 20,
              ),
              textFormFieldDynamic(
                  txtparola, TextInputType.visiblePassword, "Parola", "Parola"),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.topRight,
                child: buttonLogs(),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<User?> signIn(String email, String password) async {
    var user = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    DocumentSnapshot<Map<String, dynamic>?>? documentSnapshot =
        await kullaniciRef.doc(user.user!.uid).get();
    if (!documentSnapshot.exists) {
      documentSnapshot = await kullaniciRef.doc(user.user!.uid).get();
    }
    return user.user;
  }

  Widget textFormFieldDynamic(TextEditingController controller,
      TextInputType inputType, String labelText, String hintText) {
    return Padding(
      padding: const EdgeInsets.only(left: 35, right: 35),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          labelStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontStyle: FontStyle.italic),
          hintStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontStyle: FontStyle.italic),
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(30.0),
          )),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(
              color: Colors.red,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1.4,
            ),
          ),
        ),
      ),
    );
  }

  Widget buttonLogs() {
    return GestureDetector(
      onTap: () {
        signIn(txtemail.text, txtparola.text);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SearchPage()));
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
                    "Giriş yap",
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
            dynamicButton("Parolamı unuttum", () {}),
          ],
        ),
      ),
    );
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

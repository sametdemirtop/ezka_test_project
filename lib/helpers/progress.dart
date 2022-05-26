import 'package:flutter/material.dart';

circularProgress<Widget>() {
  return Container(
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white,
    ),
    alignment: Alignment.center,
    padding: const EdgeInsets.only(top: 12.0),
    child: const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.white),
    ),
  );
}

Widget circleconstructor() {
  return Padding(
    padding: const EdgeInsets.all(11),
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

import 'package:dansal_app/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DansalApp());
}
class DansalApp extends StatelessWidget {
  const DansalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "inter"
      ),
      debugShowCheckedModeBanner: false,
       home: HomeScreen(),
    );
  }
}
import 'package:flutter/material.dart';
import 'login_page.dart';

void main() {
  runApp(const SusunApp());
}

class SusunApp extends StatelessWidget {
  const SusunApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Susun Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_triominos/app.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.grey.shade200,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade200,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    );
  }
}

import 'package:flutter/material.dart';

class MyPlayer {
  final String name;
  final Color color;
  int score = 0;
  bool isPlaying = false;

  MyPlayer({required this.name, required this.color});
}

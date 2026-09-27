import 'package:flutter/material.dart';

/// Central text-style factory (ported from `service/widget_support.dart`).
class AppStyles {
  static TextStyle headline() {
    return const TextStyle(
      fontSize: 25.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }

  static TextStyle simple() {
    return const TextStyle(fontSize: 20.0, color: Colors.black);
  }

  static TextStyle white() {
    return const TextStyle(
      fontSize: 20.0,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle bold() {
    return const TextStyle(
      fontSize: 25.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }

  static TextStyle price() {
    return const TextStyle(
      fontSize: 25.0,
      fontWeight: FontWeight.bold,
      color: Colors.black38,
    );
  }

  static TextStyle fieldLabel() {
    return const TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }

  static TextStyle link() {
    return const TextStyle(
      fontSize: 13.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }
}
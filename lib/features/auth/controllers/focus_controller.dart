import 'package:flutter/material.dart';

/// Focus nodes shared by the auth screens.
class SignupFocusController {
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();

  void dispose() {
    usernameFocusNode.dispose();
    passwordFocusNode.dispose();
    emailFocusNode.dispose();
  }
}
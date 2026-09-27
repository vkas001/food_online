import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

import '../../../core/theme/text_styles.dart';
import '../../../core/ui/app_button/app_button.dart';
import '../../../core/ui/app_text_field/app_text_field.dart';
import '../controllers/auth_provider.dart';
import '../controllers/focus_controller.dart';
import '../widgets/auth_scaffold.dart';

class SignupScreen extends StatefulWidget {
  final SignupFocusController controller;
  const SignupScreen({super.key, required this.controller});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isUsernameFocused = false;
  bool _isPasswordFocused = false;
  bool _isEmailFocused = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();

  bool _busy = false;

  @override
  void initState() {
    super.initState();
    widget.controller.usernameFocusNode.addListener(() {
      setState(() {
        _isUsernameFocused = widget.controller.usernameFocusNode.hasFocus;
      });
    });

    widget.controller.passwordFocusNode.addListener(() {
      setState(() {
        _isPasswordFocused = widget.controller.passwordFocusNode.hasFocus;
      });
    });

    widget.controller.emailFocusNode.addListener(() {
      setState(() {
        _isEmailFocused = widget.controller.emailFocusNode.hasFocus;
      });
    });
  }

  Future<void> registration() async {
    final name = _nameController.text.trim();
    final email = _mailController.text.trim();
    final password = _passwordController.text;

    if (name == "" && email == "") {
      return;
    }

    setState(() => _busy = true);
    try {
      final auth = context.read<AuthProvider>();
      final id = randomAlphaNumeric(10);
      await auth.signUp(name: name, email: email, password: password, userId: id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Registered Successfully",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
      );
      context.go('/home');
    } on FirebaseAuthException catch (e) {
      String message;
      Color color;
      if (e.code == 'weak-password') {
        message = "Password Provided is too Weak";
        color = Colors.orangeAccent;
      } else if (e.code == "email-already-in-use") {
        message = "Account Already Exists";
        color = Colors.orangeAccent;
      } else {
        message = "Sign up failed: ${e.message}";
        color = Colors.orangeAccent;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: color,
          content: Text(message, style: const TextStyle(fontSize: 18.0)),
        ),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _mailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      children: [
        const SizedBox(height: 10.0),
        Center(child: Text("SignUp", style: AppStyles.headline())),
        const SizedBox(height: 15.0),
        Text("Name", style: AppStyles.fieldLabel()),
        const SizedBox(height: 5.0),
        AppTextField(
          controller: _nameController,
          focusNode: widget.controller.usernameFocusNode,
          hint: _isUsernameFocused ? '' : 'Enter Username',
          prefixIcon: Icons.person_outline,
        ),
        const SizedBox(height: 15.0),
        Text("Email", style: AppStyles.fieldLabel()),
        const SizedBox(height: 5.0),
        AppTextField(
          controller: _mailController,
          focusNode: widget.controller.emailFocusNode,
          hint: _isEmailFocused ? '' : 'Enter Email',
          prefixIcon: Icons.mail_outline,
        ),
        const SizedBox(height: 15.0),
        Text("Password", style: AppStyles.fieldLabel()),
        const SizedBox(height: 5.0),
        AppTextField(
          controller: _passwordController,
          focusNode: widget.controller.passwordFocusNode,
          hint: _isPasswordFocused ? '' : 'Enter Password',
          prefixIcon: Icons.lock_outline,
          obscureText: true,
        ),
        const SizedBox(height: 20.0),
        Center(
          child: AppButton(
            label: "Sign Up",
            onTap: _busy ? null : registration,
          ),
        ),
        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 5.0,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text("Already have an account?", style: AppStyles.simple()),
              GestureDetector(
                onTap: () => context.go('/login'),
                child: Text("Log In", style: AppStyles.link()),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
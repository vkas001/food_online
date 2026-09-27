import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/text_styles.dart';
import '../../../core/ui/app_button/app_button.dart';
import '../../../core/ui/app_text_field/app_text_field.dart';
import '../controllers/auth_provider.dart';
import '../controllers/focus_controller.dart';
import '../widgets/auth_scaffold.dart';

class LoginScreen extends StatefulWidget {
  final SignupFocusController controller;
  const LoginScreen({super.key, required this.controller});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordFocused = false;
  bool _isEmailFocused = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _busy = false;

  @override
  void initState() {
    super.initState();
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

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage("Enter email and password", Colors.orangeAccent);
      return;
    }

    setState(() => _busy = true);
    try {
      await context.read<AuthProvider>().signIn(email: email, password: password);
      if (mounted) context.go('/home');
    } on FirebaseAuthException catch (e) {
      _showMessage(e.code == 'invalid-credential'
          ? "Invalid email or password"
          : "Login failed: ${e.message}", Colors.orangeAccent);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(message, style: const TextStyle(fontSize: 18.0)),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      children: [
        const SizedBox(height: 10.0),
        Center(child: Text("Log In", style: AppStyles.headline())),
        const SizedBox(height: 15.0),
        Text("Email", style: AppStyles.fieldLabel()),
        const SizedBox(height: 5.0),
        AppTextField(
          controller: _emailController,
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
        const SizedBox(height: 5.0),
        Align(
          alignment: Alignment.centerRight,
          child: Text("Forgot Password?", style: AppStyles.simple()),
        ),
        const SizedBox(height: 20.0),
        Center(child: AppButton(label: "Log In", onTap: _busy ? null : _login)),
        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 5.0,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text("Don't have an account?", style: AppStyles.simple()),
              GestureDetector(
                onTap: () => context.go('/signup'),
                child: Text("Sign Up", style: AppStyles.link()),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
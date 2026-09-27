import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/router.dart';
import 'features/auth/controllers/auth_provider.dart';
import 'features/auth/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyCFSsj0uU6bEfY-iRHXZd8YaoNAwC4i_-w",
        appId: "1:143689696683:web:4ae09c13ba3d024c04beee",
        messagingSenderId: "143689696683",
        projectId: "foodonline-b71a9",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  final authProvider = AuthProvider(authService: AuthService());
  runApp(FoodOnlineApp(
    authProvider: authProvider,
    router: createRouter(authProvider),
  ));
}
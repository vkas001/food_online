import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../features/auth/controllers/auth_provider.dart';
import '../features/orders/controllers/cart_provider.dart';
import '../features/orders/controllers/orders_provider.dart';
import '../features/wallet/controllers/wallet_provider.dart';
import '../core/ui/responsive_text_scale/responsive_text_scale.dart';

class FoodOnlineApp extends StatelessWidget {
  final AuthProvider authProvider;
  final GoRouter router;

  const FoodOnlineApp({
    super.key,
    required this.authProvider,
    required this.router,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => authProvider,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<CartProvider>(
            create: (_) => CartProvider(),
          ),
          ChangeNotifierProvider<OrdersProvider>(
            create: (_) => OrdersProvider(),
          ),
          ChangeNotifierProvider<WalletProvider>(
            create: (_) => WalletProvider(),
          ),
        ],
        child: MaterialApp.router(
          title: "Restaurant App",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            primarySwatch: Colors.red,
          ),
          builder: (context, child) => MediaQuery.withClampedTextScaling(
            maxScaleFactor: 1.3,
            child: ResponsiveTextScale(child: child!),
          ),
          routerConfig: router,
        ),
      ),
    );
  }
}
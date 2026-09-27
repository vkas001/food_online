import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/ui/app_loading/app_loading.dart';
import '../features/auth/auth.dart';
import '../features/item/item.dart';
import '../features/menu/menu.dart';
import '../features/onboarding/onboarding.dart';
import '../features/orders/orders.dart';
import '../features/profile/profile.dart';
import '../features/shell/shell.dart';
import '../features/wallet/wallet.dart';

const _publicRoutes = ['/onboarding', '/login', '/signup', '/register'];

/// Builds the app navigator, gated by [auth].
///
/// Mirrors the iBIZ `Stack.Protected`/`initialRouteName```auth``` arrangement:
///  - restoring session  -> splash
///  - not logged in      -> onboarding on first run, then login/signup
///  - logged in          -> 4-tab shell
GoRouter createRouter(AuthProvider auth) {
  final focusController = SignupFocusController();

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final location = state.matchedLocation;

      if (auth.restoring) {
        return location == '/splash' ? null : '/splash';
      }

      final loggedIn = auth.isLoggedIn;
      final onboarded = auth.onboarded;

      if (loggedIn) {
        if (_publicRoutes.contains(location) || location == '/splash') {
          return '/home';
        }
        return null;
      }

      if (!onboarded) {
        return location == '/onboarding' ? null : '/onboarding';
      }

      return _publicRoutes.contains(location) ? null : '/login';
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const _SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) =>
            LoginScreen(controller: focusController),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) =>
            SignupScreen(controller: focusController),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) =>
            SignupScreen(controller: focusController),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            ShellScreen(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/orders',
                builder: (context, state) => const OrdersScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/wallet',
                builder: (context, state) => const WalletScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/item/:id',
        builder: (context, state) =>
            ItemDetailScreen(itemId: state.pathParameters['id']!),
      ),
    ],
  );
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: AppLoading());
  }
}
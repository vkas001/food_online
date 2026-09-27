import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_online/core/theme/breakpoints.dart';
import 'package:food_online/core/ui/responsive_text_scale/responsive_text_scale.dart';
import 'package:food_online/features/auth/controllers/focus_controller.dart';
import 'package:food_online/features/auth/screens/login_screen.dart';
import 'package:food_online/features/auth/screens/signup_screen.dart';
import 'package:food_online/features/item/screens/item_detail_screen.dart';
import 'package:food_online/features/menu/menu.dart';
import 'package:food_online/features/onboarding/screens/onboarding_screen.dart';
import 'package:food_online/features/orders/orders.dart';
import 'package:food_online/features/wallet/wallet.dart';
import 'package:provider/provider.dart';

const _widths = [320.0, 430.0, 768.0, 1280.0];
const _portraitHeight = 800.0;

/// MaterialApp with the same responsive text scaling used by the real app.
Widget _app(Widget home) => MaterialApp(
      home: home,
      builder: (context, child) => MediaQuery.withClampedTextScaling(
        maxScaleFactor: 1.3,
        child: ResponsiveTextScale(child: child!),
      ),
    );

Future<void> _pump(WidgetTester tester, double width, double height, Widget widget) async {
  tester.view.physicalSize = Size(width, height);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(widget);
  await tester.pump();
}

void main() {
  group('breakpoints', () {
    test('tier boundaries', () {
      expect(breakpointForWidth(479), AppBreakpoint.small);
      expect(breakpointForWidth(480), AppBreakpoint.medium);
      expect(breakpointForWidth(767), AppBreakpoint.medium);
      expect(breakpointForWidth(768), AppBreakpoint.large);
    });

    test('design text scale is lower on small screens', () {
      expect(textScaleForWidth(479), lessThan(textScaleForWidth(480)));
      expect(textScaleForWidth(479), 0.85);
      expect(textScaleForWidth(480), 1.0);
      expect(textScaleForWidth(900), greaterThan(1.0));
    });
  });

  group('size sweep (no overflow)', () {
    testWidgets('home screen', (tester) async {
      for (final width in _widths) {
        await _pump(tester, width, _portraitHeight, _app(const HomeScreen()));
        expect(tester.takeException(), isNull, reason: 'overflow at ${width.toInt()}w');
        expect(find.textContaining('Order your favourite food!'), findsOneWidget);
      }
    });

    testWidgets('login screen', (tester) async {
      for (final width in _widths) {
        await _pump(
          tester,
          width,
          _portraitHeight,
          _app(LoginScreen(controller: SignupFocusController())),
        );
        expect(tester.takeException(), isNull, reason: 'overflow at ${width.toInt()}w');
      }
    });

    testWidgets('signup screen', (tester) async {
      for (final width in _widths) {
        await _pump(
          tester,
          width,
          _portraitHeight,
          _app(SignupScreen(controller: SignupFocusController())),
        );
        expect(tester.takeException(), isNull, reason: 'overflow at ${width.toInt()}w');
      }
    });

    testWidgets('onboarding screen', (tester) async {
      for (final width in _widths) {
        await _pump(tester, width, _portraitHeight, _app(const OnboardingScreen()));
        expect(tester.takeException(), isNull, reason: 'overflow at ${width.toInt()}w');
      }
    });

    testWidgets('item detail screen', (tester) async {
      for (final width in _widths) {
        final itemId = allItems.first.id;
        await _pump(
          tester,
          width,
          _portraitHeight,
          _app(ItemDetailScreen(itemId: itemId)),
        );
        expect(tester.takeException(), isNull, reason: 'overflow at ${width.toInt()}w');
      }
    });

    testWidgets('orders screen', (tester) async {
      for (final width in _widths) {
        await _pump(
          tester,
          width,
          _portraitHeight,
          ChangeNotifierProvider(
            create: (_) => OrdersProvider(),
            child: _app(const OrdersScreen()),
          ),
        );
        expect(tester.takeException(), isNull, reason: 'overflow at ${width.toInt()}w');
      }
    });

    testWidgets('wallet screen', (tester) async {
      for (final width in _widths) {
        await _pump(
          tester,
          width,
          _portraitHeight,
          ChangeNotifierProvider(
            create: (_) => WalletProvider(),
            child: _app(const WalletScreen()),
          ),
        );
        expect(tester.takeException(), isNull, reason: 'overflow at ${width.toInt()}w');
        expect(find.textContaining('Balance'), findsOneWidget);
      }
    });
  });

  group('short viewport safety (scrollable, no overflow)', () {
    const shortWidth = 480.0;
    const shortHeight = 420.0;

    testWidgets('onboarding', (tester) async {
      await _pump(tester, shortWidth, shortHeight, _app(const OnboardingScreen()));
      expect(tester.takeException(), isNull);
    });

    testWidgets('login', (tester) async {
      await _pump(
        tester,
        shortWidth,
        shortHeight,
        _app(LoginScreen(controller: SignupFocusController())),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('signup', (tester) async {
      await _pump(
        tester,
        shortWidth,
        shortHeight,
        _app(SignupScreen(controller: SignupFocusController())),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('item detail', (tester) async {
      await _pump(
        tester,
        shortWidth,
        shortHeight,
        _app(ItemDetailScreen(itemId: allItems.first.id)),
      );
      expect(tester.takeException(), isNull);
    });
  });
}
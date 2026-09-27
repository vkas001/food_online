import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_online/features/menu/menu.dart';
import 'package:food_online/features/orders/orders.dart';
import 'package:food_online/features/wallet/wallet.dart';

void main() {
  group('catalog data', () {
    test('items have stable unique ids', () {
      final ids = allItems.map((i) => i.id).toList();
      expect(ids.toSet().length, ids.length);
      expect(allItems, isNotEmpty);
    });

    test('findItem round-trips', () {
      final item = allItems.first;
      expect(findItem(item.id)?.name, item.name);
      expect(findItem('nope'), isNull);
    });

    test('non-pizza categories fall back to pizza list', () {
      final items = itemsForCategory('2');
      expect(items, isNotEmpty);
      expect(items.first.id, startsWith('pizza-'));
    });
  });

  group('cart', () {
    test('merges same-name lines and computes total', () {
      final cart = CartProvider();
      cart.addItem(CartLine(name: 'Pizza', image: 'a', unitPrice: 200, quantity: 1));
      cart.addItem(CartLine(name: 'Pizza', image: 'a', unitPrice: 200, quantity: 2));
      cart.addItem(CartLine(name: 'Momo', image: 'b', unitPrice: 100, quantity: 1));

      expect(cart.lines.length, 2);
      expect(cart.total, 700);
    });
  });

  group('orders', () {
    test('placeOrder adds pending order at front', () {
      final orders = OrdersProvider();
      final before = orders.orders.length;

      orders.placeOrder(CartLine(name: 'Burger', image: 'c', unitPrice: 300));

      expect(orders.orders.length, before + 1);
      expect(orders.orders.first.name, 'Burger');
      expect(orders.orders.first.synced, isFalse);
    });

    test('markSynced flips flag', () {
      final orders = OrdersProvider();
      orders.placeOrder(CartLine(name: 'Burger', image: 'c', unitPrice: 300));
      final id = orders.orders.first.id;

      orders.markSynced(id);
      expect(orders.orders.first.synced, isTrue);
    });
  });

  group('wallet', () {
    test('spend deducts balance and refuses overdraw', () {
      final wallet = WalletProvider(initialBalance: 300);

      expect(wallet.spend(100), isTrue);
      expect(wallet.balance, 200);

      expect(wallet.spend(500), isFalse);
      expect(wallet.balance, 200);
    });
  });

  group('home screen', () {
    testWidgets('boots and shows header', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      expect(find.textContaining('Order your favourite food!'), findsOneWidget);
    });
  });
}
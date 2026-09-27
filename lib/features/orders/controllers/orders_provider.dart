import 'package:flutter/foundation.dart';

import '../models/order.dart';

/// Order history. Mirrors the iBIZ `orders` table/screen: a list of
/// [Order]s with a pending `synced` flag that would be flushed by a sync
/// service.
class OrdersProvider extends ChangeNotifier {
  OrdersProvider() {
    _seed();
  }

  final List<Order> _orders = [];
  int _nextId = 0;

  List<Order> get orders => List.unmodifiable(_orders);

  void _seed() {
    final now = DateTime.now();
    _orders.addAll([
      Order(
        id: 'seed-1',
        name: 'Cheese Pizza',
        image: 'images/pizza/cheesepizza.jpeg',
        total: 400,
        synced: true,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      Order(
        id: 'seed-2',
        name: 'Steam Momo',
        image: 'images/momo/steammomo.jpeg',
        total: 600,
        synced: true,
        createdAt: now.subtract(const Duration(days: 5)),
      ),
    ]);
    _nextId = 3;
  }

  void placeOrder(CartLine line) {
    _orders.insert(0, Order(
      id: 'order-${_nextId++}',
      name: line.name,
      image: line.image,
      total: line.total,
      synced: false,
      createdAt: DateTime.now(),
    ));
    notifyListeners();
  }

  void markSynced(String id) {
    final index = _orders.indexWhere((o) => o.id == id);
    if (index < 0) return;
    final updated = _orders[index];
    _orders[index] = Order(
      id: updated.id,
      name: updated.name,
      image: updated.image,
      total: updated.total,
      synced: true,
      createdAt: updated.createdAt,
    );
    notifyListeners();
  }

  void clearSynced() {
    _orders.removeWhere((o) => o.synced);
    notifyListeners();
  }
}
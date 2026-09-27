import 'package:flutter/foundation.dart';

import '../models/order.dart';

/// Holds the in-progress cart. Currently a single checkout line is placed per
/// order from the item detail screen; kept as a list so multi-line carts are
/// straightforward to add later.
class CartProvider extends ChangeNotifier {
  final List<CartLine> _lines = [];

  List<CartLine> get lines => List.unmodifiable(_lines);
  bool get isEmpty => _lines.isEmpty;

  int get total =>
      _lines.fold(0, (sum, line) => sum + line.total);

  void addItem(CartLine line) {
    final existingIndex = _lines.indexWhere((l) => l.name == line.name);
    if (existingIndex >= 0) {
      _lines[existingIndex] = _lines[existingIndex].copyWith(
        quantity: _lines[existingIndex].quantity + line.quantity,
      );
    } else {
      _lines.add(line);
    }
    notifyListeners();
  }

  void clear() {
    _lines.clear();
    notifyListeners();
  }
}
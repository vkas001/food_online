import 'package:flutter/foundation.dart';

/// A single wallet transaction.
class WalletTransaction {
  final String title;
  final int amount; // positive = credit, negative = debit
  final DateTime at;

  const WalletTransaction({
    required this.title,
    required this.amount,
    required this.at,
  });

  bool get isCredit => amount >= 0;
}

/// Points balance. Mirrors the iBIZ wallet: a balance with a transaction
/// history. Deducted when an order is placed via [spend].
class WalletProvider extends ChangeNotifier {
  WalletProvider({int initialBalance = 5000}) : _balance = initialBalance {
    _transactions = [
      WalletTransaction(
        title: 'Welcome bonus',
        amount: 5000,
        at: DateTime.now().subtract(const Duration(days: 7)),
      ),
    ];
  }

  int _balance = 0;
  late List<WalletTransaction> _transactions;

  int get balance => _balance;
  List<WalletTransaction> get transactions => List.unmodifiable(_transactions);

  bool spend(int amount) {
    if (amount > _balance) return false;
    _balance -= amount;
    _transactions.add(WalletTransaction(
      title: 'Order payment',
      amount: -amount,
      at: DateTime.now(),
    ));
    notifyListeners();
    return true;
  }
}
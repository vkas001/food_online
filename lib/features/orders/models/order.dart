/// A single line in the cart.
class CartLine {
  final String name;
  final String image;
  final int unitPrice;
  int quantity;

  CartLine({
    required this.name,
    required this.image,
    required this.unitPrice,
    this.quantity = 1,
  });

  int get total => unitPrice * quantity;

  CartLine copyWith({int? quantity}) => CartLine(
        name: name,
        image: image,
        unitPrice: unitPrice,
        quantity: quantity ?? this.quantity,
      );
}

/// A placed order. [synced] mirrors the iBIZ offline-first `synced` seam —
/// orders are marked unsynced until pushed to the backend.
class Order {
  final String id;
  final String name;
  final String image;
  final int total;
  final bool synced;
  final DateTime createdAt;

  const Order({
    required this.id,
    required this.name,
    required this.image,
    required this.total,
    required this.synced,
    required this.createdAt,
  });
}
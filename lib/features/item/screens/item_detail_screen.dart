import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/breakpoints.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/ui/app_loading/app_loading.dart';
import '../../../core/ui/responsive_container/responsive_container.dart';
import '../../menu/models/menu_item.dart';
import '../../menu/services/catalog_data.dart';
import '../../orders/controllers/cart_provider.dart';
import '../../orders/controllers/orders_provider.dart';
import '../../orders/models/order.dart';
import '../../wallet/controllers/wallet_provider.dart';

class ItemDetailScreen extends StatefulWidget {
  final String itemId;

  const ItemDetailScreen({super.key, required this.itemId});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  int _quantity = 1;

  MenuItem? get _item => findItem(widget.itemId);

  int get _totalPrice => (_item?.priceValue ?? 0) * _quantity;

  Future<void> _placeOrder() async {
    final item = _item;
    if (item == null) return;

    final cart = context.read<CartProvider>();
    final orders = context.read<OrdersProvider>();
    final wallet = context.read<WalletProvider>();

    cart.addItem(CartLine(
      name: item.name,
      image: item.image,
      unitPrice: item.priceValue,
      quantity: _quantity,
    ));
    final line = cart.lines.lastWhere((l) => l.name == item.name);
    orders.placeOrder(line);
    wallet.spend(line.total);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.primary,
        content: Text(
          "Order Now",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
    cart.clear();
    context.go('/orders');
  }

  @override
  Widget build(BuildContext context) {
    final item = _item;

    if (item == null) {
      return const Scaffold(body: AppLoading());
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: ResponsiveContainer(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final gutter = context.pageGutter;
              final imageSize =
                  (constraints.maxWidth * 0.6).clamp(0.0, 360.0);

              return Container(
                margin: EdgeInsets.only(
                  top: 20.0,
                  left: gutter,
                  right: gutter,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 30.0,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Center(
                      child: Image.asset(
                        item.image,
                        height: imageSize,
                        width: imageSize,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      children: [
                        Expanded(
                          child: Text(item.name, style: AppStyles.bold()),
                        ),
                        _QuantityStepper(
                          quantity: _quantity,
                          onChanged: (value) => setState(() => _quantity = value),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Text(item.price, style: AppStyles.price()),
                    const SizedBox(height: 20.0),
                    Text(
                      item.description,
                      style: AppStyles.simple(),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 24.0),
                    Wrap(
                      alignment: WrapAlignment.end,
                      spacing: 10.0,
                      runSpacing: 12.0,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Total Price", style: AppStyles.simple()),
                            Text("RS $_totalPrice", style: AppStyles.bold()),
                          ],
                        ),
                        GestureDetector(
                          onTap: _placeOrder,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 15.0,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: const Text(
                              "ORDER NOW",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;

  const _QuantityStepper({required this.quantity, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StepButton(
          icon: Icons.remove,
          onTap: () => onChanged(quantity > 1 ? quantity - 1 : 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text("$quantity", style: AppStyles.bold()),
        ),
        _StepButton(icon: Icons.add, onTap: () => onChanged(quantity + 1)),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          color: AppColors.fieldFill,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20.0, color: Colors.black87),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/ui/responsive_container/responsive_container.dart';
import '../controllers/orders_provider.dart';
import '../models/order.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrdersProvider>().orders;

    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders", style: AppStyles.bold()),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ResponsiveContainer(
        child: orders.isEmpty
            ? Center(child: Text("No orders yet", style: AppStyles.simple()))
            : ListView.separated(
                padding: const EdgeInsets.all(16.0),
                itemCount: orders.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12.0),
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return _OrderCard(order: order);
                },
              ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.asset(
              order.image,
              height: 72,
              width: 72,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.name, style: AppStyles.bold()),
                const SizedBox(height: 4.0),
                Text("RS ${order.total}", style: AppStyles.price()),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: order.synced ? AppColors.primary : Colors.orangeAccent,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Text(
              order.synced ? "Delivered" : "Pending",
              style: const TextStyle(color: Colors.white, fontSize: 13.0),
            ),
          ),
        ],
      ),
    );
  }
}
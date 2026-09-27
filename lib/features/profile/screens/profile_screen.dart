import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/ui/app_button/app_button.dart';
import '../../../core/ui/responsive_container/responsive_container.dart';
import '../../auth/controllers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await context.read<AuthProvider>().signOut();
    if (context.mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final name = auth.displayName ?? 'Food Lover';
    final email = auth.displayEmail ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: AppStyles.bold()),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: ResponsiveContainer(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 20.0),
                ClipRRect(
                  borderRadius: BorderRadius.circular(60.0),
                  child: Image.asset(
                    "images/user.jpg",
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(name, style: AppStyles.headline(), textAlign: TextAlign.center),
                if (email.isNotEmpty) ...[
                  const SizedBox(height: 4.0),
                  Text(
                    email,
                    style: AppStyles.simple(),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 32.0),
                AppButton(
                  label: "Log Out",
                  color: AppColors.brown,
                  onTap: () => _logout(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/ui/app_button/app_button.dart';
import '../../../core/ui/responsive_container/responsive_container.dart';
import '../../auth/controllers/auth_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  Future<void> _getStarted() async {
    await context.read<AuthProvider>().completeOnboarding();
    if (mounted) context.go('/signup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: ResponsiveContainer(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final imageSize =
                  (constraints.maxWidth * 0.6).clamp(0.0, 280.0);

              return Container(
                margin: const EdgeInsets.only(top: 40.0),
                child: Column(
                  children: [
                    Image.asset(
                      "images/fast-delivery.png",
                      height: imageSize,
                      width: imageSize,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      "The Fastest\nFood Delivery",
                      textAlign: TextAlign.center,
                      style: AppStyles.headline(),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      "Craving something delicious?\n Order now and get your favourites\n delivered fast!",
                      textAlign: TextAlign.center,
                      style: AppStyles.simple(),
                    ),
                    const SizedBox(height: 24.0),
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 220),
                        child: SizedBox(
                          width: double.infinity,
                          child: AppButton(
                            label: "Get Started",
                            color: AppColors.brown,
                            onTap: _getStarted,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
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
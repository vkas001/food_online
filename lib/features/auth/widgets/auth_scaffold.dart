import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/ui/responsive_container/responsive_container.dart';

/// Shared auth screen frame: warm hero image on cream background plus a
/// raised white card holding the form content.
///
/// Width-relative (not height-ratio) and scroll-safe, so it holds up in
/// landscape and on tablets.
class AuthScaffold extends StatelessWidget {
  final List<Widget> children;

  const AuthScaffold({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ResponsiveContainer(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final imageWidth = (width * 0.6).clamp(0.0, 340.0);

              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 24.0),
                    decoration: const BoxDecoration(
                      color: AppColors.cream,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          "images/signup.png",
                          width: imageWidth,
                          height: imageWidth * 0.8,
                          fit: BoxFit.contain,
                        ),
                        Container(
                          color: AppColors.cream,
                          child: const Text(
                            "YOUR NEW GO TO RESTURANT",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 36),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Transform.translate(
                      offset: const Offset(0, -24),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 460),
                          child: Material(
                            elevation: 3.0,
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: children,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
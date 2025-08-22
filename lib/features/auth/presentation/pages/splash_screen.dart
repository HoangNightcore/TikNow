import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tix_now/features/auth/presentation/pages/login_page.dart';
import 'package:tix_now/features/auth/presentation/widgets/gradient_background.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy chiều rộng của màn hình
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 1),

                // App Logo/Title
                SvgPicture.asset(
                  'assets/images/logo.svg',
                  width: screenWidth * 0.7, // Đặt chiều rộng bằng 70% màn hình
                  height: null, // Chiều cao sẽ được tính tự động để giữ tỷ lệ
                  fit: BoxFit.contain,
                ),

                // const SizedBox(height: 40),
                const Spacer(flex: 2),

                // Press to continue button
                GestureDetector(
                  onTap: () {
                    // Add navigation logic here
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Container(
                    width: screenWidth * 0.8, // 80% chiều rộng màn hình
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white.withOpacity(0.1),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Press to continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),

                // const Spacer(flex: 1),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

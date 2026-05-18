import 'package:flutter/material.dart';
import 'camera_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // خلفية داكنة
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // 🔥 اللوجو
            Image.asset(
              'assets/images/logo.jpg',
              width: 200,
            ),

            SizedBox(height: 30),

            // 📝 عنوان
            Text(
              "مترجم لغة الإشارة",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 50),

            // 🚀 زر ابدأ
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/camera');
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text(
                "ابدأ",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
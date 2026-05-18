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
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                'assets/images/logo.jpg',
                width: 200,
              ),
            ),

            SizedBox(height: 20),

            // 🧑‍💻 الراعي
            Text(
              "الراعي للبرنامج",
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
            Text(
              "رغد الشمري",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 40),

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

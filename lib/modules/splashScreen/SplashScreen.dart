import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../startScreen/StartScreen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FadeIn(
                duration: Duration(seconds: 1),

                child: Hero(
                  tag: "logo",
                  child: Center(child: Image.asset("assets/logos/Evently.png")),
                ),
              ),
            ),
            FadeInDown(
              delay: Duration(seconds: 2),
              onFinish: (direction) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return StartScreen();
                    },
                  ),
                );
              },
              child: Center(
                child: Image.asset(
                  "assets/logos/lightRouteLogo.png",
                  width: 214,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

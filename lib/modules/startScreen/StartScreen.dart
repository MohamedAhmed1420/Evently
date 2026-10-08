import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Hero(
                tag: "logo",
                child: Center(
                  child: Image.asset("assets/logos/Evently.png", width: 140),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

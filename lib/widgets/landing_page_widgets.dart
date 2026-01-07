import 'package:flutter/material.dart';
import 'package:quran_app/pages/home_page.dart';

class GetStartedButton extends StatelessWidget {
  const GetStartedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD4AF37),
            foregroundColor: const Color(0xFF1A0F1C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            shadowColor: const Color(0xFFD946A1).withValues(alpha: 0.4),
          ),
          child: Text(
            'Get Started',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class QuranAppLogo extends StatelessWidget {
  const QuranAppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD946A1).withValues(alpha: 0.3),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Image.asset(
        'assets/images/quran-icon.webp',
        height: 180,
        width: 180,
        fit: BoxFit.contain,
      ),
    );
  }
}

class SubTitleQuranApp extends StatelessWidget {
  const SubTitleQuranApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Text(
        'Learn Quran everyday & recite once everyday',
        style: TextStyle(
          fontSize: 16,
          color: Colors.white.withOpacity(0.7),
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class TitleQuranApp extends StatelessWidget {
  const TitleQuranApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Quran App',
      style: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: const Color(0xFFD4AF37),
      ),
      textAlign: TextAlign.center,
    );
  }
}

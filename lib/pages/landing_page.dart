import 'package:flutter/material.dart';
import 'package:quran_app/widgets/landing_page_widgets.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A0F1C), Color(0xFF3D2045)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),
              const TitleQuranApp(),
              const SizedBox(height: 12),
              const SubTitleQuranApp(),
              const SizedBox(height: 40),
              const QuranAppLogo(),
              const Spacer(flex: 3),
              const GetStartedButton(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

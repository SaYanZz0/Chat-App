import 'package:flutter/material.dart';
import 'package:flutter_newapp/core/app_theme.dart';
import 'package:flutter_newapp/src/presentation/screen/onBoarding/onboarding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme(context),
      darkTheme: darkTheme(context),
      home: const OnBoardingScreen(),
    );
  }
}

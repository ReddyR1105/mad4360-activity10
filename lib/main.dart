import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/signup_page.dart';

void main() => runApp(const SignupApp());

class SignupApp extends StatelessWidget {
  const SignupApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Signup Quest',
    debugShowCheckedModeBanner: false,
    theme: appTheme(),
    home: const SignupPage(),
  );
}

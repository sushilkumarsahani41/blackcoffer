import 'package:blackcoffer/screens/home.dart';
import 'package:blackcoffer/screens/login.dart';
import 'package:blackcoffer/screens/splash.dart';
import 'package:blackcoffer/screens/verfiyotp.dart';
import 'package:flutter/material.dart';

var myRoutes = <String, WidgetBuilder>{
  '/': (context) => const SplashScreen(),
  '/home': (context) => const HomePage(),
  '/login': (context) => const LoginPage(),
  '/verifyotp': (context) => const VerifyOTP(),
};

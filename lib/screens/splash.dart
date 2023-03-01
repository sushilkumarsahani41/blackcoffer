import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: non_constant_identifier_names

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static String uid = '';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String route = "";

  @override
  void initState() {
    super.initState();
    getUseData().whenComplete(() async {
      Timer(
          const Duration(seconds: 3),
          // ignore: unnecessary_null_comparison
          () => Navigator.pushNamed(context, route));
    });
  }

  Future getUseData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtainUid = sharedPreferences.getString("uid");
    setState(() {
      if (obtainUid != null) {
        SplashScreen.uid = obtainUid;
        route = "/home";
      } else {
        route = "/login";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Black Coffer",
              style: GoogleFonts.openSans(
                  fontSize: 34, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Intership Assesment Application",
              style:
                  GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 30,
            ),
            const CircularProgressIndicator(
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}

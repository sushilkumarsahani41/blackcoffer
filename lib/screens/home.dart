import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SizedBox(
        width: 200,
        height: 45,
        child: ElevatedButton(
          onPressed: () async {
            final SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
            sharedPreferences.remove('uid');
            await FirebaseAuth.instance.signOut();
            // ignore: use_build_context_synchronously
            Navigator.pushNamed(context, '/login');
          },
          child: const Text("Logout"),
        ),
      )),
    );
  }
}

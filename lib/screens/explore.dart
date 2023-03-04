import 'package:blackcoffer/services/location.dart';
import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String userLocation = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // backgroundColor: Colors.,
          ),
      body: Center(
        child: Column(
          children: [
            Text(
              userLocation,
            ),
            ElevatedButton(
              onPressed: () async {
                // ignore: non_constant_identifier_names
                String Location = await getUserLocation();
                setState(() {
                  userLocation = Location;
                });
              },
              child: const Text("Get Location"),
            ),
          ],
        ),
      ),
    );
  }
}

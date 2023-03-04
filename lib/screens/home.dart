import 'package:blackcoffer/screens/explore.dart';
import 'package:blackcoffer/screens/profile.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: const TabBarView(
          children: [
            // ignore: avoid_unnecessary_containers
            ExplorePage(),
            // ignore: avoid_unnecessary_containers
            ProfilePage(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/camera');
                          },
                          icon: const Icon(
                            Icons.camera_alt,
                            semanticLabel: 'Camera',
                            size: 35,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.photo_album,
                            semanticLabel: 'Gallery',
                            size: 35,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  );
                });
          },
          backgroundColor: Colors.purple,
          child: const Icon(Icons.video_call),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          color: Colors.grey[200],
          // ignore: avoid_unnecessary_containers
          child: Container(
            child: const TabBar(
              splashBorderRadius: BorderRadius.all(Radius.circular(10)),
              padding: EdgeInsets.all(5),
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.white,
              dividerColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 2,
              indicator: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              tabs: [
                Tab(
                  icon: Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.search_rounded,
                      weight: 800,
                    ),
                  ),
                ),
                Tab(
                  icon: Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.person,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:music_player/controller/page_manager.dart';
import 'package:music_player/screens/home_screen.dart';
import 'package:music_player/screens/music_player_screen.dart';
import 'package:music_player/services/audio_services.dart';

void main() async {
  await setUpInitService();
  runApp(MyApp());
}

//https://music-fa.com/wp-content/uploads/2023/04/Erfan-Tahmasbi-Del-Az-Man.mp4

class MyApp extends StatelessWidget {
  MyApp({super.key});


  //PageManager get _pageManager => PageManager();
  final _pageManager = getIt<PageManager>();

  PageController pageController = PageController(initialPage: 0);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Ubuntu'),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: PageView(
          controller: pageController,
          scrollDirection: Axis.vertical,
          children: [
            HomeScreen(
              pageManager: _pageManager,
              pageController: pageController,
            ),
            WillPopScope(
              onWillPop: () async {
                pageController.animateToPage(0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.bounceOut);
                return false;
              },
              child: MusicPlayerScreen(
                  pageManager: _pageManager, pageController: pageController),
            ),
          ],
        ),
      ),
    );
  }
}

/*
*  Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: LinearGradient(
                              colors: [Colors.red[800]!.withOpacity(0.1),Colors.red],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight
                            )
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.pause,
                              color: Colors.white,
                              size: 90,
                            ),
                          ),
                        ),*/

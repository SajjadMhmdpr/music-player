import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../controller/page_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.pageManager, required this.pageController});

  final PageManager pageManager;
  final PageController pageController;


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            height: 60,
            decoration: BoxDecoration(color: Colors.grey[500]),
            child: const Center(
              child: Text(
                'Play List',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: widget.pageManager.playListNotifier,
              builder: (context, List<MediaItem> value, child) {
                if(value.isEmpty) {
                  return Container();
                } else{
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(color: Colors.grey[200]),
                        child: ListTile(
                          onTap: (){
                            widget.pageManager.playFromPlayList(index);
                            widget.pageController.animateToPage(1,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.bounceInOut);
                          },
                          leading: CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.black,
                            child: CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(value[index].artUri.toString()),
                            ),
                          ),
                          title: Text(
                            value[index].title,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            value[index].artist!,
                            style:
                            const TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ),
                      );
                    },
                  );
                }

              },
            ),
          ),
          GestureDetector(
            onTap: (){
              widget.pageController.animateToPage(
                  1,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.bounceOut);
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(color: Colors.grey[300]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ValueListenableBuilder(
                    valueListenable: widget.pageManager.currentSongDetailNotifier,
                    builder: (context, value, child) {
                      if(value.artist!=null){
                        //print(value.artUri);
                        return Row(
                          children: [
                            CircleAvatar(
                              backgroundImage:NetworkImage( value.artUri.toString()),
                              radius: 35,
                            ),
                            const SizedBox(width: 25,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  value.artist!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.black),
                                ),
                                Text(
                                  value.title,
                                  style:
                                  const TextStyle(fontSize: 20, color: Colors.black),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                      else{
                        return Container();
                      }

                    },
                  ),
                  ValueListenableBuilder<ButtonState>(
                    valueListenable: widget.pageManager.buttonNotifier,
                    builder: (context, value, _) {
                      switch (value) {
                        case ButtonState.loading:
                          return const SizedBox(
                            height: 5,
                            width: 5,
                            child: CircularProgressIndicator(
                              valueColor:
                              AlwaysStoppedAnimation(Colors.white),
                            ),
                          );
                        case ButtonState.playing:
                          return IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              widget.pageManager.pause();
                            },
                            icon: const Icon(
                              Icons.pause_circle_outline_rounded,
                              color: Colors.black,
                              size: 50,
                            ),
                          );
                        case ButtonState.paused:
                          return IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              widget.pageManager.play();
                            },
                            icon: const Icon(
                              Icons.play_circle_outline_rounded,
                              color: Colors.black,
                              size: 50,
                            ),
                          );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*return ListView.builder(
          itemCount: value.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                value[index].title,
                style: TextStyle(color: Colors.black),
              ),
              subtitle: Text(value[index].artist,
                style: TextStyle(color: Colors.black),
              ),
            );
          },
        );*/

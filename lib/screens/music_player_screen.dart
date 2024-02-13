import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/controller/page_manager.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key, required this.pageManager, required this.pageController});
  final PageManager pageManager;
  final PageController pageController;

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreen();
}

class _MusicPlayerScreen extends State<MusicPlayerScreen> {
  late Size size;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Stack(
      children: [
        SizedBox(
          height: size.height,
          child:ValueListenableBuilder(
              valueListenable: widget.pageManager.currentSongDetailNotifier,
              builder: (context, val,_) {
                return  Image.network(
                  val.artUri.toString(),
                  fit: BoxFit.cover,
                );
              }
          ),

        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            width: size.width,
            color: Colors.grey[900]!.withOpacity(0.6),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 15.0, top: 0, left: 15.0, bottom: 15.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            widget.pageController.animateToPage(
                                0, duration: const Duration(milliseconds: 800), curve: Curves.bounceOut);
                          },
                          icon: const Icon(Icons.arrow_back_outlined,
                              size: 30, color: Colors.white),
                        ),
                        const Text(
                          'Now Playing',
                          style: TextStyle(fontSize: 35, color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.menu,
                              size: 30, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ValueListenableBuilder(
                      valueListenable: widget.pageManager.currentSongDetailNotifier,
                      builder: (context, val,_) {
                        return  CircleAvatar(
                          radius: 160,
                          backgroundImage:
                          NetworkImage( val.artUri.toString()),
                        );
                      }
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ValueListenableBuilder(
                              valueListenable: widget.pageManager.currentSongDetailNotifier,
                              builder: (context, value, child) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      value.artist!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 35,
                                          color: Colors.white),
                                    ),
                                    Text(
                                    value.title,
                                      style:
                                      const TextStyle(fontSize: 25, color: Colors.grey),
                                    ),
                                  ],
                                );
                              },
                          ),

                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.favorite,
                              color: Colors.grey,
                              size: 40,
                            ),
                          )
                        ]),
                    const SizedBox(
                      height: 15,
                    ),
                    ValueListenableBuilder<ProgressBarState>(
                        valueListenable: widget.pageManager.progressNotifier,
                        builder: (context, value, _) {
                          return ProgressBar(
                            progress: value.current,
                            total: value.total,
                            buffered: value.buffered,
                            baseBarColor: Colors.grey,
                            thumbColor: Colors.white,
                            progressBarColor: Colors.red[900],
                            bufferedBarColor: Colors.redAccent.withOpacity(0.5),
                            thumbGlowColor: Colors.red.withOpacity(0.2),
                            timeLabelTextStyle: const TextStyle(
                                color: Colors.white, fontSize: 18),
                            onSeek: widget.pageManager.seek,
                          );
                        }),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.repeat,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        ValueListenableBuilder(
                            valueListenable:widget.pageManager.isFirstSongNotifier ,
                            builder:  (context, value, child) {
                              return IconButton(
                                onPressed: (){
                                  if(!value){
                                    widget.pageManager.onPreviousPressed();}
                                },
                                icon: const Icon(
                                  Icons.skip_previous_rounded,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              );
                            },
                        ),
                        Container(
                          height: 90,
                          width: 90,
                          padding: const EdgeInsets.all(0),
                          margin: EdgeInsets.zero,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.red[800]!.withOpacity(0.1),
                                    Colors.red
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight)),
                          child: ValueListenableBuilder<ButtonState>(
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
                                      Icons.pause,
                                      color: Colors.white,
                                      size: 65,
                                    ),
                                  );
                                case ButtonState.paused:
                                  return IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      widget.pageManager.play();
                                    },
                                    icon: const Icon(
                                      Icons.play_arrow_rounded,
                                      color: Colors.white,
                                      size: 65,
                                    ),
                                  );
                              }
                            },
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable:widget.pageManager.isLastSongNotifier ,
                          builder:  (context, value, child) {
                            return IconButton(
                              onPressed:(){
                                if(!value){
                                  widget.pageManager.onNextPressed();}
                              },
                              icon: const Icon(
                                Icons.skip_next_rounded,
                                color: Colors.white,
                                size: 40,
                              ),
                            );
                          },
                        ),
                        ValueListenableBuilder(
                            valueListenable: widget.pageManager.volumeStateNotifier,
                            builder: (context, value, child) {

                              if( widget.pageManager.volumeStateNotifier.value){
                                return IconButton(
                                  onPressed: () {
                                    widget.pageManager.onVolumePressed();
                                  },
                                  icon: const Icon(
                                    Icons.volume_up_outlined,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                );
                              }
                              else{
                                return IconButton(
                                  onPressed: () {
                                    widget.pageManager.onVolumePressed();
                                  },
                                  icon: const Icon(
                                    Icons.volume_off_rounded,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                );
                              }


                            },
                        ),

                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_player/services/audio_services.dart';
import 'package:music_player/services/playlist_repository.dart';

class PageManager {

  final _audioHandler = getIt<AudioHandler>();
  //final _audioPlayer ;

  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      buffered: Duration.zero,
      current: Duration.zero,
      total: Duration.zero,
    ),
  );
  final buttonNotifier = ValueNotifier<ButtonState>(
    ButtonState.paused,
  );
  final currentSongDetailNotifier = ValueNotifier<MediaItem>(
      const MediaItem(id: '-1', title: ''));
  final playListNotifier = ValueNotifier<List<MediaItem>>([]);
  final isFirstSongNotifier = ValueNotifier<bool>(false);
  final isLastSongNotifier = ValueNotifier<bool>(false);
  final repeatStateNotifier = RepeatStateNotifier(repeatState.off);
  final volumeStateNotifier = ValueNotifier<bool>(true);

  //late ConcatenatingAudioSource _playList;

  PageManager(){
    init();
  }

  void init () async {
    _loadPlayList();
    _listenChangeInPlayList();
    _listenChangePlayerStateStream();
    _listenChangeCurrentSong();
    _listenChangeCurrentPosition();
    _listenChangeBufferedPosition();
    _listenChangeTotalDuration();

    /*
    _setInitialPlayList();
    _listenChangePlayerStateStream();
    _listenChangePositionStream();
    _listenChangeBufferedPositionStream();
    _listenChangeDurationStream();
    _listenSequenceState();
    */
  }

  Future _loadPlayList() async{
    final songRepository = getIt<PlayListRepository>();
    final playList = await songRepository.fetchMyPlayList();
    final mediaItems = playList.map((song){
      return MediaItem(
        id: song['id']??'',
        title: song['title']??'',
        artist: song['artist'],
        artUri: Uri.parse(song['artUrl']??''),
        extras: {'url':song['url']},
      );
    }).toList();

    _audioHandler.addQueueItems(mediaItems);
/*
    final songRepository = getIt<PlayListRepository>();
    final playList = await songRepository.loadMediaItems();

    _audioHandler.addQueueItems(playList);*/
  }

  _listenChangeInPlayList(){
      _audioHandler.queue.listen((playList) {
        if(playList.isEmpty){
          return;
        }
        playListNotifier.value = playList;
      });

  }
  _listenChangePlayerStateStream(){
    _audioHandler.playbackState.listen((playBackState) {
      final processingState = playBackState.processingState;
      if(processingState == AudioProcessingState.loading ||
      processingState==AudioProcessingState.buffering){
        buttonNotifier.value = ButtonState.loading;
      }
      if(!playBackState.playing){
        buttonNotifier.value = ButtonState.paused;
      }
      else if(processingState!=AudioProcessingState.completed){
        buttonNotifier.value = ButtonState.playing;
      }
      else{
          _audioHandler.seek(Duration.zero);
          _audioHandler.pause();
      }
    });
  }
  _listenChangeCurrentSong(){
    _audioHandler.mediaItem.listen((mediaItem) {
      final playList = _audioHandler.queue.value;
      currentSongDetailNotifier.value=mediaItem??const MediaItem(id: '-1', title: '');
      if(playList.isEmpty||mediaItem==null){
        isFirstSongNotifier.value = false;
        isLastSongNotifier.value = false;
      }
      else{
        isFirstSongNotifier.value = playList.first==mediaItem;
        isLastSongNotifier.value = playList.last==mediaItem;
      }
    });
  }
  _listenChangeCurrentPosition(){
    AudioService.position.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
          current: position,
          buffered: oldState.buffered,
          total: oldState.total);
    });
  }
  _listenChangeBufferedPosition(){
    _audioHandler.playbackState.listen((playBackState) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
          current: oldState.current,
          buffered: playBackState.bufferedPosition,
          total: oldState.total);
    });
  }
  _listenChangeTotalDuration(){
    _audioHandler.mediaItem.listen((mediaItem) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
          current: oldState.current,
          buffered: oldState.buffered,
          total: mediaItem!.duration??Duration.zero);
    });
  }


  void play() {
    _audioHandler.play();
  }
  void pause(){
    _audioHandler.pause();
  }
  void onPreviousPressed(){
    _audioHandler.skipToPrevious();
  }
  void onNextPressed(){
    _audioHandler.skipToNext();
  }
  void seek(position){
    _audioHandler.seek(position);
  }
  void onRepeatPressed(){
    repeatStateNotifier.nextState();
    switch(repeatStateNotifier.value){
      case repeatState.off:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
        break;
      case repeatState.one:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
        break;
      case repeatState.all:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
        break;

    }
  }
  void onVolumePressed(){
    if(volumeStateNotifier.value){
        _audioHandler.androidSetRemoteVolume(0);
        volumeStateNotifier.value=false;
    }
    else{
      _audioHandler.androidSetRemoteVolume(1);
      volumeStateNotifier.value=true;
    }

  }
  void playFromPlayList(index){
      _audioHandler.skipToQueueItem(index);
  }




/*void _setInitialPlayList() async {
    // const String url ='https://dls.music-fa.com/tagdl/1402/Erfan%20Tahmasbi%20-%20To%20(320).mp3?_ga=2.47686247.1168738181.1695113852-1518068999.1692865986&_gl=1*13kkits*_ga*MTUxODA2ODk5OS4xNjkyODY1OTg2*_ga_FKQYXDVPQM*MTY5NTEzODY0MC4zLjEuMTY5NTEzODY0MC4wLjAuMA..';
    // if(_audioPlayer.bufferedPosition==Duration.zero){
    //   await _audioPlayer.setUrl(url);
    // }
    var prefix='assets/images';
    var song1 = Uri.parse('https://dls.music-fa.com/tagdl/1402/Erfan%20Tahmasbi%20-%20To%20(320).mp3?_ga=2.47686247.1168738181.1695113852-1518068999.1692865986&_gl=1*13kkits*_ga*MTUxODA2ODk5OS4xNjkyODY1OTg2*_ga_FKQYXDVPQM*MTY5NTEzODY0MC4zLjEuMTY5NTEzODY0MC4wLjAuMA..');
    var song2 = Uri.parse('https://dls.music-fa.com/tagdl/1402/Mohsen%20Chavoshi%20-%20Zakhme%20Kari%20(320).mp3?_gl=1*1bmr61c*_ga*MTUxODA2ODk5OS4xNjkyODY1OTg2*_ga_FKQYXDVPQM*MTY5NTMwNzAwOS41LjEuMTY5NTMwNzAyNy4wLjAuMA..&_ga=2.148530487.1661561817.1695307010-1518068999.1692865986');
    var song3 = Uri.parse('https://dls.music-fa.com/tagdl/1402/Arvan%20-%20Mese%20Man%20Ki%20(320).mp3?_gl=1*1bmr61c*_ga*MTUxODA2ODk5OS4xNjkyODY1OTg2*_ga_FKQYXDVPQM*MTY5NTMwNzAwOS41LjEuMTY5NTMwNzAyNy4wLjAuMA..&_ga=2.148530487.1661561817.1695307010-1518068999.1692865986');
    var song4 = Uri.parse('https://dls.music-fa.com/tagdl/1402/Armin%20Zarei%20-%20Daram%20Havato%20(128).mp3?_gl=1*1bmr61c*_ga*MTUxODA2ODk5OS4xNjkyODY1OTg2*_ga_FKQYXDVPQM*MTY5NTMwNzAwOS41LjEuMTY5NTMwNzAyNy4wLjAuMA..&_ga=2.148530487.1661561817.1695307010-1518068999.1692865986');
    var song5 = Uri.parse('https://ups.music-fa.com/tagdl/1402/Naser%20Zeynali%20-%20Jazebe%20(320).mp3?_gl=1*26w2f2*_ga*MTUxODA2ODk5OS4xNjkyODY1OTg2*_ga_FKQYXDVPQM*MTY5NTMwNzAwOS41LjEuMTY5NTMwNzAyNy4wLjAuMA..&_ga=2.246499076.1661561817.1695307010-1518068999.1692865986');

    _playList = ConcatenatingAudioSource(children: [
      AudioSource.uri(song2,tag: AudioMetaDate(
          title: 'khkh',
          artist: 'Mohsen Chavoshi',
          imageAddress: '$prefix/Mohsen-Chavoshi.jpg')
      ),
      AudioSource.uri(song1,tag: AudioMetaDate(
          title: 'Del az man',
          artist: 'Erfan Tahmasbi',
          imageAddress: '$prefix/Erfan_Tahmasbi.jpg')
      ),
      AudioSource.uri(song3,tag: AudioMetaDate(
          title: 'Mese Man Ki',
          artist: 'Arvan',
          imageAddress: '$prefix/Arvan.jpg')
      ),
      AudioSource.uri(song4,tag: AudioMetaDate(
          title: 'Armin Zarei',
          artist: 'Havato Daram',
          imageAddress: '$prefix/Armin-Zarei.jpg')
      ),
      AudioSource.uri(song5,tag: AudioMetaDate(
          title: 'Jazebe',
          artist: 'Naser Zeynali',
          imageAddress: '$prefix/Naser-Zeynali.jpg')
      ),
    ]);
    await _audioPlayer.setAudioSource(_playList);
  }*/


/*

  void play() {
    _audioPlayer.play();
  }
  void pause(){
    _audioPlayer.pause();
  }
  void seek(position){
    _audioPlayer.seek(position);
  }
  void onPreviousPressed(){
    _audioPlayer.seekToPrevious();
  }
  void onNextPressed(){
    _audioPlayer.seekToNext();
  }
  void onVolumePressed(){
    if(volumeStateNotifier.value){
      _audioPlayer.setVolume(0);
    }
    else{
      _audioPlayer.setVolume(1);
    }
  }
  void playFromPlayList(index){
    _audioPlayer.seek(Duration.zero,index:index );
    play();
  }


  void _listenChangePlayerStateStream(){
    _audioPlayer.playerStateStream.listen((playerState) {
      final playing = playerState.playing;
      final processingState = playerState.processingState;


      if(processingState==ProcessingState.loading||processingState==ProcessingState.buffering){
        buttonNotifier.value = ButtonState.loading;
      }
      else if(!playing){
        buttonNotifier.value = ButtonState.paused;
      }
      else{
        buttonNotifier.value = ButtonState.playing;
      }

    });
  }
  void _listenChangePositionStream(){
    _audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
          current: position,
          buffered: oldState.buffered,
          total: oldState.total);
    });
  }
  void _listenChangeBufferedPositionStream(){
    _audioPlayer.bufferedPositionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
          current: oldState.current,
          buffered: position,
          total: oldState.total);
    });
  }
  void _listenChangeDurationStream(){
    _audioPlayer.durationStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
          current: oldState.current,
          buffered: oldState.buffered,
          total: position??Duration.zero);
    });
  }
  void _listenSequenceState(){
    _audioPlayer.sequenceStateStream.listen((sequenceState) {
        if(sequenceState==null){
          return;
        }

        //set current song data
        var currentItem = sequenceState.currentSource;
        var song  = currentItem!.tag as AudioMetaDate;
        currentSongDetailNotifier.value = song;

        //set play list
        final playList = sequenceState.effectiveSequence;
        playListNotifier.value = playList.map((song){
          return song.tag as AudioMetaDate;
        }).toList();

        //set next and previous btn
        if(currentItem==null||playList.isNotEmpty){
          isFirstSongNotifier.value =true;
          isLastSongNotifier.value =true;
        }
        else{
          isFirstSongNotifier.value = (currentItem==playList.first);
          isLastSongNotifier.value = (currentItem==playList.last);
        }

    });

    //update volume btn
    _audioPlayer.volumeStream.listen((volumeState) {
      if(volumeState.sign>0){
        volumeStateNotifier.value =  true;
      }
      else{
        volumeStateNotifier.value = false;
      }
    });
  }
   */
}

class AudioMetaDate{
  final String artist;
  final String title;
  final String imageAddress;

  AudioMetaDate({ required this.title,required this.artist, required this.imageAddress});
}

class ProgressBarState {
  final Duration current;
  final Duration buffered;
  final Duration total;

  ProgressBarState(
      {required this.current, required this.buffered, required this.total});
}

class RepeatStateNotifier extends ValueNotifier<repeatState>{
   // repeatState state=repeatState.off;

  RepeatStateNotifier(super.value);

    nextState(){
      if(value==repeatState.values[0]){
        value=repeatState.one;
      }
      else if(value==repeatState.values[1]){
        value=repeatState.all;
      }
      else{
        value=repeatState.off;
      }
    }
}
enum repeatState{
  one,all,off
}

enum ButtonState {
  paused,
  playing,
  loading,
}

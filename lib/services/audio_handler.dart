import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

Future<AudioHandler> initAudioService() async {
  return await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
      androidNotificationChannelName: 'Audio player',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
}

class MyAudioHandler extends BaseAudioHandler {
  final _audioPlayer = AudioPlayer();
  final _playList = ConcatenatingAudioSource(children: []);

  MyAudioHandler() {
    _loadEmptyList();
    _listenSequenceStateChange();
    _notifyAudioHandlerPlayBackEvents();
    _listenToChangeIndexSong();
    _listenToChangeDuration();
  }

  _loadEmptyList() async {
    await _audioPlayer.setAudioSource(_playList);
  }

  _notifyAudioHandlerPlayBackEvents() {
    _audioPlayer.playbackEventStream.listen((event) {
      playbackState.add(PlaybackState(
        controls: [
          MediaControl.skipToPrevious,
          if (_audioPlayer.playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_audioPlayer.processingState]!,
        repeatMode: const{
          LoopMode.off : AudioServiceRepeatMode.none,
          LoopMode.one : AudioServiceRepeatMode.one,
          LoopMode.all : AudioServiceRepeatMode.all,

        }[_audioPlayer.loopMode]!,
        playing: _audioPlayer.playing,
        updatePosition: _audioPlayer.position,
        bufferedPosition: _audioPlayer.bufferedPosition,
        speed: _audioPlayer.speed,
        queueIndex: event.currentIndex,
      ));
    });
  }

  _listenToChangeIndexSong(){
    _audioPlayer.currentIndexStream.listen((index) {
      final playList = queue.value;
      if(playList.isEmpty){
        return;
      }
      mediaItem.add(playList[index!]);
    });
  }

  _listenToChangeDuration(){
    _audioPlayer.durationStream.listen((duration) {
      final index = _audioPlayer.currentIndex;
      final newQueue = queue.value;
      if(index==null||newQueue.isEmpty)return;
      //final oldMediaItem = newQueue[index];
      final newMediaItem = newQueue[index].copyWith(duration: duration);
      newQueue[index] = newMediaItem;
      queue.add(newQueue);
      mediaItem.add(newMediaItem);

    });
  }

  _listenSequenceStateChange(){
    _audioPlayer.sequenceStateStream.listen((sequenceState) {
      final sequence = sequenceState!.effectiveSequence;
      if(sequence.isEmpty)return;
      final items = sequence.map((item) => item.tag as MediaItem).toList();
      queue.add(items);
    });
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    final audioSource = mediaItems.map((mediaItem) {
      return AudioSource.uri(Uri.parse(mediaItem.extras!['url']),
          tag: mediaItem);
    }).toList();

    /*final audioSource = mediaItems.map((mediaItem) {
      return AudioSource.uri(Uri.parse(mediaItem.id),
          tag: mediaItem);
    }).toList();*/

    if(_playList.length<mediaItems.length){

    _playList.addAll(audioSource);
    }
    if(queue.value.length<mediaItems.length){

      final newQueue = queue.value..addAll(mediaItems);
      queue.add(newQueue);
    }

  }

  @override
  Future<void> play() async {
    _audioPlayer.play();
  }

  @override
  Future<void> pause() async {
    _audioPlayer.pause();
  }

  @override
  Future<void> skipToPrevious() async {
    _audioPlayer.seekToPrevious();
  }

  @override
  Future<void> skipToNext() async {
    _audioPlayer.seekToNext();
  }

  @override
  Future<void> seek(position) async {
    _audioPlayer.seek(position);
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        _audioPlayer.setLoopMode(LoopMode.off);
        break;
      case AudioServiceRepeatMode.one:
        _audioPlayer.setLoopMode(LoopMode.one);
        break;
      case AudioServiceRepeatMode.all:
        _audioPlayer.setLoopMode(LoopMode.all);
        break;
      case AudioServiceRepeatMode.group:
        break;
    }
  }

  @override
  Future<void> androidSetRemoteVolume(vol) async {
        _audioPlayer.setVolume(vol.toDouble());

  }

  @override
  Future<void> skipToQueueItem(index) async {
    _audioPlayer.seek(Duration.zero,index:index );

  }
}

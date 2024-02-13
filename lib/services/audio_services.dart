import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:music_player/controller/page_manager.dart';
import 'package:music_player/services/audio_handler.dart';
import 'package:music_player/services/playlist_repository.dart';

final getIt = GetIt.instance;

Future setUpInitService() async{
  getIt.registerSingleton<AudioHandler>(await initAudioService());
  getIt.registerLazySingleton<PlayListRepository>(()=>MyPlayList());
  getIt.registerLazySingleton<PageManager>(()=>PageManager());
}
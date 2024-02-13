import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class PlayListRepository {
  Future<List<Map<String, String>>> fetchMyPlayList();
  //Future<List<MediaItem>> loadMediaItems();
}

class MyPlayList extends PlayListRepository {

  @override
  Future<List<Map<String, String>>> fetchMyPlayList() async {
    var song1 = 'https://dls.music-fa.com/tagdl/1402/Erfan%20Tahmasbi%20-%20To%20(320).mp3?_ga=2.47686247.1168738181.1695113852-1518068999.1692865986&_gl=1*13kkits*_ga*MTUxODA2ODk5OS4xNjkyODY1OTg2*_ga_FKQYXDVPQM*MTY5NTEzODY0MC4zLjEuMTY5NTEzODY0MC4wLjAuMA..';
    var song2 = 'https://dls.music-fa.com/tagdl/1402/Mohsen%20Chavoshi%20-%20Zakhme%20Kari%20(320).mp3?_gl=1*1bmr61c*_ga*MTUxODA2ODk5OS4xNjkyODY1OTg2*_ga_FKQYXDVPQM*MTY5NTMwNzAwOS41LjEuMTY5NTMwNzAyNy4wLjAuMA..&_ga=2.148530487.1661561817.1695307010-1518068999.1692865986';
    var song3 = 'https://dls.music-fa.com/tagdl/1402/Arvan%20-%20Mese%20Man%20Ki%20(320).mp3?_gl=1*1bmr61c*_ga*MTUxODA2ODk5OS4xNjkyODY1OTg2*_ga_FKQYXDVPQM*MTY5NTMwNzAwOS41LjEuMTY5NTMwNzAyNy4wLjAuMA..&_ga=2.148530487.1661561817.1695307010-1518068999.1692865986';
    var song4 = 'https://dls.music-fa.com/tagdl/1402/Armin%20Zarei%20-%20Daram%20Havato%20(128).mp3?_gl=1*1bmr61c*_ga*MTUxODA2ODk5OS4xNjkyODY1OTg2*_ga_FKQYXDVPQM*MTY5NTMwNzAwOS41LjEuMTY5NTMwNzAyNy4wLjAuMA..&_ga=2.148530487.1661561817.1695307010-1518068999.1692865986';
    var song5 = 'https://ups.music-fa.com/tagdl/1402/Naser%20Zeynali%20-%20Jazebe%20(320).mp3?_gl=1*26w2f2*_ga*MTUxODA2ODk5OS4xNjkyODY1OTg2*_ga_FKQYXDVPQM*MTY5NTMwNzAwOS41LjEuMTY5NTMwNzAyNy4wLjAuMA..&_ga=2.246499076.1661561817.1695307010-1518068999.1692865986';
    return [
      {
        'id': '0',
        'title': 'khkh',
        'artist': 'Mohsen Chavoshi',
        'artUrl': 'https://music-fa.com/wp-content/uploads/2023/09/Mohsen-Chavoshi-Eynake-Rayban-Music-fa.com_.jpg',
        'url': song2,
      },
      {
        'id': '1',
        'title': 'Del az man',
        'artist': 'Erfan Tahmasbi',
        'artUrl': 'https://rozmusic.com/wp-content/uploads/2023/09/Erfan-Tahmasbi-To.jpg',
        'url': song1,
      },
      {
        'id': '2',
        'title': 'Mese Man Ki',
        'artist': 'Arvan',
        'artUrl': 'https://download1music.ir/wp-content/uploads/2020/04/257-Ervan-NazaninYar.jpg',
        'url': song3,
      },
      {
        'id': '3',
        'title': 'Armin Zarei',
        'artist': 'Havato Daram',
        'artUrl': 'https://music-fa.com/wp-content/uploads/2023/09/Armin-Zarei-Havato-Daram-Music-fa.com_.jpg',
        'url': song4,
      },
      {
        'id': '4',
        'title': 'Jazebe',
        'artist': 'Naser Zeynali',
        'artUrl': 'https://music-fa.com/wp-content/uploads/2023/06/Naser-Zeynali-Jazebe-Music-fa.com_.jpg',
        'url': song5,
      },
    ];
  }
/*
  final _audioQuery = OnAudioQuery();
  @override
  Future<List<MediaItem>> loadMediaItems() async {
  }
  checkPermission() async{
    var perm = await Permission.storage.request();
    if(perm.isGranted){
      return _audioQuery.querySongs();
    }
    else{
      checkPermission();
    }
  }*/
  /*
  @override
  Future<List<MediaItem>> loadMediaItems() async {
    List<MediaItem> mediaItems = [];

    Directory? directory = await getExternalStorageDirectory();
    //Directory? director = await getExternalStorageDirectories();
    var p = directory!.path.split('/');
    //String path = p[0]+'/'+p[1]+'/'+p[2]+'/'+p[3]+'/Music/';
    String path = p[0]+'/'+p[1]+'/'+p[2]+'/0/Music';
    List<FileSystemEntity> files = Directory(path).listSync();

    print(files.toString());
    for (var file in files)
    {
      if (file.path.endsWith('.mp3')) {
        mediaItems.add(MediaItem(
          id: file.uri.toString(),
          album: 'آلبوم نامعلوم',
          title: file.uri.pathSegments.last,
          artist: 'هنرمند نامعلوم',
          extras: {'file_path': file.path},
          artUri: Uri.parse('https://rozmusic.com/wp-content/uploads/2023/09/Erfan-Tahmasbi-To.jpg'),
        ));
      }
    }

    print('music list len : '+mediaItems.length.toString());
    print('path : '+path);
    return mediaItems;
  }
  */


}
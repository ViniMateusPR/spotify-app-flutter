import 'package:dartz/dartz.dart';
import 'package:spotifyapp/data/sources/song/song_firebase_service.dart';
import 'package:spotifyapp/domain/repository/song/song.dart';

import '../../../service_locator.dart';

class SongRepositoryImpl extends SongsRepository {

  @override
  Future<Either> getNewsSongs() async {
    try {
      final result = await sl<SongFirebaseService>().getNewsSongs();
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either> getPlayslist() async {
    try {
      final result = await sl<SongFirebaseService>().getPlaylist();
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either> addOrRemoveFavoriteSong(String songId) async{
    return await sl<SongFirebaseService>().addOrReomveFavoriteSong(songId);
  }

  @override
  Future<bool> isFavorite(String songId) async{
    return await sl<SongFirebaseService>().isFavorite(songId);
  }

  @override
  Future<Either> getUserFavoriteSongs() async {
    return await sl<SongFirebaseService>().getUserFavoriteSongs();
  }
}

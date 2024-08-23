
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotifyapp/domain/entities/song/song.dart';
import 'package:spotifyapp/domain/usecases/song/is_favorite_song.dart';
import 'package:spotifyapp/service_locator.dart';

import '../../models/song/song.dart';

abstract class SongFirebaseService {
  Future<Either<Exception, List<SongEntity>>> getNewsSongs();
  Future<Either<Exception, List<SongEntity>>> getPlaylist();
  Future<Either> addOrReomveFavoriteSong(String songId);
  Future<bool> isFavorite(String songId);
  Future<Either> getUserFavoriteSongs();
}

class SongFirebaseServiceImpl extends SongFirebaseService {


  @override
  Future<Either<Exception, List<SongEntity>>> getNewsSongs() async {
    try {
      List<SongEntity> songs = [];
      var data = await FirebaseFirestore.instance.collection('Songs')
          .orderBy('releaseDate', descending: true)
          .get();

      for (var element in data.docs) {
        var songData = element.data();
        var songModel = SongModel.fromJson(songData);
        bool isFavorite = await sl<IsFavoriteSongUseCase>().call(
          params: element.reference.id
        );
        songModel.isFavorite = isFavorite;
        songModel.songId = element.reference.id;
        songs.add(songModel.toEntity());
      }
      return Right(songs);
    } catch (e) {
      return Left(Exception('An error occurred, Please try again.'));
    }
  }

  @override
  Future<Either<Exception, List<SongEntity>>> getPlaylist() async {
    try {
      List<SongEntity> songs = [];
      var data = await FirebaseFirestore.instance.collection('Songs').orderBy('releaseDate', descending: true).get();

      for (var element in data.docs) {
        var songData = element.data();
        var songModel = SongModel.fromJson(songData);
        bool isFavorite = await sl<IsFavoriteSongUseCase>().call(
            params: element.reference.id
        );
        songModel.isFavorite = isFavorite;
        songModel.songId = element.reference.id;
        songs.add(songModel.toEntity());
      }
      return Right(songs);
    } catch (e) {
      return Left(Exception('An error occurred, Please try again.'));
    }
  }

  @override
  Future<Either> addOrReomveFavoriteSong(String songId) async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      late bool isFavorite;

      var user = firebaseAuth.currentUser;
      String uId = user!.uid;

      QuerySnapshot favoriteSongs = await firebaseFirestore.collection('Users')
          .doc(uId)
          .collection('Favorites')
          .where(
          'songId', isEqualTo: songId
      )
          .get();

      if (favoriteSongs.docs.isNotEmpty) {
        await favoriteSongs.docs.first.reference.delete();
        isFavorite = false;
      } else {
        await firebaseFirestore.collection('Users')
            .doc(uId)
            .collection('Favorites')
            .add({
          'songId': songId,
          'addedDate': Timestamp.now()
        }
        );
        isFavorite = true;
      }

      return Right(isFavorite);
    } catch(e){
      return const Left('An error occurred');
    }
  }

  @override
  Future<bool> isFavorite(String songId) async{
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      var user = firebaseAuth.currentUser;
      String uId = user!.uid;

      QuerySnapshot favoriteSongs = await firebaseFirestore.collection('Users')
          .doc(uId)
          .collection('Favorites')
          .where(
          'songId', isEqualTo: songId
      )
          .get();

      if (favoriteSongs.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch(e){
      return false;
    }
  }



  @override
  Future < Either > getUserFavoriteSongs() async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      var user = firebaseAuth.currentUser;
      List<SongEntity> favoriteSongs = [];
      String uId = user!.uid;
      QuerySnapshot favoritesSnapshot = await firebaseFirestore.collection(
          'Users'
      ).doc(uId)
          .collection('Favorites')
          .get();

      for (var element in favoritesSnapshot.docs) {
        String songId = element['songId'];
        var song = await firebaseFirestore.collection('Songs').doc(songId).get();
        SongModel songModel = SongModel.fromJson(song.data()!);
        songModel.isFavorite = true;
        songModel.songId = songId;
        favoriteSongs.add(
            songModel.toEntity()
        );
      }

      return Right(favoriteSongs);

    } catch (e) {
      print(e);
      return const Left(
          'An error occurred'
      );
    }
  }
}

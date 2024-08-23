import 'package:dartz/dartz.dart';

abstract class SongsRepository{

  Future<Either> getNewsSongs();
  Future<Either> getPlayslist();
  Future<Either> addOrRemoveFavoriteSong(String songId);
  Future<bool> isFavorite(String songId);
  Future<Either> getUserFavoriteSongs();
}
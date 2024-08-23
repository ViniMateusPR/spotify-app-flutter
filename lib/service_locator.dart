import 'package:get_it/get_it.dart';
import 'package:spotifyapp/data/repository/auth/auth_repository_impl.dart';
import 'package:spotifyapp/data/repository/song/song_repository_impl.dart';
import 'package:spotifyapp/data/sources/auth/auth_firebase_service.dart';
import 'package:spotifyapp/domain/repository/auth/auth.dart';
import 'package:spotifyapp/domain/usecases/auth/get_user.dart';
import 'package:spotifyapp/domain/usecases/auth/sigin.dart';
import 'package:spotifyapp/domain/usecases/auth/singup.dart';
import 'package:spotifyapp/domain/usecases/song/add_or_remove_favorite_song.dart';
import 'package:spotifyapp/domain/usecases/song/get_favorite_songs.dart';
import 'package:spotifyapp/domain/usecases/song/get_news_songs.dart';
import 'package:spotifyapp/domain/usecases/song/is_favorite_song.dart';

import 'data/sources/song/song_firebase_service.dart';
import 'domain/repository/song/song.dart';
import 'domain/usecases/song/get_playlist.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {


  sl.registerSingleton<AuthFirebaseService>(
      AuthFirebaseServiceImpl()
  );

  sl.registerSingleton<SongFirebaseService>(
      SongFirebaseServiceImpl()
  );


  sl.registerSingleton<AuthRepository>(
      AuthRepositoryImpl()
  );

  sl.registerSingleton<SongsRepository>(
      SongRepositoryImpl()
  );



  sl.registerSingleton<SingupUseCase>(
      SingupUseCase()
  );

  sl.registerSingleton<SigninUseCase>(
      SigninUseCase()
  );

  sl.registerSingleton<GetNewsSongsUseCase>(
      GetNewsSongsUseCase()
  );

  sl.registerSingleton<GetPlayListUseCase>(
      GetPlayListUseCase()
  );

  sl.registerSingleton<AddOrRemoveFavoriteSongUseCase>(
      AddOrRemoveFavoriteSongUseCase()
  );

  sl.registerSingleton<IsFavoriteSongUseCase>(
      IsFavoriteSongUseCase()
  );

  sl.registerSingleton<GetUserUseCase>(
      GetUserUseCase()
  );

  sl.registerSingleton<GetFavoriteSongsUseCase>(
      GetFavoriteSongsUseCase()
  );


}
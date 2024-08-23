import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotifyapp/domain/usecases/song/get_news_songs.dart';
import 'package:spotifyapp/presentation/splash/home/bloc/news_songs_state.dart';

import '../../../../service_locator.dart';

class NewsSongsCubit extends Cubit<NewsSongsState> {

  NewsSongsCubit() : super(NewsSongsLoading());

  Future < void > getNewsSongs() async {
    var returnedSongs = await sl < GetNewsSongsUseCase > ().call();
    returnedSongs.fold(
            (l) {
          emit(NewsSongsLoadFailure());
        },
            (data) {
          emit(
              NewsSongsLoaded(songs: data)
          );
        }
    );
  }


}
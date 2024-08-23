import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotifyapp/domain/usecases/song/get_news_songs.dart';
import 'package:spotifyapp/presentation/splash/home/bloc/play_list_state.dart';
import '../../../../service_locator.dart';

class PlayListCubit extends Cubit<PlayListState> {

  PlayListCubit() : super(PlayListLoading());

  Future < void > getPlayList() async {
    var returnedSongs = await sl < GetNewsSongsUseCase > ().call();
    returnedSongs.fold(
            (l) {
          emit(PlayListLoadFailure());
        },
            (data) {
          emit(
              PlayListLoaded(songs: data)
          );
        }
    );
  }


}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotifyapp/common/helpers/is_dark_mode.dart';
import 'package:spotifyapp/common/widgets/favorite_button/favorite_button.dart';
import 'package:spotifyapp/core/configs/theme/app_colors.dart';
import '../../../../domain/entities/song/song.dart';
import '../../song_player/pages/song_player.dart';
import '../bloc/play_list_cubit.dart';
import '../bloc/play_list_state.dart';

class Playlist extends StatelessWidget {
  const Playlist({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlayListCubit()..getPlayList(),
      child: BlocBuilder<PlayListCubit, PlayListState>(
        builder: (context, state) {
          if (state is PlayListLoading) {
            return Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            );
          }
          if (state is PlayListLoaded) {
            print('Songs: ${state.songs}');
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Playlist',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text('See more',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 12,color: Color(0xffc6c6c6)
                        ),),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  _songs(state.songs)
                ],
              ),
            );
          }

          return Container();
        },
      ),
    );
  }

  Widget _songs(List<SongEntity> songs) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        print('Song at index $index: ${songs[index].title}');
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => SongPlayerPage(
                  songEntity: songs[index],
                ),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.isDarkMode ? AppColors.darkGrey : const Color(0xffe6e6e6),
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: context.isDarkMode ? const Color(0xff959595) : const Color(0xff555555),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4, // Ajuste a largura conforme necessário
                        child: Text(
                          songs[index].title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4, // Ajuste a largura conforme necessário
                        child: Text(
                          songs[index].artist,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    songs[index].duration.toString().replaceAll('.', ':'),
                  ),
                  const SizedBox(width: 20,),
                  FavoriteButton(songEntity: songs[index],
                  )
                ],
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 20,),
      itemCount: songs.length,
    );
  }

}
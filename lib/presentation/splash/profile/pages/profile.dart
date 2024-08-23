import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotifyapp/common/helpers/is_dark_mode.dart';
import 'package:spotifyapp/common/widgets/appBar/app_bar.dart';
import 'package:spotifyapp/common/widgets/favorite_button/favorite_button.dart';
import 'package:spotifyapp/core/configs/constants/app_urls.dart';
import 'package:spotifyapp/presentation/splash/profile/bloc/favorite_songs_cubit.dart';
import 'package:spotifyapp/presentation/splash/profile/bloc/favorite_songs_state.dart';
import 'package:spotifyapp/presentation/splash/profile/bloc/profile_info_cubit.dart';
import 'package:spotifyapp/presentation/splash/profile/bloc/profile_info_state.dart';
import 'package:spotifyapp/presentation/splash/song_player/pages/song_player.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        backgroundColor: Color(0xff2c2b2b),
        title: Text('Profile'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _profileInfo(context),
          const SizedBox(height: 30,),
          _favoriteSongs()
        ],
      ),
    );
  }
  
  
  Widget _profileInfo(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileInfoCubit()..getUser(),
      child: Container(
        height: MediaQuery.of(context).size.height / 3.5,
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.isDarkMode ? const Color(0xff2c2b2b) : Colors.white,
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(50),
            bottomLeft: Radius.circular(50)
          )
        ),
        child: BlocBuilder<ProfileInfoCubit,ProfileInfoState>(
          builder: (context, state) {
            if(state is ProfileInfoLoading) {
              return Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator()
              );
            }
            if(state is ProfileInfoLoaded) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          state.userEntity.imageURL!
                        )
                      )
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Text(
                    state.userEntity.email!
                  ),
                  const SizedBox(height: 10,),
                  Text(
                      state.userEntity.fullName!,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              );
            }
            
            if(state is ProfileInfoFailure) {
              return const Text('Please try again');
            }

            return Container();
          },
        ),
      ),
    );
  }

  Widget _favoriteSongs() {
    return BlocProvider(
      create: (context) => FavoriteSongsCubit()..getFavoriteSongs(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('FAVORITES SONGS',
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),),
            const SizedBox(
              height: 20,
            ),
            BlocBuilder<FavoriteSongsCubit, FavoriteSongsState>(
              builder: (context, state) {
                if(state is FavoriteSongsLoading) {
                  return const CircularProgressIndicator();
                }
                if(state is FavoriteSongsLoaded) {
                  return ListView.separated(
                    shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SongPlayerPage(songEntity: state.favoriteSongs[index],)));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            '${AppUrls.coverfirestorage}${state.favoriteSongs[index].artist}.jpeg?${AppUrls.mediaAlt}'
                                        )
                                      )
                                    ),
                                  ),
                                  const SizedBox(width: 10,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.4, // Ajuste a largura conforme necessário
                                        child: Text(
                                          state.favoriteSongs[index].title,
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
                                          state.favoriteSongs[index].artist,
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
                                  const SizedBox(width: 25,),
                                  Row(
                                    children: [
                                      Text(
                                        state.favoriteSongs[index].duration.toString().replaceAll('.', ':'),
                                      ),
                                      const SizedBox(width: 20,),
                                      FavoriteButton(songEntity: state.favoriteSongs[index],
                                        key: UniqueKey(),
                                        function: () {
                                          context.read<FavoriteSongsCubit>().removeSong(index);
                                        },
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(height: 20,),
                      itemCount: state.favoriteSongs.length
                  );
                }
                if(state is FavoriteSongsFailure) {
                  return const Text(
                    'Please try again'
                  );
                }
                return Container();
              },
            )

          ],
        ),
      ),
    );
  }
}

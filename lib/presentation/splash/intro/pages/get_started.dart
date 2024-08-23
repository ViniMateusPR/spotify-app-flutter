import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotifyapp/common/widgets/button/basic_app_button.dart';
import 'package:spotifyapp/core/configs/assets/app_images.dart';
import 'package:spotifyapp/core/configs/assets/app_vectors.dart';
import 'package:spotifyapp/presentation/splash/choose_mode/pages/choose_mode.dart';

import '../../../../core/configs/theme/app_colors.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 40),
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      AppImages.introBG,
                    )
                )
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.15),
          ),


          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 40,
              horizontal: 40,
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SvgPicture.asset(AppVectors.logo),
                ),
                Spacer(),
                Text(
                  'Enjoy Listening to Music',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 20,),
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipliscing elit, sed do eismod tempor incididunt ut labore et delore magna aliqua',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20,),
                BasicAppButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>const ChooseModePage()));
                    },
                    title: 'Get Sarted')
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:dartz/dartz.dart';
import 'package:spotifyapp/core/usecase/usecase.dart';
import 'package:spotifyapp/data/models/auth/signin_user_req.dart';
import 'package:spotifyapp/domain/repository/auth/auth.dart';

import '../../../service_locator.dart';

class SigninUseCase implements UseCase<Either,SinginUserReq> {
  @override
  Future<Either> call({SinginUserReq ? params}) async {
    return sl<AuthRepository>().singin(params!);
  }

}
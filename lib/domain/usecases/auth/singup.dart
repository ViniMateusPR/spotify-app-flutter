import 'package:dartz/dartz.dart';
import 'package:spotifyapp/core/usecase/usecase.dart';
import 'package:spotifyapp/data/models/auth/create_user_req.dart';
import 'package:spotifyapp/domain/repository/auth/auth.dart';

import '../../../service_locator.dart';

class SingupUseCase implements UseCase<Either,CreateUserReq> {
  @override
  Future<Either> call({CreateUserReq ? params}) async {
    return sl<AuthRepository>().singup(params!);
  }

}
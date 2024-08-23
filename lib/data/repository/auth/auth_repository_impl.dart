import 'package:dartz/dartz.dart';
import 'package:spotifyapp/data/models/auth/create_user_req.dart';
import 'package:spotifyapp/data/models/auth/signin_user_req.dart';
import 'package:spotifyapp/data/sources/auth/auth_firebase_service.dart';
import 'package:spotifyapp/domain/repository/auth/auth.dart';

import '../../../service_locator.dart';

class AuthRepositoryImpl extends AuthRepository {


  @override
  Future<Either> singin(SinginUserReq signinUserReq) async{
    return await sl<AuthFirebaseService>().singin(signinUserReq);
  }

  @override
  Future<Either> singup(CreateUserReq createUserReq) async{
    return await sl<AuthFirebaseService>().singup(createUserReq);
  }

  @override
  Future<Either> getUser() async {
    return await sl<AuthFirebaseService>().getUser();
  }

}
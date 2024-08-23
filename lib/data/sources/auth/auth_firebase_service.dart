import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotifyapp/core/configs/constants/app_urls.dart';
import 'package:spotifyapp/data/models/auth/create_user_req.dart';
import 'package:spotifyapp/data/models/auth/user.dart';
import 'package:spotifyapp/domain/entities/auth/user.dart';

import '../../models/auth/signin_user_req.dart';

abstract class AuthFirebaseService {
  Future<Either> singup(CreateUserReq createUserReq);

  Future<Either> singin(SinginUserReq singinUserReq);

  Future<Either> getUser();
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  @override
  Future<Either> singin(SinginUserReq singinUserReq) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: singinUserReq.email, password: singinUserReq.password);

      return const Right('Sigin was Successful');
    } on FirebaseAuthException catch (e) {
      String message = '';

      if (e.code == 'invalid-email') {
        message = 'Not user found for that email';
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong password provided for that user.';
      }

      return Left(message);
    }
  }

  @override
  Future<Either> singup(CreateUserReq createUserReq) async {
    try {
      var data = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: createUserReq.email, password: createUserReq.password);

      FirebaseFirestore.instance
          .collection('Users')
          .doc(data.user?.uid)
          .set({'name': createUserReq.fullName, 'email': data.user?.email});

      return const Right('Signup was Successful');
    } on FirebaseAuthException catch (e) {
      String message = '';

      if (e.code == 'weak-password') {
        message = 'The password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists whit that email.';
      }

      return Left(message);
    }
  }

  @override
  Future<Either> getUser() async {
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      var user = await firebaseFirestore
          .collection('Users')
          .doc(firebaseAuth.currentUser?.uid)
          .get();

      UserModel userModel = UserModel.fromJson(user.data()!);
      userModel.imageURL =
          firebaseAuth.currentUser?.photoURL ?? AppUrls.defaultImage;
      UserEntity userEntity = userModel.toEntity();
      return Right(userEntity);
    } catch (e) {
      return const Left('An error occurred');
    }
  }
}

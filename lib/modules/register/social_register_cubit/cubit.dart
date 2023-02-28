// ignore_for_file: unnecessary_import, avoid_print, non_constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/modules/register/social_register_cubit/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocialRegisterCubit extends Cubit<SocialregisterState> {
  SocialRegisterCubit() : super(SocialregisterInitialState());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  void userregister({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) {
    emit(SocialregisterLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
    ).then((value)
    {
      print(value.user!.email);
      print(value.user!.uid);
      userCreate(
          email: email,
          uId: value.user!.uid,
          name: name,
          phone: phone
      );
    }).catchError((error)
    {
      print(error.toString());
      emit(SocialregisterErrorState(error.toString()));
    });
  }

  void userCreate({
    required String email,
    required String uId,
    required String name,
    required String phone,
})

  {
    SocialUserModel _userModel = SocialUserModel(
      email: email,
      name: name,
      phone: phone,
      uId: uId,
      bio: 'write your bio...',
        isEmailVerified: false,
        image: 'https://img.freepik.com/free-photo/stylish-man-posing-building-scene_158595-2391.jpg?w=900&t=st=1672078161~exp=1672078761~hmac=11ea5f7cca47eff6270a76ac033b9d928bb7138909f2d37da234ce7b23e54f39',
        cover: 'https://img.freepik.com/free-photo/friendly-man-sitting_23-2147646604.jpg?w=900&t=st=1672078198~exp=1672078798~hmac=9b99de5d925e6acf58d0917482a355f050a4da851361bf07692fe9738b744c97',
    );
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .set(_userModel
          .tomap()).then((value)
      {
        emit(SocialCreateUserSuccessState());
      }).catchError((error)
      {
        emit(SocialregisterErrorState(error.toString()));
      });
  }

  // IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void ChangePassowrdVisibality() {
    isPassword = !isPassword;
    // suffix =
    //     isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(SocialRegisterPasswordVisibalityState());
  }
}

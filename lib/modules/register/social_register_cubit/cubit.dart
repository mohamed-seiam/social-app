// ignore_for_file: unnecessary_import, avoid_print, non_constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/modules/register/social_register_cubit/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constance.dart';

class SocialRegisterCubit extends Cubit<SocialregisterState> {
  SocialRegisterCubit() : super(SocialregisterInitialState());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  Future<void> userRegister({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    emit(SocialregisterLoadingState());
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      print(value.user!.email);
      print('cubit register : ${value.user!.uid}');
      userCreate(email: email, uId: value.user!.uid, name: name, phone: phone);
    });
  }

  Future<void> userCreate({
    required String email,
    required String uId,
    required String name,
    required String phone,
  }) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    SocialUserModel userModel = SocialUserModel(
      email: email,
      name: name,
      phone: phone,
      uId: uId,
      bio: 'write your bio...',
      createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
      isEmailVerified: false,
      image: defaultProfileImage,
      cover: defaultCoverImage,
      isOnline: false,
      lastActive: time,
      pushToken: '',
    );
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(userModel.toMap())
        .then((value) {
      emit(
        SocialCreateUserSuccessState(uId),
      );
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

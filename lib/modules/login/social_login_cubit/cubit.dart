// ignore_for_file: unnecessary_import, avoid_print, non_constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:chatapp/modules/login/social_login_cubit/states.dart';
import 'package:chatapp/network/local/cach_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocialLoginCubit extends Cubit<SocialloginState> {
  SocialLoginCubit() : super(SocialloginInitialState());

  static SocialLoginCubit get(context) => BlocProvider.of(context);

  void userloin({
    required String email,
    required String password,
  }) {
    emit(SocialloginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password).then((value)
    {
      print(value.user!.email);
      print(value.user!.uid);
      emit(SocialloginSuccessState(value.user!.uid));
    }).catchError((error)
    {
      emit(SocialloginErrorState(error.toString()));
    });
  }

  // IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void ChangePassowrdVisibality() {
    isPassword = !isPassword;
    // suffix =
    //     isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(ShopChangePasswordVisibalityState());
  }
}

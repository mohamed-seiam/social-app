// ignore_for_file: prefer_const_constructors
import 'package:bloc/bloc.dart';
import 'package:chatapp/network/local/cach_helper.dart';
import 'package:chatapp/shared/cubit/appstates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// class AppCubit extends Cubit<AppStates>
// {
//   AppCubit():super(AppInitialState());
//
//   static AppCubit get(context) => BlocProvider.of(context);
//
//     ThemeMode appmode = ThemeMode.dark;
//    bool isDark = false;
//   void changeAppMode({bool ? fromShared}){
//     if(fromShared!=null)
//     {
//       isDark = fromShared;
//       emit(AppChangeTHemeMode());
//     }
//     else
//     {
//       isDark = !isDark;
//       CachHelper.putBool(key: 'isDark', value:isDark);
//       emit(AppChangeTHemeMode());
//     }
//
//   }
// }
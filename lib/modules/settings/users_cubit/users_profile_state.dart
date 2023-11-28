part of 'users_profile_cubit.dart';


abstract class UsersProfileState {}

class UsersProfileInitial extends UsersProfileState {}
class UsersProfileLoading extends UsersProfileState {}
class UsersProfileSuccess extends UsersProfileState {}
class UsersProfileFailure extends UsersProfileState {}
class UserChangedFollow extends UsersProfileState {}

abstract class SocialregisterState {}

class SocialregisterInitialState extends SocialregisterState {}

class SocialregisterLoadingState extends SocialregisterState {}

class SocialregisterSuccessState extends SocialregisterState {}

class SocialregisterErrorState extends SocialregisterState {
  final String error;

  SocialregisterErrorState(this.error);
}

class SocialCreateUserSuccessState extends SocialregisterState {
  final String uid;

  SocialCreateUserSuccessState(this.uid);
}

class SocialCreateUserErrorState extends SocialregisterState {
  final String error;

  SocialCreateUserErrorState(this.error);
}

class SocialRegisterPasswordVisibalityState extends SocialregisterState {}

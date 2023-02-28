
abstract class SocialloginState {}

class SocialloginInitialState extends SocialloginState {}

class SocialloginLoadingState extends SocialloginState {}

class SocialloginSuccessState extends SocialloginState {
 final String uId;

  SocialloginSuccessState(this.uId);
}

class SocialloginErrorState extends SocialloginState {
  final String error;

  SocialloginErrorState(this.error);
}

class ShopChangePasswordVisibalityState extends SocialloginState {}


abstract class SocialStates {}
class InitialState extends SocialStates{}

class SocialGetUserLoadingState extends SocialStates{}

class SocialGetUserSuccessState extends SocialStates{}

class SocialGetUserErrorState extends SocialStates{
  final String error;

  SocialGetUserErrorState(this.error);
}
/// for get Comments States
class SocialGetCommentsLoadingState extends SocialStates{}
class SocialGetCommentsSuccessState extends SocialStates{
}
class SocialGetCommentsFailureState extends SocialStates{}

/// for send Comments states
class SocialCreateCommentLoading extends SocialStates {}
class SocialCreateCommentSuccess extends SocialStates {}
class SocialCreateCommentFailure extends SocialStates {}
class SocialGetCommentImageSuccess extends SocialStates{}
class SocialGetCommentImageFailure extends SocialStates{}

class SocialGetAllUserLoadingState extends SocialStates{}

class SocialGetAllUserSuccessState extends SocialStates{}

class SocialGetAllUserErrorState extends SocialStates{
  final String error;

  SocialGetAllUserErrorState(this.error);
}

class ChangeBottomNav extends  SocialStates{}

class SocialAddPost extends SocialStates {}

class SocialPickedImageSuccess extends SocialStates{}

class SocialPickedImageError extends SocialStates{}

class SocialPickedCoverSuccess extends SocialStates{}

class SocialPickedCoverError extends SocialStates{}

class SocialSaveImageOnDataBaseSuccess extends SocialStates{}

class SocialSaveImageOnDataBaseError extends SocialStates{}

class SocialSaveCoverOnDataBaseSuccess extends SocialStates{}

class SocialSaveCoverOnDataBaseError extends SocialStates{}

class SocialUpdateDataError extends SocialStates {}

class SocialLoadingUpdateDataState extends SocialStates {}

class SocialUpdateSuccessData extends SocialStates {}

class SocialGetLastMessage extends SocialStates {}
//create post

class SocialLoadingCreatePost extends SocialStates{}

class SocialSuccessCreatePost extends SocialStates{}

class SocialErrorCreatePost extends SocialStates{}

class SocialPickedPostImageSuccess extends SocialStates{}

class SocialPickedPostImageError extends SocialStates{}

class SocialRemovePostImage extends SocialStates {}


//getposts


class SocialGetPostsLoadingState extends SocialStates{}

class SocialGetPostsSuccessState extends SocialStates{}

class SocialGetPostsErrorState extends SocialStates{
  final String error;

  SocialGetPostsErrorState(this.error);
}

//likes states

class SocialLikesSuccessState extends SocialStates{}

class SocialLikesErrorState extends SocialStates{
  final String error;

  SocialLikesErrorState(this.error);
}

class SocialGetLikesSuccessState extends SocialStates{}

class SocialGetLikesErrorState extends SocialStates{
  final String error;

  SocialGetLikesErrorState(this.error);
}

//send messages

class SocialSendMessageSuccessState extends SocialStates{}

class SocialSendMessageErrorState extends SocialStates{
  final String error;
  SocialSendMessageErrorState(this.error);
}

class SocialGetMessageSuccessState extends SocialStates{}

class SocialGetMessageErrorState extends SocialStates{
  final String error ;
  SocialGetMessageErrorState(this.error);
}
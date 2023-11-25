part of 'comment_cubit.dart';

@immutable
abstract class CommentState {}

class CommentInitial extends CommentState {}

class CommentCreateCommentLoading extends CommentState {}

class CommentCreateCommentSuccess extends CommentState {}

class CommentCreateCommentFailure extends CommentState {}

class CommentGetCommentImageSuccess extends CommentState {}
class CommentGetCommentsSuccess extends CommentState {}
class CommentGetCommentsLoading extends CommentState {}
class CommentGetCommentsFailure extends CommentState {}

class CommentGetCommentImageFailure extends CommentState {}
class CommentRemoveCommentImage extends CommentState  {}
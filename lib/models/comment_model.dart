class CommentModel {
  late final String comment;
  late final String nameOfCommentor;
  late final String timeOfComment;
  late final String imageOfCommentor;
  late final String commentId;
  late final String commentImage;
  CommentModel(
      {required this.comment,
      required this.nameOfCommentor,
      required this.timeOfComment,required this.imageOfCommentor,required this.commentId,required this.commentImage});

  CommentModel.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
    nameOfCommentor = json['name_commentor'];
    timeOfComment = json['timeOfComment'];
    imageOfCommentor = json['imageOfCommentor'];
    commentId = json['commentId'];
    commentImage = json['image'];
  }

  Map<String,dynamic>toJson(){
    return {
      'comment':comment,
      'name_commentor':nameOfCommentor,
      'timeOfComment':timeOfComment,
      'imageOfCommentor':imageOfCommentor,
      'commentId':commentId,
      'image':commentImage
    };
  }
}

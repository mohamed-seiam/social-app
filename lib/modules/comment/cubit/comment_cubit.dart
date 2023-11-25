import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chatapp/cubit/cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';

import '../../../models/comment_model.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  CommentCubit() : super(CommentInitial());

  static CommentCubit get(context) => BlocProvider.of(context);
  File ? commentImage;
  bool showEmoji = false;
  bool isUploading = false;
  final ImagePicker commentPickerImage = ImagePicker();
  void deleteCommentImage() {
    commentImage = null;
    emit(CommentRemoveCommentImage());
  }
  Future<void> getCommentImage() async{
    final pickedImage = await commentPickerImage.pickImage(source: ImageSource.gallery);
    if(pickedImage!=null){
      commentImage = File(pickedImage.path);
      emit(CommentGetCommentImageSuccess());
    }else {
      emit(CommentGetCommentImageFailure());
    }
  }
  void upLoadCommentImage({
    required String comment,
    required String dateTime,
    required String posId,
  }) {
    emit(CommentCreateCommentLoading());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('comments/${Uri
        .file(commentImage!.path)
        .pathSegments
        .last}')
        .putFile(commentImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        sendComment(postId: posId, comment: comment, dateTime: dateTime.toString(), image: value).then((value) {
          emit(CommentCreateCommentSuccess());
        });
      },).catchError((error) {
        emit(CommentCreateCommentFailure());
      });
    }).catchError((error) {
      emit(CommentCreateCommentFailure());
    });
  }

  List<CommentModel> comments = [];

  Future<void> sendComment(
      {required String postId, required String comment, required String dateTime,required String image}) async {
    CommentModel commentModel = CommentModel(
      comment: comment,
      nameOfCommentor: SocialCubit.model!.name,
      timeOfComment: dateTime,
      imageOfCommentor: SocialCubit.model!.image,
      commentImage:image,
      commentId: const Uuid().v1(),
    );
    // comments.clear();
    FirebaseFirestore.instance.collection('posts').doc(postId).collection(
        'comments').doc(commentModel.commentId).set(commentModel.toJson()).then((value) {
      final postCollection = FirebaseFirestore.instance.collection('posts').doc(postId);
      postCollection.get().then((value) {
        final totalComments = value.get('totalComments');
        postCollection.update({
          'totalComments':totalComments+1,
        });
      });
    });
    emit(CommentCreateCommentSuccess());
  }

  void getComments({required String postId}) {
    FirebaseFirestore.instance.collection('posts').doc(postId).collection(
        'comments').orderBy('timeOfComment').snapshots().listen((comment) {
      comments.clear();
      for(var comment in comment.docs){
        comments.add(CommentModel.fromJson(comment.data()));
      }
      emit(CommentGetCommentsSuccess());
    });
  }
}

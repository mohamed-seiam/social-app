import 'dart:io';

import 'package:chatapp/cubit/cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../models/post_model.dart';

part 'feeds_state.dart';

class FeedsCubit extends Cubit<FeedsState> {
  FeedsCubit() : super(FeedsInitial());

  static FeedsCubit get(context) => BlocProvider.of(context);
  File? postImage;
  final ImagePicker picker = ImagePicker();
  List<SocialPostModel> posts = [];
  File? postVideo;

  Future<void> getPostImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      postImage = File(pickedImage.path);
      emit(FeedsPickedImageSuccess());
    } else {
      emit(FeedsPickedImageFailure());
    }
  }
  Future<void> getPostVideo() async {
    final pickedVideo = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      postVideo = File(pickedVideo.path);
      emit(FeedsPickedVideoSuccess());
    } else {
      emit(FeedsPickedVideoFailure());
    }
  }

  void deletePostImage() {
    postImage = null;
    emit(FeedsRemovePickedImage());
  }

  void deletePostVideo() {
    postVideo = null;
    emit(FeedsRemovePickedVideo());
  }

  void upLoadPostImage({
    required String text,
    required Timestamp dateTime,
  }) {
    emit(FeedsLoading());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        upLoadPost(
          text: text,
          dateTime: dateTime,
          postImage: value,
          type: 'image',
        );
      }).catchError((error) {
        emit(FeedsFailure());
      });
    }).catchError((error) {
      emit(FeedsFailure());
    });
  }
  void upLoadPostVideo({
    required String text,
    required Timestamp dateTime,
  }) {
    emit(FeedsLoading());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postVideo!.path).pathSegments.last}')
        .putFile(postVideo!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        upLoadPost(
          text: text,
          dateTime: dateTime,
          postVideo: value,
          type: 'video',
        );
      }).catchError((error) {
        emit(FeedsFailure());
      });
    }).catchError((error) {
      emit(FeedsFailure());
    });
  }

  Future<void> upLoadPost({
    required String text,
    required Timestamp dateTime,
    String? postImage,
    String ? postVideo,
    String ? type,
  }) async {
    emit(FeedsLoading());
    posts.clear();
    SocialPostModel postModel = SocialPostModel(
      name: SocialCubit.model?.name ?? 'm',
      image: SocialCubit.model?.image ?? '',
      uId: SocialCubit.model?.uId ?? '',
      text: text,
      dateTime: dateTime,
      type: type,
      postImage: postImage ?? '',
      postVideo: postVideo??'',
      totalComments: 0,
      postId: const Uuid().v1(),
      likes: [],
      totalLikes: 0,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postModel.postId)
        .set((postModel.toMap()))
        .then((value) {
      emit(FeedsSuccess());
    }).catchError((error) {
      emit(FeedsFailure());
    });
  }

  void getPosts() {
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((value) {
      posts.clear();
      for (var element in value.docs) {
        posts.add(SocialPostModel.fromJson(element.data()));
      }
      emit(GetFeedsSuccess());
    });
  }

  Future<void> likePost({required postId}) async {
    final postCollection = FirebaseFirestore.instance.collection('posts');
    final postRef = await postCollection.doc(postId).get();
    if (postRef.exists) {
      List likes = postRef.get('likes');
      final totalLikes = postRef.get('totalLikes');
      if (likes.contains(SocialCubit.model!.uId)) {
        postCollection.doc(postId).update({
          'likes': FieldValue.arrayRemove([SocialCubit.model!.uId]),
          'totalLikes': totalLikes - 1,
        });
      } else {
        postCollection.doc(postId).update({
          'likes': FieldValue.arrayUnion([SocialCubit.model!.uId]),
          'totalLikes': totalLikes + 1,
        });
      }
    }
  }

  Future<void> deletePost({required SocialPostModel model}) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(model.postId)
        .delete();
    if (model.postImage != null) {
      await FirebaseStorage.instance.refFromURL(model.postImage!).delete();
      print('image m4 null');
    }
    if (model.postVideo != null) {
      await FirebaseStorage.instance.refFromURL(model.postVideo!).delete();
    }
  }

  Future<void> editPost(String? updatedText, {required String postId}) async {
    if (updatedText != null) {
      await FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'text': updatedText,
      });
    }
  }
}

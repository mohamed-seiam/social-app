// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chatapp/cubit/states.dart';
import 'package:chatapp/models/message_model.dart';
import 'package:chatapp/models/post_model.dart';
import 'package:chatapp/modules/chats/chat_screen.dart';
import 'package:chatapp/modules/feeds/feeds_screen.dart';
import 'package:chatapp/modules/posts/posts.dart';
import 'package:chatapp/modules/settings/settings_screen.dart';
import 'package:chatapp/modules/users/users_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../constance.dart';
import '../models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SocialCubit extends Cubit<SocialStates>
{
  SocialCubit() : super(InitialState());

static SocialCubit get(context)=>BlocProvider.of(context);

SocialUserModel ? model;


  void getUserData()
  {
    emit(SocialGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value)
    {
      model = SocialUserModel.fromjson(value.data()!);
      emit(SocialGetUserSuccessState());
    }).catchError((error)
    {
      print(error.toString());
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  List<Widget> screens =
  [
      FeedsScreen(),
      ChatScreen(),
      PostScreen(),
      UsersScreen(),
      SettingsScreen(),
  ];

  List<String> titles=
  [
    'Feeds',
    'Chat',
    'Posts',
    'Users',
    'Profile',
  ];

  int currentIndex = 0;

  void changeBottomNav(int index)
  {
    if(index==1) {
      getAllUsers();
    }
    if(index==2)
    {
      emit(SocialAddPost());
    }
    else
    {
      currentIndex = index ;
      emit(ChangeBottomNav());
    }
  }
  File ? profileImage;
  File ? coverImage;
  final ImagePicker picker = ImagePicker();

  Future<void> upLoadImage() async
  {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if(pickedImage!=null)
    {
      profileImage = File(pickedImage.path);
      emit(SocialPickedImageSuccess());
    }
      else
    {
      print('No image Selected');

      emit(SocialPickedImageError());
    }
  }

  Future<void> upLoadCoverImage() async
  {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if(pickedImage!=null)
    {
      coverImage = File(pickedImage.path);
      emit(SocialPickedCoverSuccess());
    }else
    {
      print('No image Selected');

      emit(SocialPickedCoverError());
    }
  }



void saveProfileImageToDataBase ({required String name,
  required String phone,
  required String bio,
})
{
  emit(SocialLoadingUpdateDataState());
  firebase_storage.FirebaseStorage.instance
      .ref()
      .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
      .putFile(profileImage!).then((value)
  {
    value.ref.getDownloadURL().then((value)
    {
      //emit(SocialSaveImageOnDataBaseSuccess());
      upDateUser(
          name: name,
          phone: phone,
          bio: bio,
          image: value,
      );
    }).catchError((error)
    {
      emit(SocialSaveImageOnDataBaseError());
    });
  })
      .catchError((error)
  {
    emit(SocialSaveImageOnDataBaseError());
  });
}

  void saveCoverImageToDataBase ({required String name,
    required String phone,
    required String bio,
  })
  {
    emit(SocialLoadingUpdateDataState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!).then((value)
    {
      value.ref.getDownloadURL().then((value)
      {
        emit(SocialSaveCoverOnDataBaseSuccess());
        upDateUser(
            name: name,
            phone: phone,
            bio: bio,
            cover: value,
        );
      }).catchError((error)
      {
        emit(SocialSaveCoverOnDataBaseError());
      });
    })
        .catchError((error)
    {
      emit(SocialSaveCoverOnDataBaseError());
    });
  }

//   void updateUserImages({
//     required String name,
//     required String phone,
//     required String bio,
// })
//   {
//     emit(SocialLoadingUpdateDataState());
//
//     if(coverImage!=null)
//     {
//       saveCoverImageToDataBase();
//     }
//     else if(profileImage!=null)
//     {
//       saveProfileImageToDataBase();
//     }
//     else if (coverImage !=null && profileImage !=null )
//     {
//
//     }
//     else
//     {
//       upDateUser(name: name, phone: phone, bio: bio);
//     }
//     }


    void upDateUser({
      required String name,
      required String phone,
      required String bio,
      String ? cover,
      String ? image,
    })
    {
      SocialUserModel userModel = SocialUserModel(
        name: name,
        phone: phone,
        bio: bio,
        isEmailVerified: false,
        image:image ?? model!.image,
        cover:cover ?? model!.cover,
        email: model!.email,
        uId: model!.uId,
      );
      FirebaseFirestore.instance.collection('users')
          .doc(model?.uId)
          .update(userModel.tomap()).then((value)
      {
        getUserData();

      }).catchError((error)
      {
        emit(SocialUpdateDataError());
      });

    }

    //posts method

  File ? postImage;

  Future<void> getPostImage() async
  {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if(pickedImage!=null)
    {
      postImage = File(pickedImage.path);
      emit(SocialPickedPostImageSuccess());
    }else
    {
      print('No image Selected');

      emit(SocialPickedPostImageError());
    }
  }

  void deletePostImage()
  {
    postImage = null;
    emit(SocialRemovePostImage());
  }

  void upLoadPostImage({
    required String text,
    required String dateTime,

  })
  {
    emit(SocialLoadingCreatePost());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!).then((value)
    {
      value.ref.getDownloadURL().then((value)
      {
        upLoadPost(
            text: text,
            dateTime: dateTime,
            postImage:value,
        );
      }).catchError((error)
      {
        emit(SocialErrorCreatePost());
      });
    })
        .catchError((error)
    {
      emit(SocialErrorCreatePost());
    });
  }

  void upLoadPost({
    required String text,
    required String dateTime,
    String ? postImage,

  })
  {
    emit(SocialLoadingCreatePost());
    SocialPostModel PostModel = SocialPostModel(
      name: model!.name,
      image:model!.image,
      uId: model!.uId,
      text: text,
      dateTime: dateTime,
      postImage: postImage ?? '',
    );
    FirebaseFirestore.instance.collection('posts')
        .add(PostModel.tomap()).then((value)
    {
      emit(SocialSuccessCreatePost());
    }).catchError((error)
    {
      emit(SocialErrorCreatePost());
    });

  }

  List<SocialPostModel> posts = [];
  List<String> postId = [];
  List<int> likes = [];
  void getPosts()
  {
      FirebaseFirestore.instance
          .collection('posts')
          .snapshots()
          .listen((value)
      {
        value.docs.forEach((element)
        {
          element.reference
          .collection('likes')
          .snapshots()
          .listen((value)
          {
            likes.add(value.docs.length);
            postId.add(element.id);
            posts.add(SocialPostModel.fromjson(element.data()));
          });

        });
        emit(SocialGetPostsSuccessState());
      });
      //     .catchError((error)
      // {
      //   emit(SocialGetPostsErrorState(error.toString()));
      // });
  }


  void sendLikes(String postId)
  {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(model!.uId)
        .set({
      'like':true
    }).then((value)
    {
        emit(SocialLikesSuccessState());
    }).catchError((error)
    {
        emit(SocialLikesErrorState(error.toString()));
    });
  }

  List<SocialUserModel> allUsers = [];

  void getAllUsers()
  {
    if(allUsers.isEmpty) {
      FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value)
    {
      value.docs.forEach((element)
      {
        if(element.data()['uId'] != model!.uId)
        allUsers.add(SocialUserModel.fromjson(element.data()));
      });
      emit(SocialGetAllUserSuccessState());
    }).catchError((error)
    {
      emit(SocialGetAllUserErrorState(error.toString()));
    });
    }
  }

  void sendMessage({
  required String ? receiverId,
    required String ? text,
    required String? dateTime,
})
  {
          SocialMessageModel messageModel = SocialMessageModel(
            text: text,
            dateTime: dateTime,
            receiverId: receiverId,
            senderId: model!.uId,
          );
          FirebaseFirestore.instance
          .collection('users')
           .doc(model!.uId)
           .collection('chats')
           .doc(receiverId)
           .collection('messages')
          .add(messageModel.tomap())
          .then((value)
          {
            emit(SocialSendMessageSuccessState());
          }).catchError((error)
          {
            emit(SocialSendMessageErrorState(error.toString()));
          });

          FirebaseFirestore.instance
              .collection('users')
              .doc(receiverId)
              .collection('chats')
              .doc(model!.uId)
              .collection('messages')
              .add(messageModel.tomap())
              .then((value)
          {
            emit(SocialSendMessageSuccessState());
          }).catchError((error)
          {
            emit(SocialSendMessageErrorState(error.toString()));
          });
  }

  List<SocialMessageModel> messages = [];

  void getMessages({required String ? receiverId})
  {
    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event)
    {
      messages = [];
      event.docs.forEach((element)
      {

        messages.add(SocialMessageModel.fromjson(element.data()));
      });
      emit(SocialGetMessageSuccessState());
    });
  }
}

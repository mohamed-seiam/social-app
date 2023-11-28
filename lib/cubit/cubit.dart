import 'dart:io';
import 'package:chatapp/cubit/states.dart';
import 'package:chatapp/modules/chats/chat_screen.dart';
import 'package:chatapp/modules/feeds/feeds_cubit/feeds_cubit.dart';
import 'package:chatapp/modules/feeds/feeds_screen.dart';
import 'package:chatapp/modules/posts/posts.dart';
import 'package:chatapp/modules/settings/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../network/remote/apis.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(InitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

 static SocialUserModel? model;
  final user = FirebaseAuth.instance;

  void getUserData() async {
    emit(SocialGetUserLoadingState());
    final userId = user.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((value)  {
      model = SocialUserModel.fromJson(value.data()!);
      emit(SocialGetUserSuccessState());
    }).then((value) {
      Api.getSelfInfo();
    });
    // }).catchError((error) {
    //   log(error.toString());
    //   emit(SocialGetUserErrorState(error.toString()));
    // });
  }


  List<Widget> screens = [
    BlocProvider(
      create: (_)=>FeedsCubit()..getPosts(),
        child: const FeedsScreen()),
    const ChatScreen(),
    const PostScreen(),
    // const UsersScreen(),
    const SettingsScreen(),
  ];

  List<String> titles = [
    'Feeds',
    'Chat',
    'Posts',
    'Users',
    'Profile',
  ];

  int currentIndex = 0;

  void changeBottomNav(int index) {
    if (index == 1) {
      getAllUsers();
    }
    if (index == 2) {
      emit(SocialAddPost());
    } else {
      currentIndex = index;
      emit(ChangeBottomNav());
    }
  }

  File? profileImage;
  File? coverImage;
  final ImagePicker picker = ImagePicker();

  Future<void> upLoadImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      profileImage = File(pickedImage.path);
      emit(SocialPickedImageSuccess());
    } else {
      emit(SocialPickedImageError());
    }
  }

  Future<void> upLoadCoverImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      coverImage = File(pickedImage.path);
      emit(SocialPickedCoverSuccess());
    } else {
      emit(SocialPickedCoverError());
    }
  }

  void saveProfileImageToDataBase({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(SocialLoadingUpdateDataState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri
        .file(profileImage!.path)
        .pathSegments
        .last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        //emit(SocialSaveImageOnDataBaseSuccess());
        upDateUser(
          name: name,
          phone: phone,
          bio: bio,
          image: value,
        );
      }).catchError((error) {
        emit(SocialSaveImageOnDataBaseError());
      });
    }).catchError((error) {
      emit(SocialSaveImageOnDataBaseError());
    });
  }

  void saveCoverImageToDataBase({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(SocialLoadingUpdateDataState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri
        .file(coverImage!.path)
        .pathSegments
        .last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(SocialSaveCoverOnDataBaseSuccess());
        upDateUser(
          name: name,
          phone: phone,
          bio: bio,
          cover: value,
        );
      }).catchError((error) {
        emit(SocialSaveCoverOnDataBaseError());
      });
    }).catchError((error) {
      emit(SocialSaveCoverOnDataBaseError());
    });
  }

  String pushToken = '';

  Future<String> getDeviceToken() async {
    await Api.messaging.getToken().then((value) {
      if (value != null) {
        pushToken = value;
      }
    });
    return pushToken;
  }

  void upDateUser({
    required String name,
    required String phone,
    required String bio,
    String? cover,
    String? image,
  }) {
    SocialUserModel userModel = SocialUserModel(
      name: name,
      phone: phone,
      bio: bio,
      isEmailVerified: false,
      image: image ?? model!.image,
      cover: cover ?? model!.cover,
      email: model!.email,
      uId: model!.uId,
      createdAt: DateTime
          .now()
          .millisecondsSinceEpoch
          .toString(),
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(model?.uId)
        .update(userModel.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(SocialUpdateDataError());
    });
  }
  Future<String> uploadFileAndGetUrl(String filePath) async {
    // Create a reference to the Firebase Storage bucket
    Reference storageRef = FirebaseStorage.instance.ref();

    // Create a unique filename for the file
    String fileName =filePath.split('.').last;

    // Upload the file to Firebase Storage
    TaskSnapshot uploadTask = await storageRef.child(fileName).putFile(File(filePath));

    // Get the download URL of the uploaded file
    String downloadUrl = await uploadTask.ref.getDownloadURL();

    // Return the download URL
    return downloadUrl;
  }
  List<SocialUserModel> allUsers = [];

  void getAllUsers() async {
    if (allUsers.isEmpty) {
      await FirebaseFirestore.instance.collection('users').get().then((value) {
        for (var element in value.docs) {
          if (element.data()['uId'] != user.currentUser!.uid) {
            allUsers.add(SocialUserModel.fromJson(element.data()));
          }
        }
        emit(SocialGetAllUserSuccessState());
      });
    } else {
      return;
    }
  }


}

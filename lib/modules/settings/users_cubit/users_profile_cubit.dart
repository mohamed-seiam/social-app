import 'package:bloc/bloc.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'users_profile_state.dart';

class UsersProfileCubit extends Cubit<UsersProfileState> {
  UsersProfileCubit() : super(UsersProfileInitial());
  static UsersProfileCubit get(context) => BlocProvider.of(context);

SocialUserModel ? specificUser;

  void getOtherUserData({required String otherUserId})  {
    emit(UsersProfileLoading());
    FirebaseFirestore.instance
        .collection('users')
        .doc(otherUserId)
        .get().asStream().listen((value) {
      specificUser = SocialUserModel.fromJson(value.data()!);
      emit(UsersProfileSuccess());
    });
    // }).catchError((error) {
    //   log(error.toString());
    //   emit(SocialGetUserErrorState(error.toString()));
    // });
  }
  final user = FirebaseAuth.instance;

  Future<void> followUser({required String userId}) async {
    final currentUser = user.currentUser!.uid;
    final userCollection = FirebaseFirestore.instance.collection('users');
    final followedUser = await userCollection.doc(userId).get();
    final followingUser = await userCollection.doc(currentUser).get();
    if (followedUser.exists) {
      List followers = followedUser.get('followers');
      final totalFollowers = followedUser.get('totalFollowers');
      if (followers.contains(currentUser)) {
        userCollection.doc(userId).update({
          'followers': FieldValue.arrayRemove([currentUser]),
          'totalFollowers': totalFollowers - 1,
        });
      } else {
        userCollection.doc(userId).update({
          'followers': FieldValue.arrayUnion([currentUser]),
          'totalFollowers': totalFollowers + 1,
        });
      }
    }
    List following = followingUser.get('following');
    final totalFollowing = followingUser.get('totalFollowing');
    if (following.contains(userId)) {
      userCollection.doc(currentUser).update({
        'following': FieldValue.arrayRemove([userId]),
        'totalFollowing': totalFollowing - 1,
      });
    } else {
      userCollection.doc(currentUser).update({
        'following': FieldValue.arrayUnion([userId]),
        'totalFollowing': totalFollowing + 1,
      });
    }
  }


}

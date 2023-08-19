import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app_flutter_firebase/layout/home/cubit/states.dart';
import 'package:social_app_flutter_firebase/models/user/user_model.dart';
import 'package:social_app_flutter_firebase/modules/new_post/new_post_screen.dart';
import 'package:social_app_flutter_firebase/modules/settings/settings_screen.dart';

import '../../../models/message/message_model.dart';
import '../../../models/post/post_model.dart';
import '../../../modules/chats/chats_screen.dart';
import '../../../modules/feeds/feeds_screen.dart';
import '../../../modules/search/search_screen.dart';
import '../../../modules/users/users_screen.dart';
import '../../../shared/components/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  UserModel? model;
  PostModel? postModel;
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var bioController = TextEditingController();
  var commentController = TextEditingController();
  var messageController = TextEditingController();
  File? imageProfileFile;
  File? imageCoverFile;

  void getUserData() {
    emit(HomeGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      model = UserModel.fromJson(value.data()!);
      emit(HomeGetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(HomeErrorState(error.toString()));
    });
  }

  void changeLength(int length) {
    if (length > 0)
      emit(HomeCommentSendState(length));

  }

  void changeToSend() {
    if (commentController.text.isNotEmpty) {
      emit(HomeCommentSendState(commentController.text.length));
    }
  }


  Future<void> getProfileFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      imageProfileFile = File(pickedFile.path);
      emit(HomeProfileImagePickedSuccessState());
    } else {
      print('No image selected');
      emit(HomeProfileImagePickedErrorState());
    }
  }

  Future<void> getCoverFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      imageCoverFile = File(pickedFile.path);
      emit(HomeCoverImagePickedSuccessState());
    } else {
      print('No image selected');
      emit(HomeCoverImagePickedErrorState());
    }
  }

  /// Get from camera
  Future<void> getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      imageProfileFile = File(pickedFile.path);
      emit(HomeProfileImagePickedSuccessState());
    } else {
      print('No image selected');
      emit(HomeProfileImagePickedErrorState());
    }
  }

  void uploadProfileImage({
    required String? name,
    required String? phone,
    required String? bio,
  }) {
    emit(HomeUserUpdateLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(imageProfileFile!.path).pathSegments.last}')
        .putFile(imageProfileFile!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print('url: $value');
        // emit(HomeUploadProfileImageSuccessState());
        updateUser(name: name, phone: phone, bio: bio, image: value);
      }).catchError((error) {
        print(error.toString());
        emit(HomeUploadProfileImageErrorState());
      });
    }).catchError((error) {
      print(error.toString());
      emit(HomeUploadProfileImageErrorState());
    });
  }

  void uploadCoverImage({
    required String? name,
    required String? phone,
    required String? bio,
  }) {
    emit(HomeUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(imageCoverFile!.path).pathSegments.last}')
        .putFile(imageCoverFile!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print('url: $value');
        // emit(HomeUploadCoverImageSuccessState());
        updateUser(name: name, phone: phone, bio: bio, cover: value);
      }).catchError((error) {
        print(error.toString());
        emit(HomeUploadCoverImageErrorState());
      });
    }).catchError((error) {
      print(error.toString());
      emit(HomeUploadCoverImageErrorState());
    });
  }

//   void updateUserImages({
//   required String? name,
//   required String? phone,
//     required String? bio,
// }){
//    emit(HomeUserUpdateLoadingState());
//
//     if(imageCoverFile !=null){
//       uploadCoverImage();
//
//     }
//     if(imageProfileFile !=null){
//      uploadProfileImage();
//     }else  if(imageCoverFile == null && imageProfileFile == null){
//       uploadCoverImage();
//       uploadProfileImage();
//
//     }
//
//
//     else {
//
//       updateUser(name: name, phone: phone, bio: bio);
//
//     }
//
//
//
//   }

  void updateUser({
    required String? name,
    required String? phone,
    required String? bio,
    String? cover,
    String? image,
  }) {
    UserModel userModel = UserModel(
      name: name!,
      phone: phone!,
      bio: bio!,
      image: image ?? model!.image,
      cover: cover ?? model!.cover,
      email: model!.email,
      uId: model!.uId,
      isEmailVerified: false,
    );

    FirebaseFirestore.instance.collection('users').doc(model!.uId).update({
      'name': userModel.name,
      'phone': userModel.phone,
      'bio': userModel.bio,
      'image': userModel.image,
      'cover': userModel.cover,
      'email': userModel.email,
      'uId': userModel.uId,
      'isEmailVerified': userModel.isEmailVerified,
    }).then((value) {
      getUserData();
    }).catchError((error) {
      print(error.toString());
      emit(HomeUserUpdateErrorState());
    });
  }

  int currentIndex = 0;

  List<Widget> screens = [
    FeedsScreen(),
    ChatsScreen(),
    NewPostScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];
  List<BottomNavigationBarItem> bottomItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.chat),
      label: 'Chats',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.post_add),
      label: 'Post',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.people),
      label: 'Users',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  List<String> titles = [
    'Feeds',
    'Chat',
    'New Post',
    'Users',
    'Settings',
  ];

  void changeBottomNav(int index) {
    // if(index==0){
    //   getPostsData();
    // }
    if (index == 1) {
      getAllUsers();
    }

    if (index == 2) {
      emit(HomeNewPostState());
    } else {
      currentIndex = index;
      emit(HomeChangeBottomNavBarState());
      getPostsData();

    }
  }

  File? imagePostFile;

  Future<void> getPostImageFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      imagePostFile = File(pickedFile.path);
      emit(HomePostImagePickedSuccessState());
    } else {
      print('No image selected');
      emit(HomePostImagePickedErrorState());
    }
  }

  void uploadPostImage({
    required String? text,
    required String? dateTime,
  }) {
    emit(HomeCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(imagePostFile!.path).pathSegments.last}')
        .putFile(imagePostFile!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print('url: $value');
        createPost(
          postImage: value,
          dateTime: dateTime!,
          text: text!,
        );
        emit(HomeCreatePostSuccessState());
        // getPostsData();
        // updateUser(name: name, phone: phone, bio: bio,cover: value);
      }).catchError((error) {
        print(error.toString());
        emit(HomeCreatePostErrorState());
      });
    }).catchError((error) {
      print(error.toString());
      emit(HomeCreatePostErrorState());
    });
  }

  void createPost({
    required String? text,
    required String? dateTime,
    String? postImage,
  }) {
    PostModel? postModel = PostModel(
      text: text!,
      dateTime: dateTime!,
      postImage: postImage ?? '',
      name: model!.name!,
      uId: model!.uId!,
      image: model!.image!,
    );

    FirebaseFirestore.instance.collection('posts').add({
      'name': postModel.name,
      'image': postModel.image,
      'uId': postModel.uId,
      'dateTime': postModel.dateTime,
      'text': postModel.text,
      'postImage': postModel.postImage
    }).then((value) {
      emit(HomeCreatePostSuccessState());
      // getPostsData();
    }).catchError((error) {
      print(error.toString());
      emit(HomeUserUpdateErrorState());
    });
  }

  void removePostImage() {
    imagePostFile = null;
    emit(HomeRemovePostImageState());
  }

  void checkImageInPost({dateTime, text, postImage}) {
    if (imagePostFile != null) {
      uploadPostImage(
        dateTime: dateTime!,
        text: text!,
      );
    } else if (imagePostFile == null) {
      createPost(
        dateTime: dateTime!,
        text: text!,
      );
    }
  }

  List<PostModel?> posts = [];
  List<UserModel?> users = [];
  List<String?> postsId = [];
  List<int> likes = [];
  List<int> commentsLength = [];

  void getPostsData() {
    emit(HomeGetPostsLoadingState());
    FirebaseFirestore.instance.collection('posts').orderBy('dateTime', descending: true).get().then((value) {
      posts=[];

      value.docs.forEach(
        (result) {

          postsId.add(result.id);
          posts.add(PostModel.fromJson(result.data(),),);
          //like
          result.reference.collection('likes').get().then((value) {

                    likes.add(value.docs.length);
                    emit(HomeGetPostsSuccessState());

              });
          //comment
          result.reference.collection('comments').doc(model!.uId).
          collection('${model!.uId}').get().then((value) {

                commentsLength.add(value.docs.length);
                emit(HomeGetPostsSuccessState());

          });

          emit(HomeGetPostsSuccessState());
          //

        },
      );
      emit(HomeGetPostsSuccessState());

    }).catchError((error) {
      print(error.toString());
      emit(HomeGetPostsErrorState(error.toString()));
    });
  }
  void getAllUsers() {
    emit(HomeGetAllUserLoadingState());

    if (users.length == 0)
    FirebaseFirestore.instance.collection('users').get().then((value) {
      users=[];
      value.docs.forEach(
        (result) {
          if(result.data()['uId']!=model!.uId)
          users.add(UserModel.fromJson(result.data(),),);

        },
      );
      emit(HomeGetAllUserSuccessState());

    }).catchError((error) {
      print(error.toString());
      emit(HomeGetAllUserErrorState(error.toString()));
    });
  }


  void sendMessage({
    required String? text,
    required String? dateTime,
    required String? recieverId,
  }) {
    MessageModel? messageModel = MessageModel(
      text: text!,
      dateTime: dateTime!,
      receiverId: recieverId,
      senderId: model!.uId,
    );
    // send message from me
    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uId)
        .collection('chats')
        .doc(recieverId)
        .collection('messages')
        .add({
      'text': messageModel.text,
      'dateTime': messageModel.dateTime,
      'senderId': messageModel.senderId,
      'receiverId': messageModel.receiverId,
    }).then((value) {
      emit(HomeSendMessageSuccessState());
      messageController.clear();
    }).catchError((error) {
      print(error.toString());
      emit(HomeSendMessageErrorState(error.toString()));
    });

    //set message to reciever
    FirebaseFirestore.instance
        .collection('users')
        .doc(recieverId)
        .collection('chats')
        .doc(model!.uId)
        .collection('messages')
        .add({
      'text': messageModel.text,
      'dateTime': messageModel.dateTime,
      'senderId': messageModel.senderId,
      'receiverId': messageModel.receiverId,
    }).then((value) {
      emit(HomeSendMessageSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(HomeSendMessageErrorState(error.toString()));
    });


  }

List <MessageModel> messages=[];

  void getMessages({
    required String? recieverId,
}){

    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uId)
        .collection('chats')
        .doc(recieverId)
        .collection('messages')
        .orderBy('dateTime').limit(50)
        .snapshots().listen((event) {
      messages=[];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(HomeGetMessagesSuccessState());
    });


  }

  bool buttonClicked = false;

  void likePost(postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(model!.uId)
        .set({
      'like': true,
    }).then((value) {
          emit(HomeLikePostSuccessState());
          likes[postsId.indexOf(postId)]=likes[postsId.indexOf(postId)]! + 1;

    }).catchError((error) {
      print(error.toString());
      emit(HomeLikePostErrorState(error.toString()));
    });
  }
  // String? postId;
  IconData? suffix  =   Icons.favorite_border ;

//   Future<bool> checkLikePost(postId) async {
//   var checkLikes = await FirebaseFirestore.instance.collection('posts').doc(postId).collection('likes').doc(model!.uId).get();
//    emit(HomeCheckLikePostState());
//
//    return checkLikes!.data()?['like'] ??false;
//
//
// }
// Future<void> fetchLikeStatus(String postId,UserModel? model) async {
//   try {
//     DocumentSnapshot likeSnapshot = await FirebaseFirestore.instance
//         .collection('posts')
//         .doc(postId)
//         .collection('likes')
//         .doc(model!.uId)
//         .get();
//
//     if (likeSnapshot.exists) {
//       // 'liked' field is assumed to be a boolean field in the document
//       bool userLiked = likeSnapshot.data()!['like'];
//         // userLikedPost = userLiked;
//
//     } else {
//         // userLikedPost = false; // User hasn't liked the post
//
//     }
//   } catch (e) {
//     print("Error fetching like status: $e");
//   }
// }



  void likeOrDislikePost(postId) {
    if (buttonClicked == false) {
      buttonClicked = true;
      likePost(postId);
      // emit(HomeLikePostSuccessState());
    } else {
      buttonClicked = false;
      unLikePost(postId);
      // emit(HomeDisLikePostSuccessState());
    }
  }


  // void changeLikeOrDisLikePostColor(postId) {
  //   _buttonClicked = !_buttonClicked;
  //   suffix =
  //    _buttonClicked ? Icons.favorite_border : Icons.favorite;
  //   emit(HomeChangeLikeColorState());
  // }


  void unLikePost(postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(model!.uId)
        .update({
      'like': false,
        })
        .then((value) {
        emit(HomeDisLikePostSuccessState());
        likes[postsId.indexOf(postId)]=likes[postsId.indexOf(postId)] - 1;

      // getPostsData();
    })
        .catchError((error) {
      print(error.toString());
      emit(HomeDisLikePostErrorState(error.toString()));
    });


  }
  void commentPost(postId,comment) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(model!.uId)
        .set({
      'comment': comment,
    }).then((value) {
      emit(HomeCommentPostSuccessState());
      commentsLength[postsId.indexOf(postId)]=commentsLength[postsId.indexOf(postId)] + 1;

      // getPostsData();
    }).catchError((error) {
      print(error.toString());
      emit(HomeCommentPostErrorState(error.toString()));
    });
  }

}

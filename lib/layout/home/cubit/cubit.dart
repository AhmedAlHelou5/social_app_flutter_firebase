import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app_flutter_firebase/layout/home/cubit/states.dart';
import 'package:social_app_flutter_firebase/models/post/comment_model.dart';
import 'package:social_app_flutter_firebase/models/user/user_model.dart';
import 'package:social_app_flutter_firebase/modules/new_post/new_post_screen.dart';
import 'package:social_app_flutter_firebase/modules/settings/settings_screen.dart';

import '../../../models/followers/follow_model.dart';
import '../../../models/message/message_model.dart';
import '../../../models/post/like_model.dart';
import '../../../models/post/post_model.dart';
import '../../../modules/chats/chats_screen.dart';
import '../../../modules/feeds/feeds_screen.dart';
import '../../../modules/search/search_screen.dart';
import '../../../modules/users/users_screen.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  UserModel? model;
  PostModel? postModel;
  CommentModel? commentModel;
  LikeModel? likeModel;
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var bioController = TextEditingController();
  var commentController = TextEditingController();
  var messageController = TextEditingController();
  File? imageProfileFile;
  File? imageCoverFile;
  List<dynamic>search = [];

  void getUserData() {
    emit(HomeGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      model = UserModel.fromJson(value.data()!) as dynamic;
      emit(HomeGetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(HomeErrorState(error.toString()));
    });
  }




  void getSearchPostsData(String textSearch) {
    emit(HomeSearchLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((value) {
      search = [];
      // comments=[];
          print('value.docs : ${value.docs}');
      value.docs.forEach(
            (result) {
      if (result.data()['text'].toLowerCase().contains(textSearch.toLowerCase())
          || result.data()['name'].toLowerCase().contains(textSearch.toLowerCase())
      )
          // postsId.add(result.id);

            search.add(
            PostModel.fromJson(
              result.data(),
            ),

          );

          // print(result.data());


          emit(HomeSearchSuccessState());
          //
        },
      );
    });
  }





  // bool isFollow = false;
  void changeFollowButton() {
    isFollowing  =! isFollowing;
    print(isFollowing);
    emit(HomeChangeButtonFollowState());
  }


  void changeLength(int length) {
    if (length > 0) emit(HomeCommentSendState(length));
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




  void getUser({id}){
    FirebaseFirestore.instance.collection('users').doc(id).get().then((value) {
      model = UserModel.fromJson(value.data()!);
      emit(HomeGetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(HomeErrorState(error.toString()));
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
        getPostsData();
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
      comments: [],
      likes: [],
    );

    FirebaseFirestore.instance.collection('posts').add({
      'name': postModel.name,
      'image': postModel.image,
      'uId': postModel.uId,
      'dateTime': postModel.dateTime,
      'text': postModel.text,
      'postImage': postModel.postImage,
      'comments': [],
      'likes': []
    }).then((value) {
      emit(HomeCreatePostSuccessState());
      getPostsData();
    }).catchError((error) {
      print(error.toString());
      emit(HomeUserUpdateErrorState());
    });

    // FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(model!.uId)
    //     .collection('posts')
    //     .add({
    //   'name': postModel!.name,
    //   'image': postModel!.image,
    //   'uId': postModel!.uId,
    //   'dateTime': postModel!.dateTime,
    //   'text': postModel!.text,
    //   'postImage': postModel!.postImage,
    //   'comments': [],
    //   'likes': []
    // }).then((value) {
    //   emit(HomeCreatePostSuccessState());
    //   // getPostsData();
    // }).catchError((error) {
    //   print(error.toString());
    //   emit(HomeUserUpdateErrorState());
    // });
  }




  // void followUser({
  //    String? id,
  //    String? name,
  //   String? image,
  // }) {
  //   FollowModel? postModel = FollowModel(
  //     followers: [],
  //     following: [],
  //   );
  //
  //   FirebaseFirestore.instance.collection('follow').doc(model!.uId).add({
  //     'followers': [],
  //     'following': []
  //   }).then((value) {
  //     emit(HomeCreatePostSuccessState());
  //   }).catchError((error) {
  //     print(error.toString());
  //     emit(HomeUserUpdateErrorState());
  //   });
  //
  //
  // }







  List<PostModel?> posts = [];
  // List<dynamic> comments = [];
  List<UserModel> users = [];
  List<String?> postsId = [];

  // List<int> likes = [];
  List<PostModel?> postsForUser = [];
  List<PostModel?> postsForSettings = [];

  void commentPost({
    required String? text,
    required String? dateTime,
    required String? postId,
    required String? image,
    required String? name,
  }) {
    CommentModel commentModel = CommentModel(
      text: text!,
      dateTime: dateTime!,
      name: name,
      uId: uId,
      image: image,
      postId: postId,
    );

    FirebaseFirestore.instance.collection('posts').doc(postId).update({
      'comments': FieldValue.arrayUnion([commentModel.toMap()])
    }).then((value) {
      getPostsData();
      emit(HomeCommentPostSuccessState());

      // getPostsData();
    }).catchError((error) {
      print(error.toString());
      emit(HomeCommentPostErrorState(error.toString()));
    });
  }












  void removePostImage() {
    imagePostFile = null;
    emit(HomeRemovePostImageState());
  }

  void checkImageInPost({
    dateTime,
    text,
    postImage,
  }) {
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




  void getPostsData() {
    emit(HomeGetPostsLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime', descending: true)
        .get()
        .then((value) {
      posts = [];
      // comments=[];

      value.docs.forEach(
        (result) {
          postsId.add(result.id);
          posts.add(
            PostModel.fromJson(
              result.data(),
            ),

          );

          print(result.data());


          emit(HomeGetPostsSuccessState());
          //
        },
      );
    }).catchError((error) {
      print(error.toString());
      emit(HomeGetPostsErrorState(error.toString()));
    });
  }









  void getPostForSettings() {
    emit(HomeGetPostsLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime', descending: true)
        .get()
        .then((value) {
      posts = [];
      postsForSettings = [];

      value.docs.forEach(
        (result) {
          postsId.add(result.id);
          posts.add(
            PostModel.fromJson(
              result.data(),
            ),
          );
          //like
          postsForSettings = [];

          posts.forEach((element) {
            if (element!.uId == uId) {
              postsForSettings.add(element);
            }
          });
        },
      );
      emit(HomeGetPostsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(HomeGetPostsErrorState(error.toString()));
    });
  }

  void getPostForUser(id) {
    emit(HomeGetPostsLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime', descending: true)
        .get()
        .then((value) {
      posts = [];
      postsForUser = [];

      value.docs.forEach(
        (result) {
          postsId.add(result.id);
          posts.add(
            PostModel.fromJson(
              result.data(),
            ),
          );
          //like
          postsForUser = [];

          posts.forEach((element) {
            if (element!.uId == id) {
              postsForUser.add(element);
            }
            emit(HomeGetPostsSuccessState());
          });
        },
      );
    }).catchError((error) {
      print(error.toString());
      emit(HomeGetPostsErrorState(error.toString()));
    });
  }

  void getAllUsers() {
    emit(HomeGetAllUserLoadingState());
    // users = [];

    if (users.length == 0)
    FirebaseFirestore.instance.collection('users').get().then((value) {
      value.docs.forEach(
        (result) {
          if (result.data()['uId'] != model!.uId)
            users.add(
              UserModel.fromJson(
                result.data(),
              ),

            );
          print('getalluser////////////: ${users}');

        },
      );
      print('getalluser////////////: ${users}');
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

  List<MessageModel> messages = [];

  void getMessages({
    required String? recieverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uId)
        .collection('chats')
        .doc(recieverId)
        .collection('messages')
        .orderBy('dateTime')
        .limit(50)
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(HomeGetMessagesSuccessState());
    });
  }

  bool buttonClicked = false;

  void likePost({
    required String? postId,
    required String? image,
    required String? uId,
    required String? name,
  }) {
    LikeModel likeModel = LikeModel(
      name: name,
      uId: uId,
      image: image,
      postId: postId,
    );

      FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayUnion([likeModel.toMap()])
      }).then((value) {

        buttonClicked=!buttonClicked;
        getPostsData();
        emit(HomeLikePostSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(HomeLikePostErrorState(error.toString()));
      });

  }


  void DislikePost({
    required String? postId,
    required String? image,
    required String? uId,
    required String? name,
  }) {
    LikeModel likeModel = LikeModel(
      name: name,
      uId: uId,
      image: image,
      postId: postId,
    );

    FirebaseFirestore.instance.collection('posts').doc(postId).update({
      'likes': FieldValue.arrayRemove([likeModel.toMap()]) // if(likeModel==0)
    }).then((value) {

      buttonClicked=!buttonClicked;
      getPostsData();
      emit(HomeDisLikePostSuccessState());

      // getPostsData();
    }).catchError((error) {
      print(error.toString());
      emit(HomeDisLikePostErrorState(error.toString()));
    });
  }

  // IconData? suffix = Icons.favorite_border;



  // void followUser(id) {
  //   FollowModel followModel = FollowModel(
  //     uId: model!.uId
  //   );
  //
  //   print(followModel.toString());
  //
  //     FirebaseFirestore.instance.collection('follow').doc(id).set({
  //       'followers': FieldValue.arrayUnion([followModel.toMap()]),
  //     }).then((value) {
  //       emit(HomeFollowUserSuccessState());
  //       getFollowerForUser(id);
  //
  //     }).catchError((error) {
  //       print(error.toString());
  //       emit(HomeFollowUserErrorState(error.toString()));
  //     });
  //
  //
  //     FirebaseFirestore.instance.collection('follow').doc(uId).set({
  //       'following': FieldValue.arrayUnion([id]),
  //
  //     }).then((value) {
  //       // buttonClicked=!buttonClicked;
  //       getFollowerForUser(uId);
  //       emit(HomeFollowUserSuccessState());
  //
  //       // getPostsData();
  //     }).catchError((error) {
  //       print(error.toString());
  //       emit(HomeFollowUserErrorState(error.toString()));
  //     });
  //
  //
  //
  //
  //
  //
  //
  // }


  //
  //
  // void unFollowUser(id) {
  //   FollowModel unFollowModel = FollowModel(
  //     uId: model!.uId
  //   );
  //   print(unFollowModel.toString());
  //
  //   FirebaseFirestore.instance.collection('follow').doc(id).set({
  //     'followers': FieldValue.arrayRemove([unFollowModel.toMap()]),
  //
  //   }).then((value) {
  //     emit(HomeFollowUserSuccessState());
  //     getFollowerForUser(id);
  //
  //   }).catchError((error) {
  //     print(error.toString());
  //     emit(HomeUnFollowUserErrorState(error.toString()));
  //   });
  //
  //
  //   FirebaseFirestore.instance.collection('follow').doc(uId).set({
  //     'following': FieldValue.arrayRemove([id]),
  //
  //   }).then((value) {
  //     // buttonClicked=!buttonClicked;
  //     getFollowerForUser(id);
  //     emit(HomeFollowUserSuccessState());
  //
  //     // getPostsData();
  //   }).catchError((error) {
  //     print(error.toString());
  //     emit(HomeUnFollowUserErrorState(error.toString()));
  //   });
  //
  //
  //
  //
  // }

  void followUser({String? uid, String? followId})  {
      FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) {
        List following = [];
        value.data()!['following'].forEach((dynamic element) {
          following.add(element! as dynamic );
          print(' /////////////////following ::: $following' );


        } );
        if (!following.contains(followId)) {
          FirebaseFirestore.instance.collection('users').doc(followId).update({
            'followers': FieldValue.arrayUnion([uid])
          });

          FirebaseFirestore.instance.collection('users').doc(uid).update({
            'following': FieldValue.arrayUnion([followId])
          });

          emit(HomeFollowUserSuccessState());
          // emit(HomeInitialState());
          // getFollowerForUser(followId);
          // getFollowerForUser(uid);
        } else {
          FirebaseFirestore.instance.collection('users').doc(followId).update({
            'followers': FieldValue.arrayRemove([uid])
          });

          FirebaseFirestore.instance.collection('users').doc(uid).update({
            'following': FieldValue.arrayRemove([followId])
          });
          // getFollowerForUser(uid);
          // getFollowerForUser(followId);
          // emit(HomeInitialState());

          emit(HomeUnFollowUserSuccessState());
          // getFollowerForUser(followId);
          // getFollowerForUser(uid);
        }

        getFollowerForUser(uid);

      }).catchError((e) {
        print(e.toString());
        emit(HomeFollowUserErrorState(e.toString()));
      });

  }


  dynamic followers  ;
  dynamic following ;
  bool isFollowing = false;

  void getFollowerForUser(id) {
    emit(HomeGetFollowersLoadingState());
    followers = [] ;
    following = [];
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .get().then((value) {
      value!.data()!['followers'].forEach((dynamic element) {
        print(element);
        followers!.add(element! as dynamic );



      } );
      value!.data()!['following']!.forEach(( dynamic element) {
        print(element);
        following!.add(element! as dynamic );
        print('followers: ${followers}');
        print('following: $following');

      } );
    //
    // followers = value.data()!['followers'];
    // following = value.data()!['following'];
    print('followers: $followers');
    print('following: $following');
    isFollowing = followers
        .contains(uId);

    print(followers.toString());

  });


}
}

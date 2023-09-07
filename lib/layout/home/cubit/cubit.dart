import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app_flutter_firebase/layout/home/cubit/states.dart';
import 'package:social_app_flutter_firebase/models/followers/following_model.dart';
import 'package:social_app_flutter_firebase/models/post/comment_model.dart';
import 'package:social_app_flutter_firebase/models/user/user_model.dart';
import 'package:social_app_flutter_firebase/modules/new_post/new_post_screen.dart';
import 'package:social_app_flutter_firebase/modules/settings/settings_screen.dart';
import 'package:uuid/uuid.dart';

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

import '../home_layout.dart';

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
  List<dynamic> search = [];

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

  String dropdownvalue = 'save post';

  var itemsMenu = [
    // 'edit post',
    'save post',
    'delete post',
  ];



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
          if (result
                  .data()['text']
                  .toLowerCase()
                  .contains(textSearch.toLowerCase()) ||
              result
                  .data()['name']
                  .toLowerCase()
                  .contains(textSearch.toLowerCase()))
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
      savePost: model!.savePost,
      following: model!.following,
      followers: model!.followers,
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
      'savePost': userModel.savePost,
      'following': userModel.following,
      'followers': userModel.followers,
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
    if (index == 1 || index == 3) {
      getAllUsers();
    }
    if (index == 4) {
      getUserData();
    }
    if (index == 2) {
      emit(HomeNewPostState());
    } else {
      currentIndex = index;
      emit(HomeChangeBottomNavBarState());
      getPostsData();
      getPostForSettings();
      getAllUsersWithMe();

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
        getPostsData();

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
    String? postId = Uuid().v1();

    PostModel? postModel = PostModel(
      text: text!,
      dateTime: dateTime!,
      postId: postId,
      postImage: postImage ?? '',
      name: model!.name!,
      uId: model!.uId!,
      image: model!.image!,
      comments: [],
      likes: [],
    );

    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .set(postModel.toMap())
        .then((value) {
      getPostsData();

      emit(HomeCreatePostSuccessState());
      getPostsData();
    }).catchError((error) {
      print(error.toString());
      emit(HomeUserUpdateErrorState());
    });
    getPostsData();
  }

  List<UserModel?> users = [];

  List<PostModel?> postsForUser = [];
  List<PostModel?> postsForSettings = [];
  List<PostModel?> postsForSaves = [];

  void commentPost({
    required String? text,
    required String? dateTime,
    required String? postId,
    required String? image,
    required String? name,
    String? id2,
  }) {
    String? commentId = Uuid().v1();
    CommentModel commentModel = CommentModel(
      text: text!,
      dateTime: dateTime!,
      name: name,
      uId: uId,
      image: image,
      commentId: commentId,
    );

    FirebaseFirestore.instance.collection('posts').doc(postId).update({
      'comments': FieldValue.arrayUnion([commentModel.toMap()])
    }).then((value) {
      getPostsData();
      // getPostsById(postId);
      emit(HomeCommentPostSuccessState());

      // getPostsData();
    }).catchError((error) {
      print(error.toString());
      emit(HomeCommentPostErrorState(error.toString()));
    });
    getPostForSettings();
    // getPostForUser(id2);
    getPostsData();
  }

  void removePostImage() {
    imagePostFile = null;
    emit(HomeRemovePostImageState());
  }

  void checkImageInPost({
    dateTime,
    text,
    postImage,
    context,
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
    navigateAndFinish(context, HomeLayout());
    emit(HomeGetPostsSuccessState());
  }
  List<String?> postsId = [];
  List<PostModel?> posts = [];
  void getPostsData() {
    emit(HomeGetPostsLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime', descending: true)
        .get()
        .then((value) {
      posts = [];
      postsId = [];
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
          // postsId.add(result.id);
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
    getPostsData();
  }

  void getPostForViewProfile(model) {
    emit(HomeGetPostsForUserLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime', descending: true)
        .get()
        .then((value) {
      posts = [];
      postsForUser = [];
      // postsId = [];

      value.docs.forEach(
        (result) {
          // postsId.add(result.id);
          posts.add(
            PostModel.fromJson(
              result.data(),
            ),
          );
          //like
          postsForUser = [];

          posts.forEach((element) {
            if (element!.uId == model!.uId) {
              // postsForUser = [];
              postsForUser.add(element);
            }
          });
        },
      );
      emit(HomeGetPostsForUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(HomeGetPostsForUserErrorState(error.toString()));
    });
    getPostsData();
  }




  void getAllUsers() {
    emit(HomeGetAllUserLoadingState());
    users = [];

    // if (users.length == 0)
    FirebaseFirestore.instance.collection('users').get().then((value) {
      value.docs.forEach(
        (result) {
          if (result.data()['uId'] != uId)
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

  List<dynamic?> usersWithMe = [];

  void getAllUsersWithMe() {
    emit(HomeGetAllUserLoadingState());
    usersWithMe = [];

    // if (users.length == 0)
    FirebaseFirestore.instance.collection('users').get().then((value) {
      value.docs.forEach(
            (result) {
            usersWithMe.add(
              UserModel.fromJson(
                result.data(),
              ),
            );
          print('getalluser////////////: ${usersWithMe}');
        },
      );
      print('getalluser////////////: ${usersWithMe}');
      emit(HomeGetAllUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(HomeGetAllUserErrorState(error.toString()));
    });
  }






  void sendMessage({
    required String? text,
    required Timestamp? dateTime,
    required String? recieverId,
  }) {
    MessageModel? messageModel = MessageModel(
      text: text!,
      dateTime: dateTime!.toString(),
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
  bool? isMe;

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
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));


        print('messages : ${messages}');
        print('messages element : ${element}');
      });
      emit(HomeGetMessagesSuccessState());
    });
  }







  bool buttonClicked = false;

  void changeLikeButton() {
    buttonClicked = !buttonClicked;

    emit(HomeCheckLikePostState());
  }

  void changeSaveButton() {
    isSavePost = !isSavePost!;

    emit(HomeCheckSavePostState());
  }

  bool? isSavePost = false;


  void SavePost({postId}) {

    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      List saves = [];

      value.data()!['savePost'].forEach((element) {
        saves.add(element);
        print(' /////////////////likes ::: $saves');
      });
      if (!saves.contains(postId)) {
        FirebaseFirestore.instance.collection('users').doc(uId).update({
          'savePost': FieldValue.arrayUnion([postId])
        });
        // getSavePost();
        emit(HomeSavePostSuccessState());
        getSavePost();

      } else {
        FirebaseFirestore.instance.collection('users').doc(uId).update({
          'savePost': FieldValue.arrayRemove([postId])
        });
        emit(HomeUnSavePostSuccessState());
        getSavePost();

        // changeSaveButton();
      }
      isSavePost = value.data()!['savePost'].contains(postId) ? true : false;
      getSavePost();
    }).catchError((e) {
      print(e.toString());
      emit(HomeSavePostErrorState(e.toString()));
    });
    // getSavePost();
    // changeLikeButton();
    // buttonClicked=!buttonClicked;
  }







  void likePost(
      {  postId,}) {
      // emit(HomeFollowUserLoadingState());

      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .get()
          .then((value) {
        List likesList= [];
        value.data()!['likes'].forEach((element) {
          likesList.add(element!);
          print(' /////////////////likes ::: $likesList');
        });

        if (!likesList.contains(uId)) {
          FirebaseFirestore.instance.collection('posts').doc(postId).update({
            'likes': FieldValue.arrayUnion([uId])
          });
          getPostsData();

          emit(HomeLikePostSuccessState());
        }else {
          FirebaseFirestore.instance.collection('posts').doc(postId).update({
            'likes': FieldValue.arrayRemove([uId]),
          });
          getPostsData();
          emit(HomeDisLikePostSuccessState());}
        buttonClicked = likesList.contains( uId) ? true : false;
          emit(HomeDisLikePostSuccessState());
      }).catchError((e) {
        print(e.toString());
        emit(HomeFollowUserErrorState(e.toString()));
      });

  }











  void followUser(
      {String? uid,
      String? followId,
      String? image,
      String? image2,
      String? name,
      String? name2}) {
    {
      // emit(HomeFollowUserLoadingState());


      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get()
          .then((value) {
        List following = [];
        value.data()!['following'].forEach((element) {
          following.add(element!);
          print(' /////////////////following ::: $following');
        });

        if (!following.contains(followId)) {
          FirebaseFirestore.instance.collection('users').doc(followId).update({
            'followers': FieldValue.arrayUnion([uid])
          });

          FirebaseFirestore.instance.collection('users').doc(uid).update({
            'following': FieldValue.arrayUnion([followId])
          });
          emit(HomeFollowUserSuccessState());
        } else {
          FirebaseFirestore.instance.collection('users').doc(followId).update({
            'followers': FieldValue.arrayRemove([uid]),
          });

          FirebaseFirestore.instance.collection('users').doc(uid).update({
            'following': FieldValue.arrayRemove([followId]),
          });

          emit(HomeUnFollowUserSuccessState());

        }

        getFollowerForUser(followId);
      }).catchError((e) {
        print(e.toString());
        emit(HomeFollowUserErrorState(e.toString()));
      });
    }
  }

  dynamic followers;

  dynamic following;

  bool? isFollowing = false;

  void getFollowerForUser(id) {
    followers = [];
    following = [];
    emit(HomeGetFollowersLoadingState());

    FirebaseFirestore.instance.collection('users').doc(id).get().then((value) {
      followers = value.data()!['followers'];
      following = value.data()!['following'];

      isFollowing = value.data()!['followers'].contains(uId) ? true : false;

      print('followers: $followers');
      print('following: $following');

      emit(HomeGetFollowersSuccessState());
      print(followers.toString());
    });
  }

  void changeFollowButton() {
    isFollowing = !isFollowing!;
    // getFollowerForUser(id);
    print(isFollowing);
    emit(HomeChangeButtonFollowState());
  }

  void deletePost({required String? postId}) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .delete()
        .then((value) {
      getPostsData();
      print('deleted');

      emit(HomeDeletePostSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(HomeDeletePostErrorState(error.toString()));
    });
  }


  dynamic postsSave = [];

  void getPostsById(postId) {
    postsSave = [];
    emit(HomeGetPostsByIdLoadingState());
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        if (element['postId'] == postId)
          postsSave.add(PostModel.fromJson(element.data()));
      });
      emit(HomeGetPostsByIdSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(HomeGetPostsByIdErrorState(error.toString()));
    });
  }




  List<dynamic?> postSave = [];
  List<String?> postsSaveId = [];
  // List<PostModel?> posts = [];


  void getSavePost(){
    emit(HomeGetSavePostLoadingState());
    getPostsData();
    postSave=[];
    postsSaveId=[];


    FirebaseFirestore.instance
        .collection('users')
        .where('uId', isEqualTo: uId)
        .get().then((value) =>
        value.docs.forEach((element) {
          postSave=[];

          element.data()!['savePost'].forEach((element) {
            postsSaveId.add(element);
            // postsSave=[];


              posts.forEach((post) {
                if(post!.postId==element)
                  postSave.add(post);
                print('/////////////////////////postSave ::: $postSave');
                print('/////////////////////////element ::: $element');});




            // getPostsData();

            // postSave.add(PostModel.fromJson(element));
          });
        })
    ).catchError((error) {
      print(error.toString());
      emit(HomeGetSavePostErrorState(error.toString()));


    });
    print('/////////////////////////postsSaveId ::: $postsSaveId');
    // getPostsData();


  }

  List<dynamic?> postLikes = [];
  List<String?> postsLikeId = [];
  // List<PostModel?> posts = [];


  // void getLikesPost({postId}){
  //   emit(HomeGetLikesPostLoadingState());
  //   getAllUsersWithMe();
  //   getPostsData();
  //   postLikes=[];
  //
  //   FirebaseFirestore.instance
  //       .collection('posts')
  //       .doc(postId)
  //       // .where('postId', isEqualTo:postId)
  //       .get().then((value) =>
  //       value.data()!['likes'].forEach((element) {
  //         usersWithMe.forEach(( id) {
  //             if(element==id!.uId)
  //               postLikes.add(
  //                 id!,
  //               );
  //           });
  //
  //           print('element.data()![likes] ::: ${value.data()!['likes']}');
  //
  //           print('postLikes ::: $postLikes');
  //           print('element ::: ${element}');
  //           getPostsData();
  //
  //           // postSave.add(PostModel.fromJson(element));
  //       })
  //   ).catchError((error) {
  //     print(error.toString());
  //     emit(HomeGetLikesPostErrorState(error.toString()));
  //
  //
  //   });
  //   print('/////////////////////////postLikes ::: $postLikes');
  //   // getPostsData();
  //
  //
  // }

  void getLikesPost({postId}){
    emit(HomeGetSavePostLoadingState());
    getPostsData();
    getAllUsersWithMe();
    postLikes=[];
    postsLikeId=[];
    usersWithMe=[];

    FirebaseFirestore.instance
        .collection('posts')
        .where('postId', isEqualTo: postId)
         // .orderBy('likes', descending: true)
        .get().then((value) =>
        value.docs.forEach((element) {
          postLikes=[];
          postsLikeId=[];


          element.data()!['likes'].forEach((element) {

            postsLikeId.add(element);


            // postsLikeId.forEach((element) {
              usersWithMe.forEach(( userId) {

                if(element==userId!.uId)
                  postLikes.add(
                    userId!,
                  );
              // });
              print('/////////////////////////postLikes ::: $postLikes');
              print('/////////////////////////element postLikes::: $element');

          });
          });

        emit(HomeGetLikesPostSuccessState());

        })



    ).catchError((error) {
      print(error.toString());
      emit(HomeGetSavePostErrorState(error.toString()));


    });
    print('/////////////////////////postsSaveId ::: $postsSaveId');
    // getPostsData();


  }













}

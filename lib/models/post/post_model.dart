import 'package:social_app_flutter_firebase/models/post/like_model.dart';
import 'package:social_app_flutter_firebase/models/user/user_model.dart';

import 'comment_model.dart';

class PostModel {
  String? uId;
  String? postId;
  String? name;
  String? dateTime;
  String? image;
  String? text;
  String? postImage;
  List<dynamic>? comments;
  dynamic likes;

  PostModel({
         this.uId,
         this.postId,
         this.name,
        this.image,
        this.dateTime,
        this.text,
        this.postImage,
      this.comments,
      this.likes,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    var commentList = json['comments'] ;
    var likesList = json['likes'] ;
    // var likeList = json['likes'];
    uId = json['uId'];
    postId = json['postId'];
    name = json['name'];
    text = json['text'];
    postImage = json['postImage'];
    image = json['image'];
    dateTime = json['dateTime'];
    comments =commentList.map((i) => CommentModel.fromJson(i)).toList();
    // likes =likesList.map((i) => UserModel.fromJson(i)).toList();

    likes = json['likes'];
    // likes =likeList.map((i) => LikeModel.fromJson(i)).toList();

  }

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'postId': postId,
      'name': name,
      'text': text,
      'postImage': postImage,
      'image': image,
      'dateTime': dateTime,
      'comments': comments,
      'likes': likes,
    };
  }
}

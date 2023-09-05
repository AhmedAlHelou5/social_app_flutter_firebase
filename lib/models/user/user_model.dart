import 'package:social_app_flutter_firebase/models/post/post_model.dart';

class UserModel {
  String? uId;
  String? name;
  String? email;
  String? phone;
  String? image;
  String? cover;
  String? bio;
  bool? isEmailVerified;
   List<dynamic>? followers;
   List<dynamic>? following;
   List<dynamic>? savePost;

  UserModel(
      { this.uId,
       this.name,
       this.email,
       this.phone,
      this.image,
      this.cover,
      this.bio,
      this.isEmailVerified,
      this.followers,
      this.following,
      this.savePost
      });

  UserModel.fromJson(Map<String, dynamic> json) {
    var followersList = json['followers'];
    var savePostList = json['savePost'];
    uId = json['uId'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    cover = json['cover'];
    bio = json['bio'];
    isEmailVerified = json['isEmailVerified'];
    followers = json['followers'];
    following = json['following'];
    savePost = json['savePost'];
    // savePost =savePostList.map((i) => PostModel.fromJson(i)).toList();

    // following = json['following'];
    // likes =  likes =likeList.map((i) => LikeModel.fromJson(i)).toList();

  }

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'name': name,
      'email': email,
      'phone': phone,
      'image': image,
      'cover': cover,
      'bio': bio,
      'isEmailVerified': isEmailVerified,
      'followers': followers,
      'following': following,
      'savePost': savePost,
    };
  }
}

import 'package:social_app_flutter_firebase/models/user/user_model.dart';

class FollowModel {
  String? uId;
  // List<UserModel>? followers;
  // List<UserModel>? following;



  FollowModel({
    this.uId,
    // this.followers,
    // this.following,


  });

  FollowModel.fromJson(Map<String, dynamic> json) {
     uId = json['uId'] ;
    // var followersList = json['followers'] ;
    // var followingList = json['following'];
    // followers =followersList.map((i) => UserModel.fromJson(i)).toList();
    // following = followingList.map((i) => UserModel.fromJson(i)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      // 'followers': followers,
      // 'following': following,

    };
  }
}

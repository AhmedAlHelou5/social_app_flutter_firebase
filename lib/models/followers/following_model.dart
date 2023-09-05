import 'package:social_app_flutter_firebase/models/user/user_model.dart';

class FollowingModel {
  String? uId;
  String? name;
  String? image;

  FollowingModel({
    this.uId,
    this.name,
    this.image,



  });

  FollowingModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'] ;
    name = json['name'] ;
    image = json['image'] ;

  }

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'name': name,
      'image': image,

    };
  }
}

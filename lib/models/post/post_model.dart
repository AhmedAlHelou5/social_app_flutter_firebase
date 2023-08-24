import 'comment_model.dart';

class PostModel {
  String? uId;
  String? name;
  String? dateTime;
  String? image;
  String? text;
  String? postImage;
  List<dynamic> comments=[];
  List<dynamic> likes=[];

  PostModel({
         this.uId,
         this.name,
        this.image,
        this.dateTime,
        this.text,
        this.postImage,
     required this.comments,
     required this.likes,
  });

  PostModel.fromJson(Map<dynamic, dynamic> json) {
    uId = json['uId'];
    name = json['name'];
    text = json['text'];
    postImage = json['postImage'];
    image = json['image'];
    dateTime = json['dateTime'];
    comments = json['comments'];
    likes = json['likes'];

  }

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
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

class LikeModel {
  String? uId;
  String? name;
  String? image;
  String? postId;


  LikeModel({
    this.uId,
    this.name,
    this.image,
    this.postId,


  });

  LikeModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    name = json['name'];
    image = json['image'];
    postId = json['postId'];

  }

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'name': name,
      'image': image,
      'postId': postId,

    };
  }
}

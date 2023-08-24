class LikeModel {
  String? uId;
  String? postId;
  String? name;
  String? image;
  bool? isLike;

  LikeModel({
    this.uId,
    this.postId,
    this.name,
    this.image,
    this.isLike,

  });

  LikeModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    postId = json['postId'];
    name = json['name'];
    image = json['image'];
    isLike = json['isLike'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'postId': postId,
      'name': name,
      'isLike': isLike,
      'image': image,
    };
  }
}

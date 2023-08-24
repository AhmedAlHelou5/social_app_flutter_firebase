class CommentModel {
  String? uId;
  String? postId;
  String? name;
  String? dateTime;
  String? image;
  String? text;

  CommentModel({
    this.uId,
    this.postId,
    this.name,
    this.image,
    this.dateTime,
    this.text,

  });

  CommentModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    postId = json['postId'];
    name = json['name'];
    text = json['text'];
    image = json['image'];
    dateTime = json['dateTime'];

  }

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'postId': postId,
      'name': name,
      'text': text,
      'image': image,
      'dateTime': dateTime,
    };
  }
}

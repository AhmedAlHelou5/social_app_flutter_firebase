class CommentModel {
  String? uId;
  String? commentId;
  String? name;
  String? dateTime;
  String? image;
  String? text;

  CommentModel({
    this.uId,
    this.commentId,
    this.name,
    this.image,
    this.dateTime,
    this.text,

  });

  CommentModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    commentId = json['commentId'];
    name = json['name'];
    text = json['text'];
    image = json['image'];
    dateTime = json['dateTime'];

  }

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'commentId': commentId,
      'name': name,
      'text': text,
      'image': image,
      'dateTime': dateTime,
    };
  }
}

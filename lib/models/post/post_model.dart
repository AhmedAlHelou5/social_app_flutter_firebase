class PostModel {
  String? uId;
  String? name;
  String? dateTime;
  String? image;
  String? text;
  String? postImage;

  PostModel({
         this.uId,
         this.name,
        this.image,
        this.dateTime,
        this.text,
        this.postImage
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    name = json['name'];
    text = json['text'];
    postImage = json['postImage'];
    image = json['image'];
    dateTime = json['dateTime'];

  }

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'name': name,
      'text': text,
      'image': image,
      'image': image,
      'dateTime': dateTime,
    };
  }
}

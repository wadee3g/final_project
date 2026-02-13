class Course {
  String? image;
  String? title;
  double? rating;

  Course({this.image, this.title, this.rating});

  Course.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    title = json['title'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['title'] = title;
    data['rating'] = rating;
    return data;
  }
}
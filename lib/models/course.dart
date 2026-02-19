class Course {
  int? id;
  String? title;
  String? image;
  String? category;
  double? rating;

  Course({this.id, this.title, this.image, this.category, this.rating});

  Course.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    category = json['category'];
    rating = json['rating'] != null
        ? double.parse(json['rating'].toString())
        : 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['title'] = title;
    data['image'] = image;
    data['category'] = category;
    data['rating'] = rating;
    return data;
  }
}

class Course {
  int? id;
  String? title;
  String? image;
  String? category;
  double? rating;
  String? description; // أضفنا الوصف هنا

  Course({this.id, this.title, this.image, this.category, this.rating, this.description});

  Course.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    category = json['category'];
    rating = json['rating'] != null ? double.parse(json['rating'].toString()) : 0.0;
    description = json['description']; // قراءة الوصف
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['image'] = image;
    data['category'] = category;
    data['rating'] = rating;
    data['description'] = description; // إرسال الوصف
    return data;
  }
}
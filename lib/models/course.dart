class Course {
  int? id;          // أضفنا الـ id (مهم جداً للحذف)
  String? title;
  String? image;
  String? category; // أضفنا التصنيف (علمي/ديني)
  double? rating;

  Course({this.id, this.title, this.image, this.category, this.rating});

  Course.fromJson(Map<String, dynamic> json) {
    id = json['id'];             // قراءة الـ id من قاعدة البيانات
    title = json['title'];
    image = json['image'];
    category = json['category']; // قراءة التصنيف
    rating = json['rating'] != null ? double.parse(json['rating'].toString()) : 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // لا نرسل الـ id عند الإضافة لأنه يتولد تلقائياً
    data['title'] = title;
    data['image'] = image;
    data['category'] = category;
    data['rating'] = rating;
    return data;
  }
}
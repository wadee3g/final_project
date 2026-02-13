import 'package:final_project/models/course.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Database {
  final supabase = Supabase.instance.client;

  // ==================== Auth  ====================

  Future<void> signUp({required String email, required String password}) async {
    await supabase.auth.signUp(email: email, password: password);
  }

  Future<void> login({required String email, required String password}) async {
    await supabase.auth.signInWithPassword(email: email, password: password);
  }

  // ==================== CRUD operation ====================

  Future<List<Course>> getCourse() async {
    final data = await supabase.from("course").select();

    List<Course> courseList = [];
    for (var element in data) {
      Course c1 = Course.fromJson(element);
      courseList.add(c1);
    }
    return courseList;
  }

  Future<void> addCourse({
    required String title,
    required String image,
    // required double rating,
    required String category,
  }) async {
    await supabase.from("course").insert({
      "title": title,
      "image": image,
      // "rating": rating,
      "category": category,
    });
  }

  Future<List<Course>> getCourses() async {
    final data = await supabase.from("course").select();
    return data.map((e) => Course.fromJson(e)).toList();
  }

  // ==================== Cart Operations ====================

  // 1. إضافة للسلة (تستخدم في زر الإضافة)
  Future<void> addToCart({required String title, required String image}) async {
    // نفترض أنك أنشأت جدولاً اسمه cart في Supabase بنفس أعمدة course
    await supabase.from("cart").insert({
      "title": title,
      "image": image,
      // يمكن إضافة user_id هنا مستقبلاً لربط السلة بالمستخدم
    });
  }

  // 2. جلب عناصر السلة (تستخدم في شاشة السلة)
  Future<List<Course>> getCartItems() async {
    final data = await supabase.from("cart").select();
    // نستخدم نفس مودل Course لأنه يحتوي نفس البيانات
    return data.map((e) => Course.fromJson(e)).toList();
  }

  // 3. حذف من السلة (تستخدم عند ضغط زر الحذف)
  Future<void> removeFromCart(int id) async {
    await supabase.from("cart").delete().eq('id', id);
  }
}

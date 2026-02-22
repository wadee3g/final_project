import 'package:final_project/models/course.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Database {
  final supabase = Supabase.instance.client;

  Future<void> signUp({required String email, required String password}) async {
    await supabase.auth.signUp(email: email, password: password);
  }

  Future<void> login({required String email, required String password}) async {
    await supabase.auth.signInWithPassword(email: email, password: password);
  }

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
    required String category,
    required String description, // أضفنا هذا السطر
  }) async {
    await supabase.from("course").insert({
      "title": title,
      "image": image,
      "category": category,
      "description": description, // أضفنا هذا السطر
    });
  }

  Future<List<Course>> getCourses() async {
    final data = await supabase.from("course").select();
    return data.map((e) => Course.fromJson(e)).toList();
  }

  Future<void> addToCart({required String title, required String image}) async {
    await supabase.from("cart").insert({"title": title, "image": image});
  }

  Future<List<Course>> getCartItems() async {
    final data = await supabase.from("cart").select();

    return data.map((e) => Course.fromJson(e)).toList();
  }

  Future<void> removeFromCart(int id) async {
    await supabase.from("cart").delete().eq('id', id);
  }
}

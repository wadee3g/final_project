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

  Future<void> addCourse({required String title,required String image})async{
    await supabase.from("course").insert({"title":title,"image":image});
  }
}
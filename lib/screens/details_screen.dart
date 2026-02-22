import 'package:final_project/models/course.dart';
import 'package:final_project/service/database.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final Course course;
  const DetailsScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.title ?? "تفاصيل الكتاب"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView( // أضفنا Scroll لتجنب مشكلة تجاوز الشاشة (Overflow)
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // محاذاة النص لليمين
          children: [
            // صورة الكتاب
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  course.image ?? "",
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (c, o, s) => const Icon(Icons.broken_image, size: 100, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // العنوان والتصنيف
            Text(
              course.title ?? "بدون عنوان", 
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "القسم: ${course.category ?? 'غير محدد'}", 
                style: const TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold)
              ),
            ),
            const SizedBox(height: 24),
            
            // قسم الوصف
            const Text(
              "نبذة عن الكتاب:", 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 10),
            Text(
              course.description ?? "لا يوجد وصف متاح لهذا الكتاب حالياً.", 
              style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87)
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      // زر السلة مثبت في الأسفل
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text("إضافة للسلة", style: TextStyle(fontSize: 18)),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
            ),
            onPressed: () async {
              try {
                await Database().addToCart(
                  title: course.title ?? "بدون عنوان",
                  image: course.image ?? "",
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("تمت الإضافة للسلة بنجاح!"), backgroundColor: Colors.green),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("فشل الإضافة: $e"), backgroundColor: Colors.red),
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
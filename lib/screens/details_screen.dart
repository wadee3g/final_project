import 'package:final_project/models/course.dart';
import 'package:final_project/service/database.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final Course course;
  const DetailsScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(course.title ?? "")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                course.image ?? "",
                width: double.infinity,
                fit: BoxFit.contain,
                errorBuilder: (c,o,s)=> const Icon(Icons.broken_image, size: 100),
              ),
            ),
            const SizedBox(height: 20),
            Text(course.title ?? "", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            Text("القسم: ${course.category}", style: const TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text("إضافة للسلة"),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
                onPressed: () async {
                  // هذا السطر يتصل بقاعدة البيانات ويرسل العنوان والصورة لجدول السلة (cart)
                  await Database().addToCart(
                    title: course.title ?? "بدون عنوان",
                    image: course.image ?? "",
                  );
                  
                  // فحص أمني: نتأكد أن المستخدم لم يغلق الشاشة قبل أن ينتهي الإنترنت من الإرسال
                  if (!context.mounted) return; 
                  
                  // إظهار رسالة النجاح
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("تمت الإضافة للسلة بنجاح!"))
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
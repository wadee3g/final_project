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
                errorBuilder: (c,o,s)=> Icon(Icons.broken_image, size: 100),
              ),
            ),
            SizedBox(height: 20),
            Text(course.title ?? "", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            Text("القسم: ${course.category}", style: TextStyle(fontSize: 18, color: Colors.grey)),
            SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.add_shopping_cart),
                label: Text("إضافة للسلة"),
                style: ElevatedButton.styleFrom(padding: EdgeInsets.all(15)),
                onPressed: () async {
                  await Database().addToCart(
                    title: course.title!,
                    image: course.image!,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("تمت الإضافة للسلة")));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
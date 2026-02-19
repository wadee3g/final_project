import 'package:final_project/models/course.dart';
import 'package:final_project/service/database.dart';
import 'package:flutter/material.dart';
import 'package:final_project/screens/cart_screen.dart';
import 'package:final_project/screens/details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // تم حذف متغيرات الإضافة (Controllers) لأن المستخدم العادي لا يجب أن يضيف كتباً للتطبيق

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("متجر الكتب"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "كتب علمية", icon: Icon(Icons.science)),
              Tab(text: "كتب دينية", icon: Icon(Icons.mosque)),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                // // هذا السطر ينقلك للسلة عند الضغط على الأيقونة العلوية
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
              },
            )
          ],
        ),
        body: FutureBuilder(
          // هنا نجلب البيانات من قاعدة البيانات لعرضها في المتجر
          future: Database().getCourse(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("حدث خطأ: ${snapshot.error}"));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("المتجر فارغ حالياً"));
            }

            final allBooks = snapshot.data!;

            // تصفية الكتب بناءً على القسم لعرضها في التبويب الصحيح
            final scienceBooks = allBooks.where((b) => b.category == 'علمية').toList();
            final religiousBooks = allBooks.where((b) => b.category == 'دينية').toList();

            return TabBarView(
              children: [
                _buildBookGrid(scienceBooks),
                _buildBookGrid(religiousBooks),
              ],
            );
          },
        ),
        // تم حذف زر الـ FloatingActionButton بالكامل من هنا
      ),
    );
  }

  // دالة بناء شبكة الكتب (كما هي لم تتغير)
  Widget _buildBookGrid(List<Course> books) {
    if (books.isEmpty) {
      return const Center(child: Text("لا توجد كتب في هذا القسم"));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: books.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final book = books[index];
        return InkWell(
          onTap: () {
            // إرسال بيانات الكتاب المختار إلى شاشة التفاصيل
            Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(course: book)));
          },
          child: Card(
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Image.network(
                    book.image ?? "",
                    fit: BoxFit.cover,
                    errorBuilder: (c, o, s) => const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    book.title ?? "بدون عنوان",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
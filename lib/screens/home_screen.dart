import 'package:final_project/models/course.dart';
import 'package:final_project/service/database.dart';
import 'package:final_project/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
// تأكد أنك أنشأت هذه الملفات، أو علق هذه الأسطر مؤقتاً إذا لم تنشئها بعد
import 'package:final_project/screens/cart_screen.dart';
import 'package:final_project/screens/details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // متحكمات النصوص للإضافة
  var titleController = TextEditingController();
  var imageController = TextEditingController();

  // متغير لتخزين القسم المختار (افتراضياً: علمية)
  String selectedCategory = 'علمية';

  @override
  void dispose() {
    titleController.dispose();
    imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. DefaultTabController: المسؤول عن التحكم بالتبويبات
    return DefaultTabController(
      length: 2, // عدد الأقسام (علمية + دينية)
      child: Scaffold(
        appBar: AppBar(
          title: const Text("متجر الكتب"),
          // 2. TabBar: شريط العناوين في الأعلى
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
                // الانتقال لصفحة السلة
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
              },
            )
          ],
        ),
        // 3. FutureBuilder: جلب البيانات مرة واحدة
        body: FutureBuilder(
          future: Database().getCourse(), // تأكد أن دالة الجلب في الداتابيز اسمها صحيح
          builder: (context, snapshot) {
            // حالة التحميل
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            // حالة الخطأ
            if (snapshot.hasError) {
              return Center(child: Text("حدث خطأ: ${snapshot.error}"));
            }
            // حالة عدم وجود بيانات
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("لا توجد كتب مضافة بعد"));
            }

            final allBooks = snapshot.data!;

            // 4. الفلترة: تقسيم الكتب لقائمتين بناءً على الـ category
            // ملاحظة: هذا يتطلب أن تكون قد أضفت حقل category في المودل والداتابيز
            final scienceBooks = allBooks.where((b) => b.category == 'علمية').toList();
            final religiousBooks = allBooks.where((b) => b.category == 'دينية').toList();

            // 5. TabBarView: عرض الشاشات
            return TabBarView(
              children: [
                _buildBookGrid(scienceBooks),   // الشاشة الأولى (علمية)
                _buildBookGrid(religiousBooks), // الشاشة الثانية (دينية)
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: _showAddDialog,
        ),
      ),
    );
  }

  // دالة مساعدة لبناء الشبكة (Grid) حتى لا نكرر الكود
  Widget _buildBookGrid(List<Course> books) {
    if (books.isEmpty) {
      return const Center(child: Text("لا توجد كتب في هذا القسم"));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: books.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8, // نسبة الطول للعرض (لتحسين شكل البطاقة)
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final book = books[index];
        return InkWell(
          onTap: () {
            // الانتقال لصفحة التفاصيل عند الضغط
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

  // دالة إظهار نافذة الإضافة
  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        // StatefulBuilder: ضروري جداً لتحديث القائمة المنسدلة (Dropdown) داخل الديالوج
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // يأخذ أقل حجم ممكن
                  children: [
                    const Text("إضافة كتاب جديد", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 24),
                    TextFieldWidget(
                      hint: "عنوان الكتاب",
                      icon: const Icon(Icons.book),
                      controller: titleController,
                    ),
                    const SizedBox(height: 12),
                    TextFieldWidget(
                      hint: "رابط الصورة",
                      icon: const Icon(Icons.image),
                      controller: imageController,
                    ),
                    const SizedBox(height: 12),
                    
                    // القائمة المنسدلة لاختيار القسم
                    Row(
                      children: [
                        const Text("القسم: ", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 10),
                        DropdownButton<String>(
                          value: selectedCategory,
                          items: ['علمية', 'دينية'].map((String val) {
                            return DropdownMenuItem(value: val, child: Text(val));
                          }).toList(),
                          onChanged: (val) {
                            setStateDialog(() {
                              selectedCategory = val!;
                            });
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          await Database().addCourse(
                            title: titleController.text,
                            image: imageController.text,
                            category: selectedCategory, // نمرر القسم المختار
                          );
                          
                          if (context.mounted) {
                            Navigator.pop(context); // إغلاق النافذة
                            setState(() {}); // تحديث الشاشة الرئيسية لرؤية الكتاب الجديد
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("تمت الإضافة بنجاح")),
                            );
                            
                            // تنظيف الحقول
                            titleController.clear();
                            imageController.clear();
                          }
                        } catch (e) {
                          print("Error adding course: $e");
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("فشل الإضافة: $e"), backgroundColor: Colors.red),
                            );
                          }
                        }
                      },
                      child: const Text("حفظ الكتاب"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
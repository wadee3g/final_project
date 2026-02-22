import 'package:final_project/models/course.dart';
import 'package:final_project/service/database.dart';
import 'package:final_project/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:final_project/screens/cart_screen.dart';
import 'package:final_project/screens/details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var titleController = TextEditingController();
  var imageController = TextEditingController();
  var descriptionController = TextEditingController(); // متحكم الوصف الجديد

  String selectedCategory = 'علمية';

  @override
  void dispose() {
    titleController.dispose();
    imageController.dispose();
    descriptionController.dispose(); // تنظيف متحكم الوصف
    super.dispose();
  }

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
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
              },
            )
          ],
        ),
        body: FutureBuilder(
          future: Database().getCourse(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("حدث خطأ: ${snapshot.error}"));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("لا توجد كتب مضافة بعد"));
            }

            final allBooks = snapshot.data!;
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
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: _showAddDialog,
        ),
      ),
    );
  }

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

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              child: SingleChildScrollView( // أضفنا Scroll لتجنب مشكلة الكيبورد
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                      // هذا هو حقل الوصف الجديد
                      TextFieldWidget(
                        hint: "وصف الكتاب",
                        icon: const Icon(Icons.description),
                        controller: descriptionController,
                      ),
                      const SizedBox(height: 12),
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
                              category: selectedCategory,
                              description: descriptionController.text, // نرسل الوصف لقاعدة البيانات
                            );
                            
                            if (context.mounted) {
                              Navigator.pop(context);
                              setState(() {}); 
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("تمت الإضافة بنجاح"), backgroundColor: Colors.green),
                              );
                              
                              titleController.clear();
                              imageController.clear();
                              descriptionController.clear();
                            }
                          } catch (e) {
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
              ),
            );
          },
        );
      },
    );
  }
}
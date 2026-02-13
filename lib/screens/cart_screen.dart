import 'package:final_project/models/course.dart';
import 'package:final_project/service/database.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("سلة المشتريات"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: FutureBuilder(
        // تأكد أن هذه الدالة موجودة في database.dart
        future: Database().getCartItems(),
        builder: (context, snapshot) {
          // 1. حالة التحميل
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. حالة الخطأ
          if (snapshot.hasError) {
            return Center(child: Text("حدث خطأ: ${snapshot.error}"));
          }

          // 3. حالة السلة فارغة
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey[300]),
                  const SizedBox(height: 20),
                  const Text("السلة فارغة حالياً", style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            );
          }

          final cartItems = snapshot.data!;

          // 4. عرض العناصر
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  // صورة الكتاب
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.image ?? "",
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (c, o, s) => const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                    ),
                  ),
                  // عنوان الكتاب
                  title: Text(
                    item.title ?? "بدون عنوان",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // زر الحذف
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () async {
                      // حذف العنصر وتحديث الشاشة
                      await Database().removeFromCart(item.id!); // تأكد أن المودل يحتوي على id
                      setState(() {
                        // إعادة بناء الشاشة لرؤية التحديث
                      });
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("تم حذف الكتاب من السلة")),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      // زر إتمام الشراء (شكلي حالياً)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("تم إرسال الطلب بنجاح!")),
            );
          },
          child: const Text("إتمام الشراء", style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
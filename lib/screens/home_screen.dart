import 'package:final_project/service/database.dart';
import 'package:final_project/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var titleController = TextEditingController();
  var imageController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: Database().getCourse(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return GridView.builder(
              itemCount: snapshot.data!.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                final course = snapshot.data![index];
                return Card(
                  child: Column(
                    children: [
                      Image.network(course.image ?? ""),
                      Text(course.title!),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 24,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("add course"),
                      SizedBox(height: 24),
                      TextFieldWidget(
                        hint: "title",
                        icon: Icon(Icons.book),
                        controller: titleController,
                      ),
                      SizedBox(height: 24),
                      TextFieldWidget(
                        hint: "image",
                        icon: Icon(Icons.image),
                        controller: imageController,
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () async {
                          await Database().addCourse(
                            title: titleController.text,
                            image: imageController.text,
                          );
                          Navigator.pop(context);
                          setState(() {
                          });
                          titleController.clear();
                          imageController.clear();
                        },
                        child: Text("Add"),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
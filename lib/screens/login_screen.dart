import 'package:final_project/extension/nav.dart';
import 'package:final_project/screens/home_screen.dart';
import 'package:final_project/screens/signup_screen.dart';
import 'package:final_project/service/database.dart';
import 'package:final_project/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            height: height * 0.5,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black, blurRadius: 1)],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Login",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                TextFieldWidget(
                  hint: "enter your email",
                  icon: Icon(Icons.email),
                  controller: emailController,
                ),
                TextFieldWidget(
                  hint: "enter your password",
                  icon: Icon(Icons.password),
                  controller: passwordController,
                  isObscure: true,
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await Database().login(
                        email: emailController.text,
                        password: passwordController.text,
                      );

                      if (context.mounted) {
                        context.pushAndDelete(HomeScreen());
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                  child: Text("login"),
                ),
                TextButton(
                  onPressed: () async {
                    context.pushAndDelete(SignupScreen());
                  },
                  child: Text("don't have an account? signup"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

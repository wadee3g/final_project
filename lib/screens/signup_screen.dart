import 'package:final_project/extension/nav.dart';
import 'package:final_project/screens/login_screen.dart';
import 'package:final_project/service/database.dart';
import 'package:final_project/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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
      appBar: AppBar(backgroundColor: Colors.orange.shade300),
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
                  "Sign up",
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
                    await Database().signUp(
                      email: emailController.text,
                      password: passwordController.text,
                    );
                    context.pushAndDelete(LoginScreen());
                  },
                  child: Text("Sign up"),
                ),
                TextButton(
                  onPressed: () {
                    context.pushAndDelete(LoginScreen());
                  },
                  child: Text("have an account? login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

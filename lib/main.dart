import 'package:final_project/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://suceievwapfdjgwzkimm.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN1Y2VpZXZ3YXBmZGpnd3praW1tIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA5NzM1MjYsImV4cCI6MjA4NjU0OTUyNn0.57nMZSZWolppf2cBGj8KoIZkGBjit9PtfPNpmkjXsY0",
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: LoginScreen());
  }
}

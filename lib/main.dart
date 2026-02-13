import 'package:final_project/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
 WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://suceievwapfdjgwzkimm.supabase.co", // change to your own url
    anonKey: "sb_publishable_BondbblQEMuJ5aBuVN-kSQ_3ZFaiwsU", // change to your own key
  );


  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen()
    );
  }
}
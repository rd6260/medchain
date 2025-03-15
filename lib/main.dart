import 'package:flutter/material.dart';
// import 'package:medchain/screens/home_screen.dart';
import 'package:medchain/supabase_apis.dart';
import 'package:medchain/utils/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  //supabase setup
  await Supabase.initialize(
    anonKey: SUPABASE_ANONKEY, 
    url: SUPABASE_URL,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}

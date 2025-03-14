import 'package:flutter/material.dart';
import 'package:medchain/screens/home_screen.dart';
import 'package:medchain/screens/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // Listen to auth state changes
      stream: Supabase.instance.client.auth.onAuthStateChange,
      // Build page according to auth state
      builder: (context, snapshot) {
        // Loading....
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Check if there's a valid session currently
        final Session? session =
            snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}

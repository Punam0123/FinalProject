import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'welcome_screen.dart';
import 'login_screen.dart';  // Import the login screen
import 'reg_screen.dart';  // Import the signup screen
import 'home_screen.dart';  // Import home screen

void main() {
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //   sta vtusBarColor: Colors.transparent,
  // ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'inter',
        useMaterial3: true,
      ),
      initialRoute: '/',  // Set initial route
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),// Define login screen
        '/register': (context) => const RegScreen(),  // Define signup screen 
        '/home': (context) =>  HomeScreen(),   // Define home screen
      },
    );
  }
}

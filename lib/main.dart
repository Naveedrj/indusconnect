import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:indusconnect/Screens/Industrilists/Dashboard.dart';
import 'Screens/LogIn.dart';
import 'package:indusconnect/Screens/Industrilists/Homepage.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyCOt_dEYjDjDCMVwpeNSF_iAbnFPgnPvQ8',
        appId: '1:994534113613:android:d7f60e90c4fa83576d7704',
        messagingSenderId: '994534113613',
        projectId: 'indusconnectapp',
        storageBucket: 'indusconnectapp.appspot.com'
    )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3), // Adjust animation duration if needed
    );
    _animationController.forward();

    Timer(Duration(seconds: 3), () => checkUserAuthentication()); // Check user authentication after 3 seconds
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> checkUserAuthentication() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // User is already logged in, navigate to dashboard
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homepage()));
    } else {
      // User is not logged in, navigate to login screen
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LogIn()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _animationController,
          child: MyAnimatedLogo(), // Replace with your logo widget
        ),
      ),
    );
  }
}

class MyAnimatedLogo extends StatelessWidget {
  // Implement your animated logo widget here
  // Using an AnimatedContainer or TweenAnimation is recommended
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Icon(
        Icons.add_business,
        size: 100,
        color: Colors.teal,
      ),
    );
  }
}

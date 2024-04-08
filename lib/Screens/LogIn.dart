import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:indusconnect/Screens/Industrilists//Homepage.dart';
import 'SignUp.dart';
import '../Custom/Custom.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  Future<void> login(String email, String password) async {
    String message = '';

    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        // User login successful, navigate to Homepage
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homepage()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          message = 'Invalid email or password';
        } else {
          message = 'Error: ${e.message}';
          print(message);
        }
        // Showing a Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } catch (e) {
        message = 'Error: $e';
        print(message);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } else {
      // Showing a Snackbar for empty fields
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User credentials cannot be empty')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'Log In',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Custom.textfield(controller: usernameCtrl, labelText: 'Email or Phone', suffixIcon: Icons.email),
                Custom.box(height: 10, width: 0),
                Custom.textfield(controller: passwordCtrl, labelText: 'Password', suffixIcon: Icons.password),
                Custom.box(height: 10, width: 0),
                Custom.button(
                  onPress: () {
                    login(usernameCtrl.text, passwordCtrl.text);
                  },
                  text: 'Log In',
                  backgroundColor: '0xFF008080',
                  textColor: '0xFFFFFFFF',
                  length: 100,
                  textSize: 18,
                  radius: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Create a new account'),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

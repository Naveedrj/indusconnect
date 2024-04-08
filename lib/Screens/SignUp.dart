import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:indusconnect/Screens/Industrilists/Homepage.dart';
import 'package:indusconnect/Screens/LogIn.dart';
import '../Custom/Custom.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController company = TextEditingController();
  TextEditingController phone = TextEditingController();

  void signup(String email, String password, String username, String company, String location, String phone) async {
    String message = '';

    if (email.isNotEmpty && password.isNotEmpty && username.isNotEmpty) {
      try {
        UserCredential? userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Add user details to Firestore
        addUserToFirestore(location, company, phone, username);

        // Navigate to Homepage
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Homepage()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          message = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          message = 'This email is already registered';
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
      print('Empty fields');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User credentials cannot be empty')),
      );
    }
  }

  void addUserToFirestore(String address, String company, String contact, String owner) {
    try {
      FirebaseFirestore.instance.collection('Indus').doc(FirebaseAuth.instance.currentUser!.uid).collection('profile').add({
        'Address': address,
        'Company': company,
        'Contact': contact,
        'Owner': owner,
      }).then((value) {
        print('User added to Firestore successfully!');
      }).catchError((error) {
        print('Failed to add user to Firestore: $error');
      });
    } catch (e) {
      print('Error adding user to Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'Sign Up',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Custom.box(height: 10, width: 0),
              Custom.textfield(controller: username, labelText: 'Username', suffixIcon: Icons.text_fields),
              Custom.box(height: 10, width: 0),
              Custom.textfield(controller: company, labelText: 'Company Name', suffixIcon: Icons.text_fields),
              Custom.box(height: 10, width: 0),
              Custom.textfield(controller: location, labelText: 'Add Location', suffixIcon: Icons.pin_drop),
              Custom.box(height: 10, width: 0),
              Custom.textfield(controller: email, labelText: 'Email', suffixIcon: Icons.email),
              Custom.box(height: 10, width: 0),
              Custom.textfield(controller: pass, labelText: 'Password', suffixIcon: Icons.password),
              Custom.box(height: 10, width: 0),
              Custom.textfield(controller: phone, labelText: 'Contact number', suffixIcon: Icons.phone),
              Custom.box(height: 10, width: 0),
              Custom.button(

                onPress: () {
                  signup(email.text, pass.text, username.text, company.text, location.text, phone.text);
                },
                text: 'Sign Up',
                backgroundColor: '0xFF008080',
                textColor: '0xFFFFFFFF',
                length: 100,
                textSize: 18,
                radius: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an Account'),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LogIn()));
                    },
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        color: Colors.teal,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

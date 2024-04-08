import 'package:flutter/material.dart';
import 'AddProducts.dart';

class Dashborad extends StatefulWidget {
  const Dashborad({super.key});

  @override
  State<Dashborad> createState() => _DashboradState();
}

class _DashboradState extends State<Dashborad> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:  Container(
        child: Column(),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const AddProducts()));
      },
      child: Icon(Icons.add), backgroundColor: Colors.teal,
      ),
    );
  }
}
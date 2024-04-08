// Import necessary packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProductsScreen extends StatefulWidget {
  const UserProductsScreen({Key? key}) : super(key: key);

  @override
  _UserProductsScreenState createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Indus')
            .doc(currentUser!.uid)
            .collection('Products')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No products added yet.'),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
              document.data() as Map<String, dynamic>;
              return InkWell(
                onTap: () {
                  // Navigate to the product screen with the clicked product
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductScreen(data: data),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.all(8),
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display the image using Image.network
                        Image.network(
                          data['ImageURL'], // Provide the field containing the image URL
                          width: 150, // Adjust width as needed
                          height: 150, // Adjust height as needed
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 8),
                        Text(
                          data['Name'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          data['Description'],
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Price: ${data['Price']}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class ProductScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const ProductScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data['Name']),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the image using Image.network
            Image.network(
              data['ImageURL'], // Provide the field containing the image URL
              width: 200, // Adjust width as needed
              height: 200, // Adjust height as needed
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              data['Description'],
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Price: ${data['Price']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // Add more details here if needed
          ],
        ),
      ),
    );
  }
}

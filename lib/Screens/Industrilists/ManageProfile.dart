import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageProfile extends StatefulWidget {
  @override
  _ManageProfileState createState() => _ManageProfileState();
}

class _ManageProfileState extends State<ManageProfile> {
  TextEditingController addressController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController ownerController = TextEditingController();
  FirebaseAuth firebaseAuth=FirebaseAuth.instance;

  bool fieldsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Indus').doc(firebaseAuth.currentUser!.uid).collection('profile').snapshots(),
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
              child: Text('No data available.'),
            );
          }
          // Assuming you want to display data of the first document in Firestore
          // You can adjust the logic to display data from other documents
          var data = snapshot.data!.docs[0].data() as Map<String, dynamic>;
          // Update text field controllers with data from Firestore
          addressController.text = data['Address'];
          companyController.text = data['Company'];
          contactController.text = data['Contact'];
          ownerController.text = data['Owner'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                  enabled: fieldsEnabled, // Enable/disable based on state
                ),
                TextField(
                  controller: companyController,
                  decoration: InputDecoration(labelText: 'Company'),
                  enabled: fieldsEnabled, // Enable/disable based on state
                ),
                TextField(
                  controller: contactController,
                  decoration: InputDecoration(labelText: 'Contact'),
                  enabled: fieldsEnabled, // Enable/disable based on state
                ),
                TextField(
                  controller: ownerController,
                  decoration: InputDecoration(labelText: 'Owner'),
                  enabled: fieldsEnabled, // Enable/disable based on state
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: fieldsEnabled ? updateData : null, // Bind update method
                    child: Text('Update Data'),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        fieldsEnabled = !fieldsEnabled; // Toggle field enable/disable
                      });
                    },
                    child: Text(fieldsEnabled ? 'Disable Fields' : 'Enable Fields'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void updateData() {
    try {
      FirebaseFirestore.instance.collection('Indus').doc(FirebaseAuth.instance.currentUser!.uid).collection('profile').get().then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          // Assuming there's only one document per user
          String docId = querySnapshot.docs.first.id;
          FirebaseFirestore.instance.collection('Indus').doc(FirebaseAuth.instance.currentUser!.uid).collection('profile').doc(docId).update({
            'Address': addressController.text,
            'Company': companyController.text,
            'Contact': contactController.text,
            'Owner': ownerController.text,
          }).then((value) {
            print('User updated in Firestore successfully!');
          }).catchError((error) {
            print('Failed to update user in Firestore: $error');
          });
        } else {
          print('No document found for the current user.');
        }
      });
    } catch (e) {
      print('Error updating user in Firestore: $e');
    }
  }

  @override
  void dispose() {
    // Dispose text field controllers when the widget is disposed
    addressController.dispose();
    companyController.dispose();
    contactController.dispose();
    ownerController.dispose();
    super.dispose();
  }
}

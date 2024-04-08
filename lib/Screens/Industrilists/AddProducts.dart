import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:indusconnect/Custom/Custom.dart';

class AddProducts extends StatefulWidget {
  const AddProducts({Key? key}) : super(key: key);

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  TextEditingController productName = TextEditingController();
  TextEditingController productPrice = TextEditingController();
  TextEditingController productDescription = TextEditingController();
  TextEditingController category = TextEditingController();
  late File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print("_image");
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String> uploadImage() async {
    print("1");
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('products')
        .child('${productName.text}/${DateTime.now().millisecondsSinceEpoch.toString()}');

    // Create metadata for the image specifying its content type
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': _image.path},
    );

    print("2");
    // Use putFile method with metadata
    UploadTask uploadTask = storageReference.putFile(
      _image,
      metadata,
    );
    print("3");
    await uploadTask.whenComplete(() => print('File Uploaded'));
    String imageURL = await storageReference.getDownloadURL();
    return imageURL;
  }

  void addProductToFirestore() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print("Gift1");
        String imageURL = await uploadImage();
        print("Gift2");
        await FirebaseFirestore.instance.collection('Indus').doc(user.uid).collection('Products').add({
          'Category': category.text,
          'Description': productDescription.text,
          'Name': productName.text,
          'Price': productPrice.text,
          'ImageURL': imageURL,
        });
        print('Product added successfully!');
        // Optionally, you can show a success message or navigate to another screen.
      } else {
        print('User is not logged in!');
        // Handle the case where the user is not logged in.
      }
    } catch (e) {
      print('Error adding product to Firestore: $e');
      // Handle errors while adding the product to Firestore.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'Add Product',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Custom.textfield(controller: productName, labelText: 'Add Product name', suffixIcon: Icons.add),
              const SizedBox(height: 10),
              Custom.textfield(controller: productPrice, labelText: 'Add Price', suffixIcon: Icons.add),
              const SizedBox(height: 10),
              Custom.textfield(controller: category, labelText: 'Add  Category', suffixIcon: Icons.add),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.teal),
                ),
                child: TextField(
                  controller: productDescription,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Enter Description',
                    labelStyle: TextStyle(
                      color: Color(0xFF008080),
                    ),
                    suffixIcon: Icon(Icons.add),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: getImage,
                child: const Text('Select Image'),
              ),
              const SizedBox(height: 10),
              Custom.button(
                onPress: addProductToFirestore,
                text: 'Add Item',
                backgroundColor: '0xFF008080',
                textColor: '0xFFFFFFFF',
                length: 100,
                textSize: 18,
                radius: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

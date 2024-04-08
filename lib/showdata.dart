import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShowData extends StatefulWidget {
  const ShowData({Key? key}) : super(key: key);

  @override
  State<ShowData> createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _usersStream;

  @override
  void initState() {
    super.initState();

    // Define the stream for the users collection
    _usersStream = FirebaseFirestore.instance.collection("users").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Show Data"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _usersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No data found."));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var userData = snapshot.data!.docs[index].data();

                // Fetch education data from subcollection
                var userEducationCollection = FirebaseFirestore.instance
                    .collection('users')
                    .doc(snapshot.data!.docs[index].id)
                    .collection('user_education');

                // Fetch experience data from subcollection
                var userWorkCollection = FirebaseFirestore.instance
                    .collection('users')
                    .doc(snapshot.data!.docs[index].id)
                    .collection('user_work');

                // Fetch skills data from subcollection
                var userSkillsCollection = FirebaseFirestore.instance
                    .collection('users')
                    .doc(snapshot.data!.docs[index].id)
                    .collection('user_skills');

                // Fetch address data from details subcollection
                var addressCollection = FirebaseFirestore.instance
                    .collection('users')
                    .doc(snapshot.data!.docs[index].id)
                    .collection('details');

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(userData['display_name'] ?? 'No Name'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userData['email'] ?? 'No Email',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            userData['shortDescription'] ?? 'No Short Description',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Address:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: addressCollection.snapshots(),
                      builder: (context, addressSnapshot) {
                        if (addressSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text('Loading...');
                        } else if (addressSnapshot.hasError) {
                          return Text('Error: ${addressSnapshot.error}');
                        } else if (!addressSnapshot.hasData ||
                            addressSnapshot.data!.docs.isEmpty) {
                          return Text('No address found.');
                        } else {
                          var addressData =
                              addressSnapshot.data!.docs.first.data();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('City: ${addressData['city']}'),
                              Text('Country: ${addressData['country']}'),
                              Text('Postal: ${addressData['postal']}'),
                              Text('State: ${addressData['state']}'),
                            ],
                          );
                        }
                      },
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Education:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: userEducationCollection.snapshots(),
                      builder: (context, userEducationSnapshot) {
                        if (userEducationSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text('Loading...');
                        } else if (userEducationSnapshot.hasError) {
                          return Text(
                              'Error: ${userEducationSnapshot.error}');
                        } else if (!userEducationSnapshot.hasData ||
                            userEducationSnapshot.data!.docs.isEmpty) {
                          return Text('No education data found.');
                        } else {
                          var educationData =
                              userEducationSnapshot.data!.docs.first.data();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Degree: ${educationData['degree']}'),
                              Text(
                                  'Institute: ${educationData['institute']}'),
                              Text('Major: ${educationData['major']}'),
                              Text('Start Date: ${educationData['start_date']}'),
                              Text('End Date: ${educationData['end_date']}'),
                            ],
                          );
                        }
                      },
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Experience:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: userWorkCollection.snapshots(),
                      builder: (context, userWorkSnapshot) {
                        if (userWorkSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text('Loading...');
                        } else if (userWorkSnapshot.hasError) {
                          return Text('Error: ${userWorkSnapshot.error}');
                        } else if (!userWorkSnapshot.hasData ||
                            userWorkSnapshot.data!.docs.isEmpty) {
                          return Text('No experience data found.');
                        } else {
                          var experienceData =
                              userWorkSnapshot.data!.docs.first.data();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Company Name: ${experienceData['company_name']}'),
                              Text(
                                  'Start Date: ${experienceData['start_date']}'),
                              Text(
                                  'End Date: ${experienceData['end_date']}'),
                              Text(
                                  'Job Title: ${experienceData['job_title']}'),
                              Text(
                                  'Responsibilities: ${experienceData['responsibilities']}'),
                            ],
                          );
                        }
                      },
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Skills:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: userSkillsCollection.snapshots(),
                      builder: (context, userSkillsSnapshot) {
                        if (userSkillsSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text('Loading...');
                        } else if (userSkillsSnapshot.hasError) {
                          return Text('Error: ${userSkillsSnapshot.error}');
                        } else if (!userSkillsSnapshot.hasData ||
                            userSkillsSnapshot.data!.docs.isEmpty) {
                          return Text('No skills data found.');
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: userSkillsSnapshot.data!.docs
                                .map((doc) {
                              var skillsData = doc.data();
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Soft Skills: ${skillsData['soft_skills'] ?? 'No Soft Skills'}'),
                                  Text(
                                      'Tech Skills: ${skillsData['tech_skills'] ?? 'No Tech Skills'}'),
                                ],
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                    Divider(),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ShowData(),
  ));
}

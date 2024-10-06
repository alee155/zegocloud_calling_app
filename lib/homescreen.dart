import 'package:call/callinvitescree.dart'; // Ensure this import is correct
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<List<Map<String, dynamic>>> _fetchUsers() async {
    final List<Map<String, dynamic>> users = [];

    try {
      final QuerySnapshot userSnapshots =
          await FirebaseFirestore.instance.collection('User').get();

      for (var doc in userSnapshots.docs) {
        users.add(doc.data() as Map<String, dynamic>);
      }
    } catch (error) {
      print('Error fetching users: $error');
    }

    return users;
  }

  Future<String?> _getCurrentUserId() async {
    // Fetch the current user's ID using FirebaseAuth
    User? currentUser = FirebaseAuth.instance.currentUser;
    return currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getCurrentUserId(),
      builder: (context, userIdSnapshot) {
        if (userIdSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (userIdSnapshot.hasError) {
          return Center(child: Text('Error: ${userIdSnapshot.error}'));
        }

        final currentUserId = userIdSnapshot.data;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Users'),
          ),
          body: FutureBuilder<List<Map<String, dynamic>>>(
            future: _fetchUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final users = snapshot.data ?? [];

              if (users.isEmpty) {
                return const Center(child: Text('No users found.'));
              }

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(user['email'] ?? 'No Email'),
                      subtitle: Text(user['name'] ?? 'No Name'),
                      trailing: IconButton(
                        icon: const Icon(Icons.videocam),
                        onPressed: () {
                          // Handle video call initiation here
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CallinviteScreen(
                                currentUserId: currentUserId!,
                                userName: user['name'] ?? 'No Name',
                                inviteeUserId: user['userId'] ?? 'No ID',
                              ),
                            ),
                          );
                        },
                      ),
                      onTap: () {
                        print(
                            '::::::::::::::::::::::::::::::::::::::::::::::::::::');
                        print('User Details:');
                        print('Created At: ${user['createdAt']}');
                        print('Email: ${user['email']}');
                        print('Name: ${user['name']}');
                        print('Phone Number: ${user['phoneNumber']}');
                        print('User ID: ${user['userId']}');
                        print(
                            '::::::::::::::::::::::::::::::::::::::::::::::::::::');
                      },
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

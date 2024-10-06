import 'package:call/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  String _name = '';
  String _phoneNumber = ''; // New field for phone number

  bool _isLoading = false;

  void _signupUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Create user with Firebase Auth
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _email.trim(),
          password: _password.trim(),
        );

        // Get the user ID
        String? userId = userCredential.user?.uid;

        // Add user data to Firestore
        await _firestore.collection('User').doc(userId).set({
          'email': _email.trim(),
          'name': _name.trim(),
          'createdAt': DateTime.now(),
          'userId': userId, // Upload user document ID
          'phoneNumber': _phoneNumber.trim(), // Add phone number field
        });

        // Navigate to another screen after successful signup
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } catch (error) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${error.toString()}'),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (value) {
                  _name = value.trim();
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (value) {
                  _email = value.trim();
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged: (value) {
                  _password = value.trim();
                },
                validator: (value) {
                  if (value == null || value.trim().length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone Number'),
                onChanged: (value) {
                  _phoneNumber = value.trim();
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _signupUser,
                      child: const Text('Sign Up'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
